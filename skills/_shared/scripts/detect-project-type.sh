#!/bin/bash
# detect-project-type.sh - Detect monolith vs microservices
# Usage: bash detect-project-type.sh [project_root]
# Output: project type and evidence

ROOT="${1:-.}"

echo "## Project Type Detection"
echo ""

# Check for microservice signals
DOCKER_COMPOSE=$(find "$ROOT" -maxdepth 2 -name "docker-compose*.yml" -o -name "docker-compose*.yaml" 2>/dev/null | head -5)
MULTI_POM=$(find "$ROOT" -maxdepth 2 -name "pom.xml" 2>/dev/null | wc -l | tr -d ' ')
MULTI_COMPOSER=$(find "$ROOT" -maxdepth 2 -name "composer.json" 2>/dev/null | wc -l | tr -d ' ')
MULTI_PACKAGE=$(find "$ROOT" -maxdepth 2 -name "package.json" 2>/dev/null | wc -l | tr -d ' ')
SERVICES_DIR=$(find "$ROOT" -maxdepth 1 -type d -name "services" -o -name "apps" -o -name "modules" -o -name "packages" 2>/dev/null)

MICRO_SIGNALS=0
[ -n "$DOCKER_COMPOSE" ] && MICRO_SIGNALS=$((MICRO_SIGNALS + 1))
[ "$MULTI_POM" -gt 2 ] && MICRO_SIGNALS=$((MICRO_SIGNALS + 1))
[ "$MULTI_COMPOSER" -gt 2 ] && MICRO_SIGNALS=$((MICRO_SIGNALS + 1))
[ "$MULTI_PACKAGE" -gt 2 ] && MICRO_SIGNALS=$((MICRO_SIGNALS + 1))
[ -n "$SERVICES_DIR" ] && MICRO_SIGNALS=$((MICRO_SIGNALS + 1))

if [ "$MICRO_SIGNALS" -ge 2 ]; then
    echo "TYPE: microservices"
else
    echo "TYPE: monolith"
fi

echo ""
echo "Evidence:"
[ -n "$DOCKER_COMPOSE" ] && echo "  - docker-compose found: $DOCKER_COMPOSE"
[ "$MULTI_POM" -gt 1 ] && echo "  - Multiple pom.xml: $MULTI_POM files"
[ "$MULTI_COMPOSER" -gt 1 ] && echo "  - Multiple composer.json: $MULTI_COMPOSER files"
[ "$MULTI_PACKAGE" -gt 1 ] && echo "  - Multiple package.json: $MULTI_PACKAGE files"
[ -n "$SERVICES_DIR" ] && echo "  - Services directory: $SERVICES_DIR"
