# GNU Make equivalents for the recipes in justfile.
# Package and development installs stay inside .venv.

PYTHON ?= python3
VENV_PYTHON := .venv/bin/python

.PHONY: help venv install install-gui launch install-dev format lint test check clean build publish-test publish

help: ## List available targets
	@grep -E '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*## "}; {printf "%-14s %s\n", $$1, $$2}'

venv: ## Create the local virtual environment
	$(PYTHON) -m venv .venv

install: venv ## Install the package in editable mode
	$(VENV_PYTHON) -m pip install -e .

install-gui: venv ## Install the package with its GUI dependencies
	$(VENV_PYTHON) -m pip install -e '.[gui]'

launch: ## Launch GUI, installing its dependencies if needed
	@if [ ! -x .venv/bin/baseconvert ] || ! $(VENV_PYTHON) -c 'import PySide6.QtQml' >/dev/null 2>&1; then \
		$(MAKE) install-gui; \
	fi
	.venv/bin/baseconvert

install-dev: venv ## Install development, test, and release tools
	$(VENV_PYTHON) -m pip install build black twine pytest pytest-cov

format: install-dev ## Format Python source
	$(VENV_PYTHON) -m black baseconvert

lint: install-dev ## Check Python formatting
	$(VENV_PYTHON) -m black --check baseconvert

test: install-dev ## Run pytest and require 100% core library/CLI coverage
	$(VENV_PYTHON) -m pytest --cov=baseconvert.baseconvert --cov=baseconvert.__main__ --cov-report=term-missing --cov-fail-under=100 tests

check: lint test ## Run lint, tests, and Twine validation of dist/*
	$(VENV_PYTHON) -m twine check dist/*

clean: ## Remove generated packaging artifacts and .venv
	rm -rf build dist *.egg-info .venv

build: ## Clean, install dev tools, and build source and wheel distributions
	$(MAKE) clean
	$(MAKE) install-dev
	$(VENV_PYTHON) -m build

publish-test: check ## Run checks and upload dist/* to TestPyPI
	$(VENV_PYTHON) -m twine upload --repository testpypi dist/*

publish: check ## Run checks and upload dist/* to PyPI
	$(VENV_PYTHON) -m twine upload dist/*
