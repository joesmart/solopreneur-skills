#!/bin/bash
# search-error-source.sh - Search for error message origins in codebase
# Usage: bash search-error-source.sh "<error_message>" [project_root]

QUERY="$1"
ROOT="${2:-.}"

if [ -z "$QUERY" ]; then
    echo "Usage: search-error-source.sh \"<error_message>\" [project_root]"
    exit 1
fi

echo "## Error Source Search: \"$QUERY\""
echo ""

# Search in source code (strings, exception messages)
echo "### Source Code Matches"
echo "| File | Line | Context |"
echo "|------|------|---------|"
grep -rn "$QUERY" "$ROOT" \
    --include="*.java" --include="*.php" --include="*.py" --include="*.go" \
    --include="*.ts" --include="*.js" \
    2>/dev/null | \
    grep -v '/target/' | grep -v '/build/' | grep -v '/vendor/' | \
    grep -v '/node_modules/' | \
    head -20 | \
    while IFS=: read -r F LINE REST; do
    echo "| $F | $LINE | $(echo "$REST" | head -c 120) |"
done

echo ""
echo "### Config/Resource Matches"
echo "| File | Line | Context |"
echo "|------|------|---------|"
grep -rn "$QUERY" "$ROOT" \
    --include="*.yml" --include="*.yaml" --include="*.properties" \
    --include="*.xml" --include="*.json" \
    2>/dev/null | \
    grep -v '/target/' | grep -v '/build/' | grep -v '/vendor/' | \
    head -10 | \
    while IFS=: read -r F LINE REST; do
    echo "| $F | $LINE | $(echo "$REST" | head -c 120) |"
done
