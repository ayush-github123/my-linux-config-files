#!/usr/bin/env bash

set -e

PROJECT_DIR="$HOME/Documents/Projects/L2M"

echo "▶ Switching to project directory..."
cd "$PROJECT_DIR"

echo "▶ Running Go app with real-time priority (FIFO 90)..."
exec chrt -f 90 go run .
