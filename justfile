# Common development tasks. All package installs stay inside .venv.

set shell := ["bash", "-cu"]

python := "python3"
venv_python := ".venv/bin/python"

# List available recipes
help:
    @just --list

# Create the local virtual environment
venv:
    {{python}} -m venv .venv

# Install the package in editable mode
install: venv
    {{venv_python}} -m pip install -e .

# Install the package with its GUI dependencies
install-gui: venv
    {{venv_python}} -m pip install -e '.[gui]'

# Install development and release tools into the virtual environment
install-dev: venv
    {{venv_python}} -m pip install build black twine

# Format Python source
format: install-dev
    {{venv_python}} -m black baseconvert

# Check formatting
lint: install-dev
    {{venv_python}} -m black --check baseconvert

# Run the module's doctests
test: venv
    {{venv_python}} baseconvert/baseconvert.py

# Run the CI checks
check: lint test

# Remove generated packaging artifacts
clean:
    rm -rf build dist *.egg-info

# Remove packaging artifacts and the local virtual environment
clean-all: clean
    rm -rf .venv

# Build fresh source and wheel distributions
build: install-dev
    just clean
    {{venv_python}} -m build

# Validate built distributions
check-dist: build
    {{venv_python}} -m twine check dist/*

# Build, test, validate, and upload to TestPyPI
publish-test: check check-dist
    {{venv_python}} -m twine upload --repository testpypi dist/*

# Build, test, validate, and upload to PyPI; run only when intentionally publishing
publish: check check-dist
    {{venv_python}} -m twine upload dist/*
