#!/bin/bash
# detect-tech-stack.sh - Identify technology stack from build configs
# Usage: bash detect-tech-stack.sh [project_root]

ROOT="${1:-.}"

echo "## Tech Stack Detection"
echo ""

# Java
if find "$ROOT" -maxdepth 3 -name "pom.xml" 2>/dev/null | head -1 | grep -q .; then
    echo "- Java (Maven)"
    # Detect Spring Boot
    grep -rl "spring-boot" "$ROOT" --include="pom.xml" -l 2>/dev/null | head -1 | grep -q . && echo "  - Spring Boot"
    grep -rl "mybatis" "$ROOT" --include="pom.xml" -l 2>/dev/null | head -1 | grep -q . && echo "  - MyBatis"
fi

if find "$ROOT" -maxdepth 3 -name "build.gradle" -o -name "build.gradle.kts" 2>/dev/null | head -1 | grep -q .; then
    echo "- Java/Kotlin (Gradle)"
fi

# PHP
if find "$ROOT" -maxdepth 3 -name "composer.json" 2>/dev/null | head -1 | grep -q .; then
    echo "- PHP (Composer)"
    grep -rl "laravel/framework" "$ROOT" --include="composer.json" 2>/dev/null | head -1 | grep -q . && echo "  - Laravel"
    grep -rl "topthink/framework" "$ROOT" --include="composer.json" 2>/dev/null | head -1 | grep -q . && echo "  - ThinkPHP"
fi

# Node.js
if find "$ROOT" -maxdepth 3 -name "package.json" 2>/dev/null | head -1 | grep -q .; then
    echo "- Node.js"
    grep -rl "\"next\"" "$ROOT" --include="package.json" 2>/dev/null | head -1 | grep -q . && echo "  - Next.js"
    grep -rl "\"express\"" "$ROOT" --include="package.json" 2>/dev/null | head -1 | grep -q . && echo "  - Express"
    grep -rl "\"vue\"" "$ROOT" --include="package.json" 2>/dev/null | head -1 | grep -q . && echo "  - Vue.js"
    grep -rl "\"react\"" "$ROOT" --include="package.json" 2>/dev/null | head -1 | grep -q . && echo "  - React"
fi

# Python
if find "$ROOT" -maxdepth 3 -name "requirements.txt" -o -name "pyproject.toml" -o -name "setup.py" 2>/dev/null | head -1 | grep -q .; then
    echo "- Python"
    grep -rl "django" "$ROOT" --include="requirements.txt" --include="pyproject.toml" 2>/dev/null | head -1 | grep -q . && echo "  - Django"
    grep -rl "fastapi" "$ROOT" --include="requirements.txt" --include="pyproject.toml" 2>/dev/null | head -1 | grep -q . && echo "  - FastAPI"
fi

# Go
if find "$ROOT" -maxdepth 3 -name "go.mod" 2>/dev/null | head -1 | grep -q .; then
    echo "- Go"
fi

# Database
find "$ROOT" -maxdepth 3 -name "*.sql" 2>/dev/null | head -1 | grep -q . && echo "- SQL/Database"
