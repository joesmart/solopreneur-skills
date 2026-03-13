#!/bin/bash
# trace-callers.sh - Find all callers of a method/class
# Usage: bash trace-callers.sh <method_or_class_name> [project_root]

QUERY="$1"
ROOT="${2:-.}"

if [ -z "$QUERY" ]; then
    echo "Usage: trace-callers.sh <method_or_class_name> [project_root]"
    exit 1
fi

echo "## Caller Trace: $QUERY"
echo ""
echo "| File | Line | Context |"
echo "|------|------|---------|"

grep -rn "$QUERY" "$ROOT" \
    --include="*.java" --include="*.php" --include="*.py" --include="*.go" \
    --include="*.ts" --include="*.js" \
    2>/dev/null | \
    grep -v '/target/' | grep -v '/build/' | grep -v '/vendor/' | \
    grep -v '/node_modules/' | grep -v '\.class' | \
    grep -v '^\s*//' | grep -v '^\s*\*' | grep -v '^\s*#' | \
    head -30 | \
    while IFS=: read -r F LINE REST; do
    echo "| $F | $LINE | $(echo "$REST" | head -c 100) |"
done
