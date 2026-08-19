#!/bin/bash

# Script to check pana score for Flutter package

set -e

PACKAGE_DIR=${1:-flutter}

echo "🔍 Running pana analysis on $PACKAGE_DIR..."

cd "$PACKAGE_DIR"

# Install dependencies
echo "📦 Installing dependencies..."
flutter pub get

# Run pana
echo "🧪 Running pana..."
flutter pub global activate pana
flutter pub global run pana --no-warning --scores

echo "✅ Pana analysis complete!"
