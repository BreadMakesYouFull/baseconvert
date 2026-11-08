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

# Launch the GUI (creates the environment and installs GUI dependencies if needed)
launch: install-gui
    .venv/bin/baseconvert

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

# Run the local checks
check: lint test
    {{venv_python}} -m twine check dist/*

# Remove generated packaging artifacts
clean:
    rm -rf build dist *.egg-info
    rm -rf .venv

# Build fresh source and wheel distributions
build: clean install-dev
    {{venv_python}} -m build

# Build, test, validate, and upload to TestPyPI
publish-test: check
    {{venv_python}} -m twine upload --repository testpypi dist/*

# Build, test, validate, and upload to PyPI; run only when intentionally publishing
publish: check
    {{venv_python}} -m twine upload dist/*
