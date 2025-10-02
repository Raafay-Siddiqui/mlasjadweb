"""Utility to copy data from the legacy SQLite database into PostgreSQL.

Usage
-----
python scripts/sqlite_to_postgres.py \
    --sqlite /path/to/site.db \
    --postgres postgresql+psycopg2://user:password@localhost:5432/mlasjad

The destination PostgreSQL database must already exist and have its schema
created (run `flask db upgrade` with the `DATABASE_URL` pointing at Postgres
before running this script).
"""
from __future__ import annotations

import argparse
from pathlib import Path

from sqlalchemy import Integer, MetaData, create_engine, func, select, text
from sqlalchemy.engine import Engine


EXCLUDED_TABLES = {"sqlite_sequence"}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--sqlite",
        required=True,
        help="Path to the SQLite database file (e.g. instance/site.db)",
    )
    parser.add_argument(
        "--postgres",
        required=True,
        help="PostgreSQL SQLAlchemy URL (postgresql+psycopg2://user:pass@host/db)",
    )
    return parser.parse_args()


def reflect(engine: Engine) -> MetaData:
    metadata = MetaData()
    metadata.reflect(bind=engine)
    return metadata


def main() -> None:
    args = parse_args()

    sqlite_path = Path(args.sqlite).expanduser().resolve()
    if not sqlite_path.exists():
        raise SystemExit(f"SQLite database not found: {sqlite_path}")

    sqlite_url = f"sqlite:///{sqlite_path}"
    sqlite_engine = create_engine(sqlite_url)
    pg_engine = create_engine(args.postgres)

    sqlite_meta = reflect(sqlite_engine)
    pg_meta = reflect(pg_engine)

    missing_tables = [t for t in sqlite_meta.tables if t not in pg_meta.tables]
    if missing_tables:
        raise SystemExit(
            "Destination database is missing tables: " + ", ".join(sorted(missing_tables))
        )

    replica_mode = False
    try:
        with pg_engine.connect().execution_options(isolation_level="AUTOCOMMIT") as autocommit_conn:
            autocommit_conn.execute(text("SET session_replication_role = 'replica';"))
            replica_mode = True
    except Exception as exc:  # pragma: no cover - superuser only feature
        print(
            "WARNING: Could not enable session_replication_role=replica. "
            "Proceeding without it. (", exc, ")"
        )

    with sqlite_engine.connect() as sqlite_conn, pg_engine.begin() as pg_conn:

        for table in sqlite_meta.sorted_tables:
            if table.name in EXCLUDED_TABLES:
                continue

            rows = [dict(row) for row in sqlite_conn.execute(table.select()).mappings().all()]
            if not rows:
                continue

            pg_table = pg_meta.tables[table.name]
            for row in rows:
                for column in table.columns:
                    value = row.get(column.name)
                    if value is None:
                        continue
                    if isinstance(column.type, Integer) and not isinstance(value, int):
                        try:
                            row[column.name] = int(value)
                        except (TypeError, ValueError):
                            row[column.name] = None
            pg_conn.execute(pg_table.insert(), rows)

        if replica_mode:
            with pg_engine.connect().execution_options(isolation_level="AUTOCOMMIT") as autocommit_conn:
                autocommit_conn.execute(text("SET session_replication_role = DEFAULT;"))

        # Ensure sequences are aligned with inserted primary key values
        for table in pg_meta.sorted_tables:
            pk_cols = [col for col in table.primary_key.columns if col.autoincrement]
            if not pk_cols:
                continue

            pk_col = pk_cols[0]
            seq_sql = text(
                "SELECT pg_get_serial_sequence(:table_name, :column_name)"
            )
            seq_name = pg_conn.execute(
                seq_sql, {"table_name": table.name, "column_name": pk_col.name}
            ).scalar()

            if not seq_name:
                continue

            max_id = pg_conn.execute(
                select(func.max(table.c[pk_col.name]))
            ).scalar()

            if max_id is None:
                continue

            pg_conn.execute(
                text("SELECT setval(:seq_name, :value, true)"),
                {"seq_name": seq_name, "value": max_id},
            )

    print("Data copy complete.")


if __name__ == "__main__":
    main()
