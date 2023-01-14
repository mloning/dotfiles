# Makefile for easier setup

.PHONY: help create simulate delete

.DEFAULT_GOAL := help

#TARGET_DIR=${HOME}
TARGET_DIR=${HOME}/testdir/

help:
	# see http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

create: ## Create symbolic links
	stow --verbose --target=${TARGET_DIR} --restow */

simulate: ## Simulate symbolic link creation
	stow --verbose --target=${TARGET_DIR} --restow --simulate */

delete: ## Delete symbolic links
	stow --verbose --target=${TARGET_DIR} --delete */

