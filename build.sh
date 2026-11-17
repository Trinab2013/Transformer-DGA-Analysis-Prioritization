#!/usr/bin/env bash
# Wraps src/dashboard.html (an artifact page fragment) into a standalone index.html.
set -euo pipefail
cd "$(dirname "$0")"
{
  printf '<!doctype html>\n<html lang="en">\n<head>\n<meta charset="utf-8">\n<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">\n<style>body{margin:0;font:14px system-ui,sans-serif}[hidden]{display:none!important}img{max-width:100%%}</style>\n</head>\n<body>\n'
  cat src/dashboard.html
  printf '\n</body>\n</html>\n'
} > index.html
echo "Built index.html"
