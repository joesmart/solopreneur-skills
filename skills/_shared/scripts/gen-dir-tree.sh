#!/bin/bash
# gen-dir-tree.sh - Generate directory tree (max 3 levels)
# Usage: bash gen-dir-tree.sh [path] [max_depth]

ROOT="${1:-.}"
DEPTH="${2:-3}"

echo "## Directory Tree (depth=$DEPTH)"
echo ""

# Use tree if available, fallback to find
if command -v tree &>/dev/null; then
    tree "$ROOT" -L "$DEPTH" -d --charset=utf-8 \
        -I "node_modules|vendor|target|build|dist|.git|.idea|.vscode|__pycache__|.gradle"
else
    find "$ROOT" -maxdepth "$DEPTH" -type d \
        ! -path "*/node_modules/*" \
        ! -path "*/vendor/*" \
        ! -path "*/target/*" \
        ! -path "*/build/*" \
        ! -path "*/.git/*" \
        ! -path "*/.idea/*" \
        ! -path "*/__pycache__/*" \
        2>/dev/null | sort | head -100
fi
