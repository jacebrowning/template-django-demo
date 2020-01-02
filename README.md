[![CircleCI](https://img.shields.io/circleci/build/github/jacebrowning/template-django-demo)](https://coveralls.io/github/jacebrowning/template-django-demo)
[![Coveralls](https://img.shields.io/coveralls/github/jacebrowning/template-django-demo)](https://circleci.com/gh/jacebrowning/template-django-demo/tree/master)

# Overview

TODO: Describe this project.

This project was generated with [cookiecutter](https://github.com/audreyr/cookiecutter) using [jacebrowning/template-django](https://github.com/jacebrowning/template-django).

# Setup

## Requirements

The following must be installed on your system:

- Make
- Python 3.6
- pipenv
- PostgreSQL

To confirm the correct versions are installed:

```
$ make doctor
```

## Setup

Create a database:

```
$ createdb demo_project_dev
```

Install project dependencies:

```
$ make install
```

Run migrations and generate test data:

```
$ make data
```

## Development

Run the application and recompile static files:

```
$ make run
```

Continuously run validation targets:

```
$ make watch
```

or run them individually:

```
$ make check-backend
$ make check-frontend
$ make test-backend-unit
$ make test-backend-integration
$ make test-frontend-unit
$ make test-system
```
