.PHONY: help clean-notebooks clean-all install test

# Default target
help:
	@echo "Available targets:"
	@echo "  clean-notebooks    - Remove output and metadata from all Jupyter notebooks"
	@echo "  clean-all          - Remove all generated files (notebooks output, cache, etc.)"
	@echo "  install            - Install project dependencies"
	@echo "  test               - Run tests"
	@echo "  help               - Show this help message"

# Clean notebook outputs and metadata
clean-notebooks:
	@echo "Cleaning Jupyter notebooks..."
	source venv/bin/activate && \
	jupyter nbconvert \
		--clear-output \
		--ClearMetadataPreprocessor.enabled=True \
		--RegexRemovePreprocessor.patterns='"\s*\Z"' \
		--inplace \
		**/*.ipynb \
		**/*/*.ipynb
	@echo "Notebooks cleaned successfully!"

# Remove all generated files
clean-all: clean-notebooks
	@echo "Removing cache and temporary files..."
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".ipynb_checkpoints" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete
	@echo "All generated files removed!"

# Install dependencies
install:
	@echo "Installing dependencies..."
	pip install -r requirements.txt
	@echo "Dependencies installed!"

# Run tests (adjust as needed)
test:
	@echo "Running tests..."
	pytest
