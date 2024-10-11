# Makefile for easier setup

.PHONY: help create delete

.DEFAULT_GOAL := help

VERBOSE=1
TARGET_DIR=${HOME}
#TARGET_DIR=${HOME}/testdir/

# see http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: # Help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

create: ## Create symbolic links
	stow --verbose=${VERBOSE} --target=${TARGET_DIR} --restow */

delete: ## Delete symbolic links
	stow --verbose=${VERBOSE} --target=${TARGET_DIR} --delete */

