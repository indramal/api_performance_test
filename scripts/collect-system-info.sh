#!/bin/bash

# Collect system information for benchmark reports

echo "=== System Information ==="
echo ""

# OS Information
echo "**Operating System:**"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "- OS: $NAME $VERSION"
    echo "- Kernel: $(uname -r)"
else
    echo "- OS: $(uname -s)"
    echo "- Kernel: $(uname -r)"
fi
echo "- Architecture: $(uname -m)"
echo ""

# CPU Information
echo "**CPU:**"
if command -v lscpu &> /dev/null; then
    CPU_MODEL=$(lscpu | grep "Model name" | sed 's/Model name:[[:space:]]*//')
    CPU_CORES=$(lscpu | grep "^CPU(s):" | awk '{print $2}')
    CPU_THREADS=$(lscpu | grep "^Thread(s) per core:" | awk '{print $4}')
    echo "- Model: $CPU_MODEL"
    echo "- Cores: $CPU_CORES"
    echo "- Threads per core: $CPU_THREADS"
else
    echo "- $(nproc) processors"
fi
echo ""

# Memory Information
echo "**Memory:**"
if command -v free &> /dev/null; then
    TOTAL_RAM=$(free -h | awk '/^Mem:/ {print $2}')
    AVAILABLE_RAM=$(free -h | awk '/^Mem:/ {print $7}')
    echo "- Total RAM: $TOTAL_RAM"
    echo "- Available RAM: $AVAILABLE_RAM"
else
    echo "- Memory info not available"
fi
echo ""

# GPU Information
echo "**GPU:**"
if command -v lspci &> /dev/null; then
    GPU_INFO=$(lspci | grep -i 'vga\|3d\|display' | head -n 1)
    if [ -n "$GPU_INFO" ]; then
        echo "- $GPU_INFO"
    else
        echo "- No dedicated GPU detected"
    fi
else
    echo "- GPU info not available"
fi
echo ""

# Runtime Versions
echo "**Runtime Versions:**"

# Node.js
if command -v node &> /dev/null; then
    echo "- Node.js: $(node --version)"
else
    echo "- Node.js: Not installed"
fi

# Bun
if command -v bun &> /dev/null; then
    echo "- Bun: $(bun --version)"
else
    echo "- Bun: Not installed"
fi

# Rust
if command -v rustc &> /dev/null; then
    echo "- Rust: $(rustc --version | awk '{print $2}')"
else
    echo "- Rust: Not installed"
fi

# Java
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | head -n 1 | awk -F '"' '{print $2}')
    echo "- Java: $JAVA_VERSION"
else
    echo "- Java: Not installed"
fi

# wrk
if command -v wrk &> /dev/null; then
    echo "- wrk: $(wrk --version 2>&1 | head -n 1)"
else
    echo "- wrk: Not installed"
fi

echo ""
