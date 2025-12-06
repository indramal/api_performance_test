#!/bin/bash

# Performance Benchmark Runner Script
# This script runs wrk benchmarks against all API implementations

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CONFIG_FILE="$PROJECT_ROOT/config/test-config.json"
RESULTS_DIR="$PROJECT_ROOT/results"
TEMP_RESULTS="$RESULTS_DIR/temp_results.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Create results directory
mkdir -p "$RESULTS_DIR"

# Check if wrk is installed
if ! command -v wrk &> /dev/null; then
    echo -e "${RED}Error: wrk is not installed${NC}"
    echo "Please install wrk: https://github.com/wg/wrk"
    exit 1
fi

# Check if jq is installed for JSON parsing
if ! command -v jq &> /dev/null; then
    echo -e "${RED}Error: jq is not installed${NC}"
    echo "Please install jq for JSON parsing"
    exit 1
fi

# Read configuration
DURATION=$(jq -r '.wrk.duration' "$CONFIG_FILE")
THREADS=$(jq -r '.wrk.threads' "$CONFIG_FILE")
CONNECTIONS=$(jq -r '.wrk.connections' "$CONFIG_FILE")
ENDPOINT=$(jq -r '.endpoint' "$CONFIG_FILE")

echo "=== API Performance Benchmark ==="
echo "Configuration:"
echo "  Duration: $DURATION"
echo "  Threads: $THREADS"
echo "  Connections: $CONNECTIONS"
echo "  Endpoint: $ENDPOINT"
echo ""

# Initialize results array
echo "[]" > "$TEMP_RESULTS"

# Function to run benchmark
run_benchmark() {
    local NAME=$1
    local RUNTIME=$2
    local FRAMEWORK=$3
    local PORT=$4
    local CMD=$5
    local WORKDIR=$6
    
    echo -e "${YELLOW}Testing: $NAME${NC}"
    
    # Start server
    cd "$WORKDIR"
    export PORT=$PORT
    
    # Start server in background
    $CMD > /dev/null 2>&1 &
    local PID=$!
    
    # Wait for server to start
    echo "  Starting server (PID: $PID)..."
    sleep 5
    
    # Check if server is running
    if ! kill -0 $PID 2>/dev/null; then
        echo -e "  ${RED}Failed to start server${NC}"
        return 1
    fi
    
    # Warmup
    echo "  Warming up..."
    wrk -t2 -c10 -d5s "http://localhost:$PORT$ENDPOINT" > /dev/null 2>&1 || true
    
    # Run benchmark
    echo "  Running benchmark..."
    local RESULT=$(wrk -t$THREADS -c$CONNECTIONS -d$DURATION --latency "http://localhost:$PORT$ENDPOINT" 2>&1)
    
    # Parse results
    local REQ_SEC=$(echo "$RESULT" | grep "Requests/sec:" | awk '{print $2}')
    local TRANSFER_SEC=$(echo "$RESULT" | grep "Transfer/sec:" | awk '{print $2}')
    local LATENCY_AVG=$(echo "$RESULT" | grep "Latency" | head -n 1 | awk '{print $2}')
    local LATENCY_STDEV=$(echo "$RESULT" | grep "Latency" | head -n 1 | awk '{print $3}')
    local LATENCY_MAX=$(echo "$RESULT" | grep "Latency" | head -n 1 | awk '{print $4}')
    
    # Get percentiles
    local LAT_50=$(echo "$RESULT" | grep "50%" | awk '{print $2}')
    local LAT_75=$(echo "$RESULT" | grep "75%" | awk '{print $2}')
    local LAT_90=$(echo "$RESULT" | grep "90%" | awk '{print $2}')
    local LAT_99=$(echo "$RESULT" | grep "99%" | awk '{print $2}')
    
    # Stop server
    kill $PID 2>/dev/null || true
    wait $PID 2>/dev/null || true
    
    echo -e "  ${GREEN}Completed: $REQ_SEC req/sec${NC}"
    
    # Save results using jq
    local TEMP_ENTRY=$(jq -n \
        --arg name "$NAME" \
        --arg runtime "$RUNTIME" \
        --arg framework "$FRAMEWORK" \
        --arg port "$PORT" \
        --arg req_sec "$REQ_SEC" \
        --arg transfer_sec "$TRANSFER_SEC" \
        --arg latency_avg "$LATENCY_AVG" \
        --arg latency_stdev "$LATENCY_STDEV" \
        --arg latency_max "$LATENCY_MAX" \
        --arg lat_50 "$LAT_50" \
        --arg lat_75 "$LAT_75" \
        --arg lat_90 "$LAT_90" \
        --arg lat_99 "$LAT_99" \
        '{
            name: $name,
            runtime: $runtime,
            framework: $framework,
            port: $port,
            requests_per_sec: $req_sec,
            transfer_per_sec: $transfer_sec,
            latency: {
                avg: $latency_avg,
                stdev: $latency_stdev,
                max: $latency_max,
                percentile_50: $lat_50,
                percentile_75: $lat_75,
                percentile_90: $lat_90,
                percentile_99: $lat_99
            }
        }')
    
    # Append to results
    jq ". += [$TEMP_ENTRY]" "$TEMP_RESULTS" > "$TEMP_RESULTS.tmp" && mv "$TEMP_RESULTS.tmp" "$TEMP_RESULTS"
    
    cd "$PROJECT_ROOT"
    echo ""
}

