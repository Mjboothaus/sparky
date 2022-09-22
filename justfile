# See https://just.systems/

# Load variables from .env file

set dotenv-load

# Show available just commands

help:
  @just -l


project-name:
	echo $PROJECT_NAME
	

docs:
	open $DOCS_URL

port-process port:
	sudo lsof -i :$SERVER_PORT


nbconvert-md notebook:
	jupyter nbconvert --to markdown {{notebook}} --output-dir='docs/nbconvert'

# Spark/Scala

shell:
    spark-shell


spark-ui:
    open http://localhost:4040


# Create the local Python venv (.venv_$PROJECT_NAME) and install requirements(.txt)

venv dev_deploy:
	#!/usr/bin/env bash
	pip-compile requirements-{{dev_deploy}}.in
	python3 -m venv .venv_{{dev_deploy}}_$PROJECT_NAME
	. .venv_{{dev_deploy}}_$PROJECT_NAME/bin/activate
	python3 -m pip install --upgrade pip
	pip install -r requirements-{{dev_deploy}}.txt
	python -m ipykernel install --user --name .venv_{{dev_deploy}}_$PROJECT_NAME
	pip install -U prefect
	echo -e '\n' source .venv_{{dev_deploy}}_$PROJECT_NAME/bin/activate '\n'


update-reqs dev_deploy:
	pip-compile requirements-{{dev_deploy}}.in
	pip install -r requirements-{{dev_deploy}}.txt --upgrade


test:
  pytest


pyenv-list:
	pyenv install -l


pyenv:
	brew update && brew upgrade pyenv
	pyenv install $PYTHON_VERSION
	pyenv local $PYTHON_VERSION
	pipx reinstall-all



dockerfile:
  #!/usr/bin/env bash
  python utils/create_dockerfile.py
  

# Build and run app in a (local) Docker container

open-docker:
	open /Applications/Docker.app
	

docker: dockerfile
  pip-compile requirements-deploy.in
  docker build . -t $PROJECT_NAME
  docker run -p $SERVER_PORT$:$SERVER_PORT $PROJECT_NAME