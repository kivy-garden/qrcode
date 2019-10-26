VIRTUAL_ENV ?= venv
PIP=$(VIRTUAL_ENV)/bin/pip
TOX=`which tox`
PYTHON=$(VIRTUAL_ENV)/bin/python
ISORT=$(VIRTUAL_ENV)/bin/isort
FLAKE8=$(VIRTUAL_ENV)/bin/flake8
TWINE=`which twine`
SOURCES=src/ tests/
# using full path so it can be used outside the root dir
SPHINXBUILD=$(shell realpath venv/bin/sphinx-build)
DOCS_DIR=doc
PYTHON_MAJOR_VERSION=3
PYTHON_MINOR_VERSION=7
PYTHON_VERSION=$(PYTHON_MAJOR_VERSION).$(PYTHON_MINOR_VERSION)
PYTHON_WITH_VERSION=python$(PYTHON_VERSION)
DOCKER_IMAGE_LINUX=kivy/qrcode-linux
SYSTEM_DEPENDENCIES= \
    libgl1 \
    python3.6 \
    python$(PYTHON_VERSION) \
    tox \
    virtualenv


all: virtualenv

$(VIRTUAL_ENV):
	virtualenv -p $(PYTHON_WITH_VERSION) $(VIRTUAL_ENV)
	$(PIP) install Cython==0.28.6
	$(PIP) install -r requirements.txt

virtualenv: $(VIRTUAL_ENV)

virtualenv/test: virtualenv
	$(PIP) install -r requirements/requirements-test.txt

system_dependencies:
	sudo apt update -qq > /dev/null && sudo apt -qq install --yes --no-install-recommends $(SYSTEM_DEPENDENCIES)

run: virtualenv
	$(PYTHON) src/kivy_garden/qrcode/qrcode_widget.py

test:
	$(TOX)

lint/isort-check: virtualenv/test
	$(ISORT) --check-only --recursive --diff $(SOURCES)

lint/isort-fix: virtualenv/test
	$(ISORT) --recursive $(SOURCES)

lint/flake8: virtualenv/test
	$(FLAKE8) $(SOURCES)

lint: lint/isort-check lint/flake8

docs/clean:
	rm -rf $(DOCS_DIR)/build/

docs:
	cd $(DOCS_DIR) && SPHINXBUILD=$(SPHINXBUILD) make html

release/clean:
	rm -rf dist/ build/

release/build: release/clean virtualenv
	$(PYTHON) setup.py sdist bdist_wheel
	$(TWINE) check dist/*

release/upload:
	$(TWINE) upload dist/*

clean: release/clean docs/clean
	find . -type d -name "__pycache__" -exec rm -r {} +
	find . -type d -name "*.egg-info" -exec rm -r {} +

clean/all: clean
	rm -rf $(VIRTUAL_ENV) .tox/

docker/pull:
	docker pull $(DOCKER_IMAGE_LINUX):latest || true

docker/build:
	docker build --cache-from=$(DOCKER_IMAGE_LINUX) --tag=$(DOCKER_IMAGE_LINUX) --file=dockerfiles/Dockerfile-linux .

docker/push:
	docker push $(DOCKER_IMAGE_LINUX)

docker/run/test: docker/build
	docker run --env-file dockerfiles/env.list -v /tmp/.X11-unix:/tmp/.X11-unix $(DOCKER_IMAGE_LINUX) 'make test'

docker/run/app: docker/build
	docker run --env-file dockerfiles/env.list -v /tmp/.X11-unix:/tmp/.X11-unix $(DOCKER_IMAGE_LINUX) 'make run'

docker/run/shell: docker/build
	docker run --env-file dockerfiles/env.list -v /tmp/.X11-unix:/tmp/.X11-unix -it --rm $(DOCKER_IMAGE_LINUX)
