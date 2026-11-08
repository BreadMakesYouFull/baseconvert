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

launch: venv ## Launch GUI, installing its dependencies if needed
	@if [ ! -x .venv/bin/baseconvert ] || ! $(VENV_PYTHON) -c 'import PySide6.QtQml' >/dev/null 2>&1; then \
		$(MAKE) install-gui; \
	fi
	.venv/bin/baseconvert

install-dev: venv ## Install development and release tools
	$(VENV_PYTHON) -m pip install build black twine

format: install-dev ## Format Python source
	$(VENV_PYTHON) -m black baseconvert

lint: install-dev ## Check Python formatting
	$(VENV_PYTHON) -m black --check baseconvert

test: venv ## Run the module's doctests
	$(VENV_PYTHON) baseconvert/baseconvert.py

check: ## Run lint, doctests, and Twine validation of dist/*
	$(MAKE) lint
	$(MAKE) test
	$(VENV_PYTHON) -m twine check dist/*

clean: ## Remove generated packaging artifacts and .venv
	rm -rf build dist *.egg-info .venv

build: ## Clean and build source and wheel distributions
	$(MAKE) clean
	$(MAKE) install-dev
	$(VENV_PYTHON) -m build

publish-test: check ## Upload dist/* to TestPyPI after checks
	$(VENV_PYTHON) -m twine upload --repository testpypi dist/*

publish: check ## Upload dist/* to PyPI after checks
	$(VENV_PYTHON) -m twine upload dist/*
