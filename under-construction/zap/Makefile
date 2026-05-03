# Variables
APP_NAME := zap

# Default target
all: help

# Include common definitions and targets
include ../common.mk

# Help message
help: common-help
	@echo "  help           - Show this help message"
	@echo ""
	@echo "Access ZAP Web UI:"
	@echo "  Domain:        https://${DOMAIN_PREFIX}.${CUSTOMDOMAIN}/zap (after 'make up')"
	@echo "  Localhost:     http://localhost:${HOST_PORT}/zap (if HOST_PORT is set)"
	@echo ""
	@echo "ZAP Certificates:"
	@echo "  Certificates are stored in ./data/ directory"
	@echo "  Import zap_root_ca.crt into your browser to intercept HTTPS traffic"

.PHONY: all help
