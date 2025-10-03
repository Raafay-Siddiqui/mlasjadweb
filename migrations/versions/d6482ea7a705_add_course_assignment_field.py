"""add_course_assignment_field

Revision ID: d6482ea7a705
Revises: bf62cdc9f90c
Create Date: 2025-10-04 00:13:46.672223

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'd6482ea7a705'
down_revision = 'bf62cdc9f90c'
branch_labels = None
depends_on = None


def upgrade():
    # Add course_assignment column with default 'standalone'
    with op.batch_alter_table('course', schema=None) as batch_op:
        batch_op.add_column(sa.Column('course_assignment', sa.String(20), nullable=True, server_default='standalone'))


def downgrade():
    # Remove course_assignment column
    with op.batch_alter_table('course', schema=None) as batch_op:
        batch_op.drop_column('course_assignment')
