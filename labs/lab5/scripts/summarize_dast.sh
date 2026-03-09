#!/usr/bin/env bash
set -euo pipefail

echo "=== DAST Summary ==="

zap_med=$(grep -c 'class="risk-2"' labs/lab5/zap/report-auth.html 2>/dev/null || echo 0)
zap_high=$(grep -c 'class="risk-3"' labs/lab5/zap/report-auth.html 2>/dev/null || echo 0)
zap_total=$(( (zap_med / 2) + (zap_high / 2) ))

nuclei_count=$(wc -l < labs/lab5/nuclei/nuclei-results.json 2>/dev/null || echo 0)
nikto_count=$(grep -c '^+ ' labs/lab5/nikto/nikto-results.txt 2>/dev/null || echo 0)

sqlmap_csv=$(find labs/lab5/sqlmap -name "results-*.csv" 2>/dev/null | head -1)
if [ -f "$sqlmap_csv" ]; then
  sqlmap_count=$(tail -n +2 "$sqlmap_csv" | grep -v '^$' | wc -l)
else
  sqlmap_count=0
fi

echo "ZAP authenticated alerts: $zap_total"
echo "Nuclei findings: $nuclei_count"
echo "Nikto issues: $nikto_count"
echo "SQLmap findings: $sqlmap_count"
