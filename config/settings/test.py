from .base import *


TEST = True

DEBUG = True

SECRET_KEY = 'test'

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'demo_project_test',
    }
}

DISABLE_DATABASE_SETUP = False
