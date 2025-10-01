# Makefile

SHELL := /bin/bash

# Pull the latest changes from the template repository
.PHONY: sync-with-template
sync-with-template:
	@if ! git diff-index --quiet HEAD --; then \
		echo "ERROR: You have uncommitted changes. Please commit or stash them before syncing."; \
		exit 1; \
	fi
	@git remote get-url template >/dev/null 2>&1 || git remote add template https://github.com/canonical/rocks-template.git
	@git fetch template
	@git merge -X ours --allow-unrelated-histories --no-commit template/main
	@echo "Please review the results and commit the changes manually."


# Check that dependencies are installed
.PHONY: check-setup
check-setup:
	@echo "Checking for required dependencies..."

	@command -v lxd >/dev/null 2>&1 && echo "✓ lxd is installed." || (echo "✗ lxd is missing."; exit 1)
	@command -v rockcraft >/dev/null 2>&1 && echo "✓ rockcraft is installed." || (echo "✗ rockcraft is missing."; exit 1)

	@echo "All required dependencies are installed."


# Test all rocks by finding directories that contain spread.yaml
.PHONY: test-all
test-all:
	@echo "Testing all rocks..."
	@find ./ -type f -name "spread.yaml" | while read spread_file; do \
		rock_dir=$$(dirname $$spread_file); \
		echo "Testing $$rock_dir..."; \
		pushd $$rock_dir > /dev/null; \
		rockcraft test; \
		rm .spread-reuse*; \
		rm -rf .craft-spread*; \
		popd > /dev/null; \
	done
