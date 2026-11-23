#!/usr/bin/env bash
# verify_hints.sh: verifies mini-examples from instructions.append.md

set -euo pipefail

echo "=== Testing hint 1: Associative Array ==="
declare -A counts=([A]=0 [C]=0 [G]=0 [T]=0)
counts[A]=$(( counts[A] + 1 ))
echo "A: ${counts[A]}"

echo "=== Testing hint 2: Glob Pattern Validation ==="
strand="AGCT"
if [[ $strand == *[^ACGT]* ]]; then echo "invalid"; else echo "valid: $strand"; fi
strand="AGXXACT"
if [[ $strand == *[^ACGT]* ]]; then echo "invalid: $strand"; else echo "valid"; fi

echo "=== Testing hint 3: Regex Pattern Validation ==="
strand="AGCT"
if [[ $strand =~ [^ACGT] ]]; then echo "invalid"; else echo "valid: $strand"; fi
strand="AGXXACT"
if [[ $strand =~ [^ACGT] ]]; then echo "invalid: $strand"; else echo "valid"; fi

echo "=== All hint mini-examples verified successfully ==="
