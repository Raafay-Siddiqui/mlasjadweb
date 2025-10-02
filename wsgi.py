"""
WSGI entry point for production deployment.
This file is used by WSGI servers like Gunicorn to run the application.
"""
import os
from website import app

# Set production environment if not already set
if not os.environ.get('FLASK_ENV'):
    os.environ['FLASK_ENV'] = 'production'

if __name__ == "__main__":
    app.run()
