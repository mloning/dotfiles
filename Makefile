# Makefile for easier setup

.PHONY: help create delete link-skills

.DEFAULT_GOAL := help

VERBOSE=1
TARGET_DIR=${HOME}
#TARGET_DIR=${HOME}/testdir/

# Stow packages: every top-level dir except those managed elsewhere.
# skills/ is copied into each agent's skills dir by `make link-skills`
# (copied, not symlinked, so the files can be bind-mounted into containers),
# not stowed.
STOW_PACKAGES := $(filter-out skills/, $(wildcard */))

# Agent skill dirs. skills/ is the single source of truth and is copied into
# these. Re-run `make link-skills` after editing skills/ to re-sync.
SKILLS_SRC := $(CURDIR)/skills
CLAUDE_SKILLS_DIR := $(HOME)/.claude/skills
CODEX_SKILLS_DIR := $(HOME)/.agents/skills
AGY_CLI_SKILLS_DIR := $(HOME)/.gemini/antigravity-cli/skills
AGY_CONFIG_SKILLS_DIR := $(HOME)/.gemini/config/skills

AGENT_SKILLS_DIRS := $(CLAUDE_SKILLS_DIR) $(CODEX_SKILLS_DIR) $(AGY_CLI_SKILLS_DIR) $(AGY_CONFIG_SKILLS_DIR)

# see http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: # Help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

create: ## Create symbolic links
	stow --verbose=${VERBOSE} --target=${TARGET_DIR} --restow ${STOW_PACKAGES}

delete: ## Delete symbolic links
	stow --verbose=${VERBOSE} --target=${TARGET_DIR} --delete ${STOW_PACKAGES}

link-skills: ## Copy skills/ into Claude Code, Codex & Antigravity (agy)
	@for dir in $(AGENT_SKILLS_DIRS); do \
		mkdir -p "$$dir"; \
	done
	@for skill in $(SKILLS_SRC)/*/; do \
		name=$$(basename "$$skill"); \
		for dir in $(AGENT_SKILLS_DIRS); do \
			rm -rf "$$dir/$$name"; \
			cp -R "$(SKILLS_SRC)/$$name" "$$dir/$$name"; \
		done; \
		echo "copied $$name -> Claude Code, Codex & Antigravity"; \
	done

