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

# Launch the GUI, installing its dependencies only when needed
launch:
    if [[ ! -x .venv/bin/baseconvert ]] || ! {{venv_python}} -c 'import PySide6.QtQml' >/dev/null 2>&1; then \
        just install-gui; \
    fi
    .venv/bin/baseconvert

# Install development, test, and release tools into the virtual environment
install-dev: venv
    {{venv_python}} -m pip install build black twine pytest pytest-cov

# Format Python source
format: install-dev
    {{venv_python}} -m black baseconvert

# Check formatting
lint: install-dev
    {{venv_python}} -m black --check baseconvert

# Run pytest and require 100% statement coverage for the core library and CLI
test: install-dev
    {{venv_python}} -m pytest --cov=baseconvert.baseconvert --cov=baseconvert.__main__ --cov-report=term-missing --cov-fail-under=100 tests

# Run the local checks
check: lint test
    {{venv_python}} -m twine check dist/*

# Remove generated packaging artifacts
clean:
    rm -rf build dist *.egg-info .coverage
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

flatpak_manifest := "flatpak/io.github.breadmakesyoufull.baseconvert.yaml"
flatpak_dev_manifest := "flatpak/io.github.breadmakesyoufull.baseconvert.dev.yaml"
flatpak_build_dir := ".flatpak-build"
app_id := "io.github.breadmakesyoufull.baseconvert"

# Build and install working tree as flatpak
flatpak-build-dev:
    flatpak-builder --user --install --force-clean \
        --install-deps-from=flathub \
        {{flatpak_build_dir}} {{flatpak_dev_manifest}}

# Build and install main branch as flatpak
flatpak-build:
    flatpak-builder \
        --user \
        --install \
        --force-clean \
        --install-deps-from=flathub \
        {{flatpak_build_dir}} \
        {{flatpak_manifest}}

# Launch flatpak
flatpak-run:
    flatpak run {{app_id}}

# Build and launch flatpak from current tree
flatpak-test: flatpak-build-dev flatpak-run

# Build the Android toolchain image
android-image:
    podman build -f android/Containerfile -t baseconvert-android .

# Build the Android APK
android: android-image
    podman run --rm \
        -v "$PWD/android:/workspace" \ # Android only files
        -v "$PWD/baseconvert:/workspace/baseconvert" \ # Base convert python/qml files
        -v "$PWD/flatpak:/workspace/flatpak" \ # Base convert icon
        baseconvert-android \
        --name baseconvert \
        --icon /workspace/flatpak/icon.svg \
        --wheel-pyside /opt/android-wheels/pyside6.whl \
        --wheel-shiboken /opt/android-wheels/shiboken6.whl \
        --keep-deployment-files \
        --force \
        --verbose
