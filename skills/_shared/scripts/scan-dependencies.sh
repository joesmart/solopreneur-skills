#!/bin/bash
# scan-dependencies.sh - Scan service/module dependencies and communication patterns
# Usage: bash scan-dependencies.sh [project_root]

ROOT="${1:-.}"

echo "## Dependency Scan"
echo ""

echo "### HTTP Client Calls"
echo "| File | Line | Pattern |"
echo "|------|------|---------|"
# Java HTTP clients
grep -rn 'RestTemplate\|FeignClient\|WebClient\|HttpClient' "$ROOT" \
    --include="*.java" 2>/dev/null | grep -v '/target/' | grep -v '/build/' | head -20 | \
    while IFS=: read -r F LINE REST; do
    echo "| $F | $LINE | $REST |"
done

# PHP HTTP clients
grep -rn 'Guzzle\|Http::\|curl_' "$ROOT" \
    --include="*.php" 2>/dev/null | grep -v '/vendor/' | head -20 | \
    while IFS=: read -r F LINE REST; do
    echo "| $F | $LINE | $REST |"
done

echo ""
echo "### Message Queue (Async)"
echo "| File | Line | Pattern |"
echo "|------|------|---------|"
grep -rn '@RabbitListener\|@KafkaListener\|RabbitTemplate\|KafkaTemplate\|amqp\|Redis.*publish\|Redis.*subscribe' "$ROOT" \
    --include="*.java" --include="*.php" --include="*.yml" --include="*.yaml" --include="*.properties" \
    2>/dev/null | grep -v '/target/' | grep -v '/vendor/' | head -20 | \
    while IFS=: read -r F LINE REST; do
    echo "| $F | $LINE | $REST |"
done

echo ""
echo "### Service URL References"
echo "| File | Line | URL |"
echo "|------|------|-----|"
grep -rn 'http://.*-service\|https://.*-service\|service\.url\|service\.host' "$ROOT" \
    --include="*.yml" --include="*.yaml" --include="*.properties" --include="*.env" \
    2>/dev/null | head -20 | \
    while IFS=: read -r F LINE REST; do
    echo "| $F | $LINE | $REST |"
done
