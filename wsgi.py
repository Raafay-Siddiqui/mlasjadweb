"""WSGI entry point for production deployment."""
import os

# Ensure the environment is configured before importing the Flask app
if not os.environ.get('FLASK_ENV'):
    os.environ['FLASK_ENV'] = 'production'

from website import app  # noqa: E402  # import after env vars are set


if __name__ == "__main__":
    app.run()
