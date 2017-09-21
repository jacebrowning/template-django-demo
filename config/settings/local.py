from .base import *


DEBUG = True

SECRET_KEY = 'dev'

ALLOWED_HOSTS = [
    '127.0.0.1',
    'localhost',
    '.ngrok.io',
]

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'demo_project_dev',
    }
}
