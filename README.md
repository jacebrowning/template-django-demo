[![CircleCI](https://img.shields.io/circleci/build/github/jacebrowning/template-django-demo)](https://circleci.com/gh/jacebrowning/template-django-demo)
[![Coveralls](https://img.shields.io/coveralls/github/jacebrowning/template-django-demo)](https://coveralls.io/github/jacebrowning/template-django-demo)

# Overview

TODO: Describe this project.

This project was generated with [cookiecutter](https://github.com/audreyr/cookiecutter) using [jacebrowning/template-django](https://github.com/jacebrowning/template-django).

# Setup

## Requirements

The following must be installed on your system:

- Make
- Python
- Poetry
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

See the [contributor guide](CONTRIBUTING.md) for additional details.
