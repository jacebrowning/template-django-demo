ifdef CIRCLECI
ENV := /home/ubuntu/virtualenvs/venv-3.6.1
else ifdef HEROKU_APP_NAME
ENV := .
else
ENV := .venv
RUN := pipenv run
endif

.PHONY: all
all: install build

.PHONY: ci
ci: check test ## CI | Run all validation targets

.PHONY: watch
watch: install ## CI | Rerun all validation targests in a loop
	@ rm -rf $(FAILURES)
	- HOMEBREW_NO_AUTO_UPDATE=true brew install terminal-notifier
	- pipenv run pip install MacFSEvents pync
	$(RUN) sniffer

# SYSTEM DEPENDENCIES #########################################################

.PHONY: doctor
doctor: ## Check for required system dependencies
	bin/verchew

.envrc:
	echo export PYTHONUNBUFFERED=true >> $@
	echo export PIPENV_SHELL_COMPAT=true >> $@
	echo export PIPENV_VENV_IN_PROJECT=true >> $@
	echo >> $@
	echo export SECRET_KEY=local >> $@
	echo export DATABASE_URL=postgresql://localhost/demo_project_dev >> $@

# PROJECT DEPENDENCIES ########################################################

DEPENDENCIES := $(ENV)/.installed

.PHONY: install
install: $(DEPENDENCIES) ## Install project dependencies

$(DEPENDENCIES): Pipfile*
	pipenv install --dev
	@ touch $@

# BUILD TARGETS ###############################################################

.PHONY: build
build:
	@ echo "TODO: compile frontend code"

.PHONY: clean
clean:
	rm -rf staticfiles
	rm -rf .coverage htmlcov
	rm -rf $(ENV)

# RUNTIME DEPENDENCIES ########################################################

.PHONY: migrations
migrations: install  ## Database | Generate database migrations
	$(RUN) python manage.py makemigrations

.PHONY: migrate
migrate: install ## Database | Run database migrations
	$(RUN) python manage.py migrate

.PHONY: data
ifdef HEROKU_APP_NAME
data: ## Database | Seed data for manual testing
else
data: install migrate
endif
	$(RUN) python manage.py loaddata users
	$(RUN) python manage.py loaddata content
	$(RUN) python manage.py cleandata

.PHONY: reset
reset: install ## Database | Create a new database, migrate, and seed it
	- dropdb demo_project_dev
	- createdb demo_project_dev
	make data

# VALIDATION TARGETS ##########################################################

PYTHON_PACKAGES := config demo_project tests

FAILURES := .cache/v/cache/lastfailed

.PHONY: check
check: install ## Run static analysis
	$(RUN) pylint $(PYTHON_PACKAGES) --rcfile=.pylint.ini
	$(RUN) pycodestyle $(PYTHON_PACKAGES) --config=.pycodestyle.ini

.PHONY: test
test: install ## Run all tests
	@ if test -e $(FAILURES); then $(RUN) py.test demo_project tests/integration; fi
	@ rm -rf $(FAILURES)
	$(RUN) py.test demo_project tests/integration
	$(RUN) coverage.space jacebrowning/template-django-demo overall

.PHONY: test-unit
test-unit: install
	@ if test -e $(FAILURES); then $(RUN) py.test demo_project; fi
	@ rm -rf $(FAILURES)
	$(RUN) py.test demo_project
	$(RUN) coverage.space jacebrowning/template-django-demo unit

.PHONY: test-integration
test-integration: install
	@ if test -e $(FAILURES); then $(RUN) py.test tests/integration; fi
	@ rm -rf $(FAILURES)
	$(RUN) py.test tests/integration
	$(RUN) coverage.space jacebrowning/template-django-demo integration

.PHONY: test-system
test-system: install
	$(RUN) honcho start --procfile=tests/system/Procfile --env=tests/system/.env
	@ rm -rf $(FAILURES)

# SERVER TARGETS ##############################################################

.PHONY: run
run: .envrc install build ## Run the applicaiton
	$(RUN) python manage.py runserver $${PORT:-5000}

.PHONY: run-prod
run-prod: .envrc install ## Run the application (simulate production)
	pipenv shell -c "bin/pre_compile; exit \$$?"
	pipenv shell -c "bin/post_compile; exit \$$?"
	pipenv shell -c "heroku local release; exit \$$?"
	pipenv shell -c "heroku local web; exit \$$?"

# RELEASE TARGETS #############################################################

.PHONY: promote
promote: install
	SITE=https://staging.demo_project.com $(RUN) pytest tests/system
	heroku pipelines:promote --app demo_project-staging --to demo_project
	# TODO: Update system tests so they can run against production
	# Should have a specific test user name?
	SITE=https://demo_project.com $(RUN) pytest tests/system

# HELP ########################################################################

.PHONY: help
help: all
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
