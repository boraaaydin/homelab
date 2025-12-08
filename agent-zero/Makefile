# Variables
APP_NAME := agent-zero

# Default target
all: help

# Include common definitions and targets
include ../common.mk

# Include environment variables if .env exists
-include .env
export

# Help message
help: common-help
	@echo "  data-dirs      - Create data directories for Agent Zero"
	@echo "  help           - Show this help message"

# Create data directories for Agent Zero
data-dirs:
	@echo "Creating data directories..."
	@mkdir -p ./data/memory ./data/knowledge ./data/instruments ./data/tmp
	@echo "$(GREEN)Data directories created.$(NC)"

# Override setup to add data directory creation
setup-all: setup data-dirs
	@if [ ! -f $(ENV_FILE) ]; then \
		echo "Creating .env file from $(ENV_EXAMPLE_FILE)..."; \
		cp $(ENV_EXAMPLE_FILE) $(ENV_FILE); \
		echo "$(GREEN).env file created successfully. Please edit it with your configuration.$(NC)"; \
	else \
		echo "$(YELLOW).env file already exists.$(NC)"; \
	fi

clean:
	@echo "Stopping and removing $(APP_NAME) containers and volumes..."
	@$(DOCKER_COMPOSE) down -v --remove-orphans
	@rm -rf ./data
	@echo "$(GREEN)$(APP_NAME) cleaned successfully.$(NC)"

.PHONY: all help data-dirs