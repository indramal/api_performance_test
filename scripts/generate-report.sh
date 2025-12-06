#!/bin/bash

# Generate Markdown Report from benchmark results

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
RESULTS_FILE="${1:-$PROJECT_ROOT/results/temp_results.json}"
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
REPORT_FILE="$PROJECT_ROOT/results/performance-report-$TIMESTAMP.md"

if [ ! -f "$RESULTS_FILE" ]; then
    echo "Error: Results file not found: $RESULTS_FILE"
    exit 1
fi

# Start generating the report
cat > "$REPORT_FILE" << 'EOF'
# API Performance Benchmark Report

EOF

# Add timestamp
echo "**Generated:** $(date '+%Y-%m-%d %H:%M:%S')" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Add system information
echo "## System Information" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
bash "$SCRIPT_DIR/collect-system-info.sh" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Add test configuration
echo "## Test Configuration" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
CONFIG_FILE="$PROJECT_ROOT/config/test-config.json"
if [ -f "$CONFIG_FILE" ]; then
    DURATION=$(jq -r '.wrk.duration' "$CONFIG_FILE")
    THREADS=$(jq -r '.wrk.threads' "$CONFIG_FILE")
    CONNECTIONS=$(jq -r '.wrk.connections' "$CONFIG_FILE")
    ENDPOINT=$(jq -r '.endpoint' "$CONFIG_FILE")
    
    echo "- **Duration:** $DURATION" >> "$REPORT_FILE"
    echo "- **Threads:** $THREADS" >> "$REPORT_FILE"
    echo "- **Connections:** $CONNECTIONS" >> "$REPORT_FILE"
    echo "- **Endpoint:** $ENDPOINT" >> "$REPORT_FILE"
fi
echo "" >> "$REPORT_FILE"

# Performance Summary Table
echo "## Performance Summary" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "| Rank | Runtime | Framework | Requests/sec | Avg Latency | P99 Latency |" >> "$REPORT_FILE"
echo "|------|---------|-----------|--------------|-------------|-------------|" >> "$REPORT_FILE"

# Sort by requests per second and add to table
jq -r 'sort_by(.requests_per_sec | tonumber) | reverse | to_entries | .[] | 
    "\(.key + 1) | \(.value.runtime) | \(.value.framework) | \(.value.requests_per_sec) | \(.value.latency.avg) | \(.value.latency.percentile_99)"' \
    "$RESULTS_FILE" | while IFS='|' read -r rank runtime framework req_sec avg_lat p99_lat; do
    echo "| $rank | $runtime | $framework | $req_sec | $avg_lat | $p99_lat |" >> "$REPORT_FILE"
done

echo "" >> "$REPORT_FILE"

# Detailed Results by Runtime
echo "## Detailed Results" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Node.js Results
echo "### Node.js Runtime" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "| Framework | Requests/sec | Transfer/sec | Avg Latency | Stdev | Max | P50 | P75 | P90 | P99 |" >> "$REPORT_FILE"
echo "|-----------|--------------|--------------|-------------|-------|-----|-----|-----|-----|-----|" >> "$REPORT_FILE"

jq -r '.[] | select(.runtime == "Node.js") | 
    "\(.framework) | \(.requests_per_sec) | \(.transfer_per_sec) | \(.latency.avg) | \(.latency.stdev) | \(.latency.max) | \(.latency.percentile_50) | \(.latency.percentile_75) | \(.latency.percentile_90) | \(.latency.percentile_99)"' \
    "$RESULTS_FILE" | while IFS='|' read -r framework req_sec transfer avg stdev max p50 p75 p90 p99; do
    echo "| $framework | $req_sec | $transfer | $avg | $stdev | $max | $p50 | $p75 | $p90 | $p99 |" >> "$REPORT_FILE"
done

echo "" >> "$REPORT_FILE"

