#!/usr/bin/env bash
set -euo pipefail

echo "=== ZAP Scan Comparison ==="

noauth_urls=$(grep -o "http://localhost:3000[^\"< ]*" labs/lab5/zap/report-noauth.html 2>/dev/null | sort -u | wc -l || echo 0)
auth_urls=$(grep -o "http://localhost:3000[^\"< ]*" labs/lab5/zap/report-auth.html 2>/dev/null | sort -u | wc -l || echo 0)

echo "Unauthenticated discovered URLs: $noauth_urls"
echo "Authenticated discovered URLs: $auth_urls"

echo ""
echo "Example admin/authenticated endpoints:"
grep -o "http://localhost:3000/rest/admin[^\"< ]*" labs/lab5/zap/report-auth.html 2>/dev/null | sort -u | head -20 || true
