# API Performance Benchmark Report

**Generated:** 2025-12-06 12:32:21

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
- Java: 21.0.9
- wrk: wrk debian/4.1.0-4build2 [epoll] Copyright (C) 2012 Will Glozer


## Test Configuration

- **Duration:** 30s
- **Threads:** 12
- **Connections:** 400
- **Endpoint:** /api/v1/test

## Performance Summary

| Rank | Runtime | Framework | Requests/sec | Avg Latency | P99 Latency |
|------|---------|-----------|--------------|-------------|-------------|
| 1  |  Rust  |  Actix-web  |  120873.78  |  3.23ms  |  7.11ms |
| 2  |  Rust  |  Axum  |  110103.02  |  3.56ms  |  8.77ms |
| 3  |  Bun  |  Elysia  |  50715.21  |  7.80ms  |  9.07ms |
| 4  |  Bun  |  Standalone  |  48719.59  |  8.12ms  |  9.20ms |
| 5  |  Bun  |  Hono  |  40717.43  |  9.72ms  |  10.82ms |
| 6  |  JVM  |  Spring Boot  |  36981.34  |  10.83ms  |  27.48ms |
| 7  |  Bun  |  Fastify  |  26668.99  |  14.84ms  |  17.97ms |
| 8  |  Bun  |  Express  |  21082.07  |  18.78ms  |  23.46ms |
| 9  |  Node.js  |  Fastify  |  20686.42  |  28.03ms  |  372.66ms |
| 10  |  Node.js  |  Hono  |  18439.46  |  29.39ms  |  317.20ms |
| 11  |  Node.js  |  Express  |  7007.40  |  55.06ms  |  66.25ms |
| 12  |  Node.js  |  Next.js  |  3079.92  |  135.18ms  |  553.08ms |
| 13  |  Bun  |  Next.js  |  2156.05  |  183.06ms  |  207.39ms |

## Detailed Results

### Node.js Runtime

| Framework | Requests/sec | Transfer/sec | Avg Latency | Stdev | Max | P50 | P75 | P90 | P99 |
|-----------|--------------|--------------|-------------|-------|-----|-----|-----|-----|-----|
| Express  |  7007.40  |  2.28MB  |  55.06ms  |  73.80ms  |  1.99s  |  54.71ms  |  57.12ms  |  59.37ms  |  66.25ms |
| Fastify  |  20686.42  |  5.46MB  |  28.03ms  |  96.00ms  |  2.00s  |  18.79ms  |  20.15ms  |  21.33ms  |  372.66ms |
| Hono  |  18439.46  |  4.54MB  |  29.39ms  |  91.77ms  |  1.99s  |  21.33ms  |  22.27ms  |  23.26ms  |  317.20ms |
| Next.js  |  3079.92  |  1.04MB  |  135.18ms  |  100.72ms  |  1.97s  |  125.62ms  |  128.53ms  |  148.12ms  |  553.08ms |

### Bun Runtime

| Framework | Requests/sec | Transfer/sec | Avg Latency | Stdev | Max | P50 | P75 | P90 | P99 |
|-----------|--------------|--------------|-------------|-------|-----|-----|-----|-----|-----|
| Express  |  21082.07  |  5.83MB  |  18.78ms  |  1.87ms  |  58.77ms  |  18.76ms  |  19.84ms  |  20.84ms  |  23.46ms |
| Fastify  |  26668.99  |  5.72MB  |  14.84ms  |  1.26ms  |  46.99ms  |  14.77ms  |  15.53ms  |  16.27ms  |  17.97ms |
| Hono  |  40717.43  |  8.00MB  |  9.72ms  |  514.50us  |  25.57ms  |  9.72ms  |  10.02ms  |  10.28ms  |  10.82ms |
| Elysia  |  50715.21  |  10.11MB  |  7.80ms  |  565.63us  |  21.12ms  |  7.78ms  |  8.17ms  |  8.48ms  |  9.07ms |
| Next.js  |  2156.05  |  703.24KB  |  183.06ms  |  12.07ms  |  325.57ms  |  181.95ms  |  187.38ms  |  197.32ms  |  207.39ms |
| Standalone  |  48719.59  |  10.41MB  |  8.12ms  |  530.42us  |  24.74ms  |  8.12ms  |  8.42ms  |  8.69ms  |  9.20ms |

### Rust Runtime

| Framework | Requests/sec | Transfer/sec | Avg Latency | Stdev | Max | P50 | P75 | P90 | P99 |
|-----------|--------------|--------------|-------------|-------|-----|-----|-----|-----|-----|
| Axum  |  110103.02  |  22.68MB  |  3.56ms  |  1.82ms  |  18.81ms  |  3.35ms  |  4.64ms  |  5.97ms  |  8.77ms |
| Actix-web  |  120873.78  |  25.48MB  |  3.23ms  |  1.35ms  |  17.02ms  |  3.13ms  |  3.93ms  |  4.95ms  |  7.11ms |

### JVM Runtime

| Framework | Requests/sec | Transfer/sec | Avg Latency | Stdev | Max | P50 | P75 | P90 | P99 |
|-----------|--------------|--------------|-------------|-------|-----|-----|-----|-----|-----|
| Spring Boot  |  36981.34  |  8.54MB  |  10.83ms  |  7.18ms  |  279.46ms  |  11.46ms  |  14.07ms  |  17.19ms  |  27.48ms |

## Runtime Comparison

Average performance by runtime:

| Runtime | Avg Requests/sec | Frameworks Tested |
|---------|------------------|-------------------|
| Node.js | 12303 | 4 |
| Bun | 31677 | 6 |
| Rust | 115488 | 2 |
| JVM | 36981 | 1 |

## Notes

- All tests performed using [wrk](https://github.com/wg/wrk) HTTP benchmarking tool
- Each server was given a 5-second warmup period before benchmarking
- Latency values are in the format reported by wrk (typically microseconds or milliseconds)
- Results may vary based on system load, hardware, and runtime versions