# Bun Results (if any)
BUN_COUNT=$(jq '[.[] | select(.runtime == "Bun")] | length' "$RESULTS_FILE")
if [ "$BUN_COUNT" -gt 0 ]; then
    echo "### Bun Runtime" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "| Framework | Requests/sec | Transfer/sec | Avg Latency | Stdev | Max | P50 | P75 | P90 | P99 |" >> "$REPORT_FILE"
    echo "|-----------|--------------|--------------|-------------|-------|-----|-----|-----|-----|-----|" >> "$REPORT_FILE"

    jq -r '.[] | select(.runtime == "Bun") | 
        "\(.framework) | \(.requests_per_sec) | \(.transfer_per_sec) | \(.latency.avg) | \(.latency.stdev) | \(.latency.max) | \(.latency.percentile_50) | \(.latency.percentile_75) | \(.latency.percentile_90) | \(.latency.percentile_99)"' \
        "$RESULTS_FILE" | while IFS='|' read -r framework req_sec transfer avg stdev max p50 p75 p90 p99; do
        echo "| $framework | $req_sec | $transfer | $avg | $stdev | $max | $p50 | $p75 | $p90 | $p99 |" >> "$REPORT_FILE"
    done

    echo "" >> "$REPORT_FILE"
fi

# Rust Results (if any)
RUST_COUNT=$(jq '[.[] | select(.runtime == "Rust")] | length' "$RESULTS_FILE")
if [ "$RUST_COUNT" -gt 0 ]; then
    echo "### Rust Runtime" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "| Framework | Requests/sec | Transfer/sec | Avg Latency | Stdev | Max | P50 | P75 | P90 | P99 |" >> "$REPORT_FILE"
    echo "|-----------|--------------|--------------|-------------|-------|-----|-----|-----|-----|-----|" >> "$REPORT_FILE"

    jq -r '.[] | select(.runtime == "Rust") | 
        "\(.framework) | \(.requests_per_sec) | \(.transfer_per_sec) | \(.latency.avg) | \(.latency.stdev) | \(.latency.max) | \(.latency.percentile_50) | \(.latency.percentile_75) | \(.latency.percentile_90) | \(.latency.percentile_99)"' \
        "$RESULTS_FILE" | while IFS='|' read -r framework req_sec transfer avg stdev max p50 p75 p90 p99; do
        echo "| $framework | $req_sec | $transfer | $avg | $stdev | $max | $p50 | $p75 | $p90 | $p99 |" >> "$REPORT_FILE"
    done

    echo "" >> "$REPORT_FILE"
fi

# Runtime Comparison
echo "## Runtime Comparison" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "Average performance by runtime:" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "| Runtime | Avg Requests/sec | Frameworks Tested |" >> "$REPORT_FILE"
echo "|---------|------------------|-------------------|" >> "$REPORT_FILE"

for runtime in "Node.js" "Bun" "Rust"; do
    RUNTIME_COUNT=$(jq --arg rt "$runtime" '[.[] | select(.runtime == $rt)] | length' "$RESULTS_FILE")
    if [ "$RUNTIME_COUNT" -gt 0 ]; then
        AVG_REQ=$(jq --arg rt "$runtime" '[.[] | select(.runtime == $rt) | .requests_per_sec | tonumber] | add / length | round' "$RESULTS_FILE")
        echo "| $runtime | $AVG_REQ | $RUNTIME_COUNT |" >> "$REPORT_FILE"
    fi
done

echo "" >> "$REPORT_FILE"

# Notes
echo "## Notes" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "- All tests performed using [wrk](https://github.com/wg/wrk) HTTP benchmarking tool" >> "$REPORT_FILE"
echo "- Each server was given a 5-second warmup period before benchmarking" >> "$REPORT_FILE"
echo "- Latency values are in the format reported by wrk (typically microseconds or milliseconds)" >> "$REPORT_FILE"
echo "- Results may vary based on system load, hardware, and runtime versions" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "Report generated: $REPORT_FILE"
