#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=== Android CI Test Runner ==="
echo "Working directory: $PACKAGE_DIR"
echo ""

# ========== Phase 1: Standalone Tests ==========
echo "=== Phase 1: Running Standalone Tests ==="
echo "These tests run the core library code without React Native dependencies."
echo ""

cd "$SCRIPT_DIR"
./gradlew test --console=plain

echo ""
echo "=== Standalone Tests Complete ==="
echo ""

# ========== Phase 2: Native Test Harness ==========
echo "=== Phase 2: Running Native Test Harness Tests ==="
echo "These tests run with full React Native/Fabric context."
echo ""

# Install native-tests dependencies
cd "$PACKAGE_DIR/native-tests"
if [ ! -d "node_modules" ]; then
    echo "Installing native-tests dependencies..."
    yarn install
fi

# Run tests from native-tests/android
cd "$PACKAGE_DIR/native-tests/android"
./gradlew :app:test --console=plain

echo ""
echo "=== Native Test Harness Tests Complete ==="
echo ""
echo "=== All Android Tests Complete ==="
