#!/bin/bash
set -e

# check environment variables
if [ -z "$OPENAI_API_KEY" ] && [ "$MCP_MODEL_PROVIDER" = "openai" ]; then
    echo "Error: OPENAI_API_KEY is required when using OpenAI models"
    exit 1
fi

if [ -z "$ANTHROPIC_API_KEY" ] && [ "$MCP_MODEL_PROVIDER" = "anthropic" ]; then
    echo "Error: ANTHROPIC_API_KEY is required when using Anthropic models"
    exit 1
fi

# Check if Playwright is installed
if ! pip list | grep -q playwright; then
    echo "Installing Playwright and dependencies..."
    pip install playwright
    python -m playwright install chromium
    python -m playwright install-deps chromium
fi

# execute mcp-browser-use server with supergateway
echo "Starting browser-use MCP server with supergateway..."
exec supergateway \
    --stdio "uvx mcp-server-browser-use" \
    --port 8000 \
    --cors