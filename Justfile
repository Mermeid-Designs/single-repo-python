sources:="."

# Lists available commands
help:
    just --list

# Install/update the pre-commit hooks for local development
setup: check-pre-commit
	pre-commit install --install-hooks
	pre-commit autoupdate
	direnv allow .

# Install/update the local library and associated dependencies
install: check-poetry
	poetry install
	direnv allow .

# Clear local caches and build artifacts
clean:
	rm -rf `find . -name __pycache__`
	rm -f `find . -type f -name '*.py[co]'`
	rm -f `find . -type f -name '*~'`
	rm -f `find . -type f -name '.*~'`
	rm -rf .cache
	rm -rf .pytest_cache
	rm -rf .ruff_cache
	rm -rf build
	rm -rf dist
	rm -rf site

# ------------------------------- PRIVATE COMMANDS -------------------------------

# Check that poetry is installed
[private]
check-poetry:
	poetry -V || pip install poetry

# ==============================================================================
# =========================== CODE QUALITY CHECKS =============================
# ==============================================================================

# Lint python source files
lint: check-ruff check-black
	poetry run black {{sources}} --check
	poetry run ruff check {{sources}}

# Format python source files
format: check-ruff check-black
	poetry run black {{sources}}
	poetry run ruff check --fix {{sources}}

# ------------------------------- PRIVATE COMMANDS -------------------------------

# Check that pre-commit is installed
[private]
check-pre-commit:
	poetry show pre-commit || poetry add pre-commit --group dev

# Check that ruff is installed
[private]
check-ruff:
	poetry show ruff || poetry add ruff --group formatting

# Check that black is installed
[private]
check-black:
	poetry show black || poetry add black --group formatting

# ==============================================================================
# =============================== TESTING =====================================
# ==============================================================================

# Run all unit tests
unit-test: check-pytest check-pytest-asyncio
	poetry run pytest -m unit_test

# Run all integration tests
integration-test: check-pytest check-pytest-asyncio
	poetry run pytest -m integration_test

# Run all end-to-end tests
e2e-test: check-pytest check-pytest-asyncio
	poetry run pytest -m end_test

# ------------------------------- PRIVATE COMMANDS -------------------------------

# Check that pytest is installed
[private]
check-pytest:
	poetry show pytest || poetry add pytest --group test

# Check that pytest-asyncio is installed
[private]
check-pytest-asyncio:
	poetry show pytest-asyncio || poetry add pytest-asyncio --group test