echo "=== Node.js Framework Tests ==="
echo ""

# Node.js - Express
run_benchmark "Node.js - Express" "Node.js" "Express" \
    $(jq -r '.ports.nodejs.express' "$CONFIG_FILE") \
    "npm start" \
    "$PROJECT_ROOT/nodejs/express"

# Node.js - Fastify
run_benchmark "Node.js - Fastify" "Node.js" "Fastify" \
    $(jq -r '.ports.nodejs.fastify' "$CONFIG_FILE") \
    "npm start" \
    "$PROJECT_ROOT/nodejs/fastify"

# Node.js - Hono
run_benchmark "Node.js - Hono" "Node.js" "Hono" \
    $(jq -r '.ports.nodejs.hono' "$CONFIG_FILE") \
    "npm start" \
    "$PROJECT_ROOT/nodejs/hono"

# Node.js - Next.js
run_benchmark "Node.js - Next.js" "Node.js" "Next.js" \
    $(jq -r '.ports.nodejs.nextjs' "$CONFIG_FILE") \
    "npm start" \
    "$PROJECT_ROOT/nodejs/nextjs"

echo "=== Bun Framework Tests ==="
echo ""

# Check if Bun is installed
if command -v bun &> /dev/null; then
    # Bun - Express
    run_benchmark "Bun - Express" "Bun" "Express" \
        $(jq -r '.ports.bun.express' "$CONFIG_FILE") \
        "bun index.js" \
        "$PROJECT_ROOT/bun/express"

    # Bun - Fastify
    run_benchmark "Bun - Fastify" "Bun" "Fastify" \
        $(jq -r '.ports.bun.fastify' "$CONFIG_FILE") \
        "bun index.js" \
        "$PROJECT_ROOT/bun/fastify"

    # Bun - Hono
    run_benchmark "Bun - Hono" "Bun" "Hono" \
        $(jq -r '.ports.bun.hono' "$CONFIG_FILE") \
        "bun index.js" \
        "$PROJECT_ROOT/bun/hono"

    # Bun - Elysia
    run_benchmark "Bun - Elysia" "Bun" "Elysia" \
        $(jq -r '.ports.bun.elysia' "$CONFIG_FILE") \
        "bun index.js" \
        "$PROJECT_ROOT/bun/elysia"

    # Bun - Next.js
    run_benchmark "Bun - Next.js" "Bun" "Next.js" \
        $(jq -r '.ports.bun.nextjs' "$CONFIG_FILE") \
        "bun --bun node_modules/next/dist/bin/next start" \
        "$PROJECT_ROOT/bun/nextjs"

    # Bun - Standalone
    run_benchmark "Bun - Standalone" "Bun" "Standalone" \
        $(jq -r '.ports.bun.standalone' "$CONFIG_FILE") \
        "bun index.js" \
        "$PROJECT_ROOT/bun/standalone"
else
    echo -e "${YELLOW}Bun not installed, skipping Bun tests${NC}"
    echo ""
fi

echo "=== Rust Framework Tests ==="
echo ""

# Check if Rust is installed
if command -v cargo &> /dev/null; then
    # Rust - Axum
    cd "$PROJECT_ROOT/rust/axum"
    echo -e "${YELLOW}Testing: Rust - Axum${NC}"
    echo "  Building (release mode)..."
    cargo build --release > /dev/null 2>&1
    run_benchmark "Rust - Axum" "Rust" "Axum" \
        $(jq -r '.ports.rust.axum' "$CONFIG_FILE") \
        "./target/release/axum-performance-test" \
        "$PROJECT_ROOT/rust/axum"

    # Rust - Actix
    cd "$PROJECT_ROOT/rust/actix"
    echo -e "${YELLOW}Testing: Rust - Actix${NC}"
    echo "  Building (release mode)..."
    cargo build --release > /dev/null 2>&1
    run_benchmark "Rust - Actix" "Rust" "Actix-web" \
        $(jq -r '.ports.rust.actix' "$CONFIG_FILE") \
        "./target/release/actix-performance-test" \
        "$PROJECT_ROOT/rust/actix"
else
    echo -e "${YELLOW}Rust not installed, skipping Rust tests${NC}"
    echo ""
fi

echo "=== Kotlin Framework Tests ==="
echo ""

# Check if Java is installed
if command -v java &> /dev/null; then
    # Spring Boot
    cd "$PROJECT_ROOT/kotlin/springboot"
    echo -e "${YELLOW}Testing: Kotlin - Spring Boot${NC}"
    echo "  Building (production mode)..."
    ./gradlew build -x test --no-daemon > /dev/null 2>&1
    run_benchmark "Kotlin - Spring Boot" "JVM" "Spring Boot" \
        $(jq -r '.ports.kotlin.springboot' "$CONFIG_FILE") \
        "java -jar build/libs/springboot-1.0.0.jar" \
        "$PROJECT_ROOT/kotlin/springboot"
else
    echo -e "${YELLOW}Java not installed, skipping Kotlin tests${NC}"
    echo ""
fi

cd "$PROJECT_ROOT"

echo -e "${GREEN}=== All benchmarks completed ===${NC}"
echo "Results saved to: $TEMP_RESULTS"
echo ""

# Generate markdown report
bash "$SCRIPT_DIR/generate-report.sh" "$TEMP_RESULTS"
