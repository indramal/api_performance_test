# API Performance Benchmark Report

**Generated:** 2025-12-06 11:07:45

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
| 1  |  Rust  |  Actix-web  |  121604.29  |  3.22ms  |  7.14ms |
| 2  |  Rust  |  Axum  |  110746.20  |  3.54ms  |  8.64ms |
| 3  |  Bun  |  Standalone  |  54479.84  |  7.26ms  |  8.18ms |
| 4  |  Bun  |  Elysia  |  51451.02  |  7.70ms  |  8.63ms |
| 5  |  Bun  |  Hono  |  43433.37  |  9.11ms  |  10.24ms |
| 6  |  JVM  |  Spring Boot  |  38057.60  |  10.64ms  |  27.61ms |
| 7  |  Bun  |  Fastify  |  28602.18  |  13.84ms  |  17.33ms |
| 8  |  Bun  |  Express  |  21846.65  |  18.11ms  |  22.84ms |
| 9  |  Node.js  |  Fastify  |  20971.35  |  28.05ms  |  391.72ms |
| 10  |  Node.js  |  Hono  |  18918.71  |  28.80ms  |  321.92ms |
| 11  |  Node.js  |  Express  |  7101.00  |  54.18ms  |  65.35ms |
| 12  |  Node.js  |  Next.js  |  3103.20  |  133.78ms  |  514.41ms |
| 13  |  Bun  |  Next.js  |  2201.10  |  179.70ms  |  201.78ms |

## Detailed Results

### Node.js Runtime

| Framework | Requests/sec | Transfer/sec | Avg Latency | Stdev | Max | P50 | P75 | P90 | P99 |
|-----------|--------------|--------------|-------------|-------|-----|-----|-----|-----|-----|
| Express  |  7101.00  |  2.31MB  |  54.18ms  |  72.04ms  |  2.00s  |  53.65ms  |  56.17ms  |  58.28ms  |  65.35ms |
| Fastify  |  20971.35  |  5.54MB  |  28.05ms  |  96.63ms  |  2.00s  |  18.57ms  |  19.85ms  |  21.07ms  |  391.72ms |
| Hono  |  18918.71  |  4.65MB  |  28.80ms  |  90.47ms  |  1.99s  |  20.52ms  |  21.60ms  |  22.98ms  |  321.92ms |
| Next.js  |  3103.20  |  1.05MB  |  133.78ms  |  96.66ms  |  1.94s  |  124.87ms  |  127.70ms  |  145.29ms  |  514.41ms |

### Bun Runtime

| Framework | Requests/sec | Transfer/sec | Avg Latency | Stdev | Max | P50 | P75 | P90 | P99 |
|-----------|--------------|--------------|-------------|-------|-----|-----|-----|-----|-----|
| Express  |  21846.65  |  6.04MB  |  18.11ms  |  1.85ms  |  51.56ms  |  18.16ms  |  19.12ms  |  20.22ms  |  22.84ms |
| Fastify  |  28602.18  |  6.14MB  |  13.84ms  |  1.34ms  |  48.98ms  |  2.40k |  |  |  |
| 13.69ms  |  14.50ms  |  15.31ms  |  17.33ms |  |  |  |  |  |  |
| Hono  |  43433.37  |  8.53MB  |  9.11ms  |  523.51us  |  23.71ms  |  9.12ms  |  9.44ms  |  9.71ms  |  10.24ms |
| Elysia  |  51451.02  |  10.26MB  |  7.70ms  |  503.86us  |  28.91ms  |  7.73ms  |  7.93ms  |  8.14ms  |  8.63ms |
| Next.js  |  2201.10  |  717.94KB  |  179.70ms  |  8.96ms  |  223.94ms  |  178.89ms  |  185.15ms  |  190.88ms  |  201.78ms |
| Standalone  |  54479.84  |  11.64MB  |  7.26ms  |  430.97us  |  21.49ms  |  7.27ms  |  7.52ms  |  7.76ms  |  8.18ms |

### Rust Runtime

| Framework | Requests/sec | Transfer/sec | Avg Latency | Stdev | Max | P50 | P75 | P90 | P99 |
|-----------|--------------|--------------|-------------|-------|-----|-----|-----|-----|-----|
| Axum  |  110746.20  |  22.81MB  |  3.54ms  |  1.80ms  |  21.52ms  |  3.34ms  |  4.60ms  |  5.90ms  |  8.64ms |
| Actix-web  |  121604.29  |  25.63MB  |  3.22ms  |  1.37ms  |  28.96ms  |  3.11ms  |  3.91ms  |  4.93ms  |  7.14ms |

## Runtime Comparison

Average performance by runtime:

| Runtime | Avg Requests/sec | Frameworks Tested |
|---------|------------------|-------------------|
| Node.js | 12524 | 4 |
| Bun | 33669 | 6 |
| Rust | 116175 | 2 |

## Notes

- All tests performed using [wrk](https://github.com/wg/wrk) HTTP benchmarking tool
- Each server was given a 5-second warmup period before benchmarking
- Latency values are in the format reported by wrk (typically microseconds or milliseconds)
- Results may vary based on system load, hardware, and runtime versions

