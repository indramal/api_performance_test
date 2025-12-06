# API Performance Benchmark Report

**Generated:** 2025-12-06 10:19:26

## System Information

=== System Information ===

**Operating System:**
- OS: Ubuntu 24.04.3 LTS (Noble Numbat)
- Kernel: 6.11.0-1018-azure
- Architecture: x86_64

**CPU:**
- Model: AMD EPYC 7763 64-Core Processor
- Cores: 4
- Threads per core: 2

**Memory:**
- Total RAM: 15Gi
- Available RAM: 14Gi

**GPU:**
- 00:08.0 VGA compatible controller: Microsoft Corporation Hyper-V virtual VGA

**Runtime Versions:**
- Node.js: v20.19.6
- Bun: 1.3.3
- Rust: 1.91.1
- wrk: wrk debian/4.1.0-4build2 [epoll] Copyright (C) 2012 Will Glozer


## Test Configuration

- **Duration:** 30s
- **Threads:** 12
- **Connections:** 400
- **Endpoint:** /api/v1/test

## Performance Summary

| Rank | Runtime | Framework | Requests/sec | Avg Latency | P99 Latency |
|------|---------|-----------|--------------|-------------|-------------|
| 1  |  Rust  |  Actix-web  |  121380.44  |  3.22ms  |  6.99ms |
| 2  |  Rust  |  Axum  |  106900.28  |  3.67ms  |  8.92ms |
| 3  |  Bun  |  Elysia  |  50446.35  |  7.84ms  |  9.26ms |
| 4  |  Bun  |  Standalone  |  49094.73  |  8.06ms  |  9.69ms |
| 5  |  Bun  |  Hono  |  40764.99  |  9.71ms  |  11.27ms |
| 6  |  Bun  |  Fastify  |  27039.36  |  14.64ms  |  18.94ms |
| 7  |  Bun  |  Express  |  20716.91  |  19.10ms  |  23.40ms |
| 8  |  Node.js  |  Fastify  |  20562.88  |  28.43ms  |  397.81ms |
| 9  |  Node.js  |  Hono  |  18335.44  |  29.42ms  |  308.52ms |
| 10  |  Node.js  |  Express  |  6993.61  |  55.02ms  |  68.30ms |
| 11  |  Node.js  |  Next.js  |  3007.61  |  136.80ms  |  474.49ms |
| 12  |  Bun  |  Next.js  |  2134.22  |  184.45ms  |  211.69ms |

## Detailed Results

### Node.js Runtime

| Framework | Requests/sec | Transfer/sec | Avg Latency | Stdev | Max | P50 | P75 | P90 | P99 |
|-----------|--------------|--------------|-------------|-------|-----|-----|-----|-----|-----|
| Express  |  6993.61  |  2.27MB  |  55.02ms  |  72.75ms  |  1.99s  |  54.22ms  |  57.51ms  |  60.25ms  |  68.30ms |
| Fastify  |  20562.88  |  5.43MB  |  28.43ms  |  97.25ms  |  2.00s  |  19.00ms  |  20.18ms  |  21.29ms  |  397.81ms |
| Hono  |  18335.44  |  4.51MB  |  29.42ms  |  91.32ms  |  1.99s  |  21.34ms  |  22.71ms  |  23.95ms  |  308.52ms |
| Next.js  |  3007.61  |  1.02MB  |  136.80ms  |  92.69ms  |  1.89s  |  128.40ms  |  133.89ms  |  147.54ms  |  474.49ms |

### Bun Runtime

| Framework | Requests/sec | Transfer/sec | Avg Latency | Stdev | Max | P50 | P75 | P90 | P99 |
|-----------|--------------|--------------|-------------|-------|-----|-----|-----|-----|-----|
| Express  |  20716.91  |  5.73MB  |  19.10ms  |  1.79ms  |  53.53ms  |  19.10ms |  |  |  |
| 18.98ms  |  20.23ms  |  21.26ms  |  23.40ms |  |  |  |  |  |  |
| Fastify  |  27039.36  |  5.80MB  |  14.64ms  |  1.48ms  |  44.98ms  |  14.41ms  |  15.31ms  |  16.52ms  |  18.94ms |
| Hono  |  40764.99  |  8.01MB  |  9.71ms  |  606.21us  |  27.77ms  |  9.65ms  |  10.00ms  |  10.40ms  |  11.27ms |
| Elysia  |  50446.35  |  10.05MB  |  7.84ms  |  493.41us  |  21.03ms  |  7.79ms  |  8.07ms  |  8.41ms  |  9.26ms |
| Next.js  |  2134.22  |  698.75KB  |  184.45ms  |  10.61ms  |  215.03ms  |  183.15ms  |  191.41ms  |  199.07ms  |  211.69ms |
| Standalone  |  49094.73  |  10.49MB  |  8.06ms  |  673.55us  |  21.32ms  |  8.04ms  |  4.11k |  |  |
| 8.47ms  |  8.90ms  |  9.69ms |  |  |  |  |  |  |  |

### Rust Runtime

| Framework | Requests/sec | Transfer/sec | Avg Latency | Stdev | Max | P50 | P75 | P90 | P99 |
|-----------|--------------|--------------|-------------|-------|-----|-----|-----|-----|-----|
| Axum  |  106900.28  |  22.02MB  |  3.67ms  |  1.84ms  |  18.48ms  |  3.47ms  |  4.76ms  |  6.09ms  |  8.92ms |
| Actix-web  |  121380.44  |  25.58MB  |  3.22ms  |  1.34ms  |  25.45ms  |  3.13ms  |  3.90ms  |  4.89ms  |  6.99ms |

## Runtime Comparison

Average performance by runtime:

| Runtime | Avg Requests/sec | Frameworks Tested |
|---------|------------------|-------------------|
| Node.js | 12225 | 4 |
| Bun | 31699 | 6 |
| Rust | 114140 | 2 |

## Notes

- All tests performed using [wrk](https://github.com/wg/wrk) HTTP benchmarking tool
- Each server was given a 5-second warmup period before benchmarking
- Latency values are in the format reported by wrk (typically microseconds or milliseconds)
- Results may vary based on system load, hardware, and runtime versions

