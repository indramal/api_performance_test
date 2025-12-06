# API Performance Testing Suite

A comprehensive performance benchmarking suite for comparing API frameworks across Node.js, Bun, and Rust runtimes.

## 📋 Overview

This project provides automated performance testing for the following frameworks:

### Node.js Runtime
- **Express.js** - Fast, unopinionated web framework
- **Fastify.js** - High-performance web framework
- **Hono.js** - Ultrafast web framework (with Node.js adapter)
- **Next.js** - React framework with API routes

### Bun Runtime
- **Express.js on Bun** - Express running on Bun runtime
- **Fastify.js on Bun** - Fastify running on Bun runtime
- **Hono.js on Bun** - Hono optimized for Bun
- **Elysia.js** - Bun-native web framework
- **Next.js on Bun** - Next.js running on Bun
- **Bun Standalone** - Pure Bun HTTP server

### Rust Runtime
- **Axum** - Ergonomic web framework built on Tokio
- **Actix-web** - Powerful, pragmatic web framework

## 🚀 Quick Start

### Prerequisites

- **Node.js** (v18 or later)
- **Bun** (latest version)
- **Rust** (stable toolchain)
- **wrk** - HTTP benchmarking tool
- **jq** - JSON processor for reports

### Installation

#### Install wrk
```bash
# Ubuntu/Debian
sudo apt-get install wrk

# macOS
brew install wrk

# From source
git clone https://github.com/wg/wrk.git
cd wrk
make
sudo cp wrk /usr/local/bin/
```

#### Install jq
```bash
# Ubuntu/Debian
sudo apt-get install jq

# macOS
brew install jq
```

### Running Benchmarks Locally

1. **Install dependencies for all projects:**

```bash
cd api_performance_test

# Node.js projects
for dir in nodejs/*/; do
  cd "$dir"
  npm install
  [ -f "next.config.js" ] && npm run build
  cd ../../
done

# Bun projects
for dir in bun/*/; do
  cd "$dir"
  bun install
  cd ../../
done

# Rust projects
cd rust/axum && cargo build --release && cd ../../
cd rust/actix && cargo build --release && cd ../../
```

2. **Make scripts executable:**

```bash
chmod +x scripts/*.sh
```

3. **Run benchmarks:**

```bash
bash scripts/run-benchmarks.sh
```

4. **View results:**

Reports are generated in the `results/` directory with timestamps.

## ⚙️ Configuration

Edit `config/test-config.json` to adjust benchmark parameters:

```json
{
  "wrk": {
    "duration": "30s",
    "threads": 12,
    "connections": 400,
    "timeout": "10s"
  }
}
```

## 📊 Report Format

Generated reports include:

- **System Information**: CPU, RAM, GPU, OS details
- **Test Configuration**: wrk parameters used
- **Performance Summary**: Ranked table of all frameworks
- **Detailed Results**: Complete metrics by runtime
- **Runtime Comparison**: Average performance by runtime

### Metrics Captured

- Requests per second
- Transfer rate
- Latency (avg, stdev, max)
- Latency percentiles (P50, P75, P90, P99)

## 🔄 GitHub Actions

The workflow automatically runs on:
- Push to `main` or `master` branch
- Pull requests
- Manual workflow dispatch

Results are uploaded as artifacts and (for PRs) commented on the pull request.

## 📁 Project Structure

```
api_performance_test/
├── .github/workflows/       # CI/CD workflows
├── config/                  # Test configuration
├── scripts/                 # Benchmark and report scripts
├── nodejs/                  # Node.js implementations
├── bun/                     # Bun implementations
├── rust/                    # Rust implementations
└── results/                 # Generated reports
```

## 🧪 Test Endpoint

All implementations expose the same endpoint:

```
GET /api/v1/test
```

**Response:**
```json
{
  "message": "success",
  "timestamp": "2024-12-06T09:42:30.123Z",
  "framework": "Express.js",
  "runtime": "Node.js"
}
```

## 🛠️ Development

### Adding a New Framework

1. Create a new directory in the appropriate runtime folder
2. Implement the `/api/v1/test` endpoint
3. Add port configuration to `config/test-config.json`
4. Add benchmark call to `scripts/run-benchmarks.sh`

### Modifying Test Parameters

Edit `config/test-config.json` to change:
- Test duration
- Number of threads
- Connection count
- Warmup settings

## 📝 License

This project is provided as-is for performance testing and comparison purposes.

## 🤝 Contributing

Contributions welcome! Please ensure:
- New frameworks follow the existing structure
- Endpoints return the standard response format
- Documentation is updated

## 📮 Support

For issues or questions, please open a GitHub issue.
