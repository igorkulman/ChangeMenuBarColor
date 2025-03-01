#!/bin/bash

# Build script for ChangeMenuBarColor binary release
# Creates a universal binary that works on both Intel and ARM Macs

set -e

# Set up variables
PROJECT_NAME="ChangeMenuBarColor"
OUTPUT_DIR="./build"
RELEASE_DIR="$OUTPUT_DIR/release"
VERSION=$(git describe --tags --abbrev=0 2>/dev/null || echo "1.0.0")

# Create directory structure
echo "Creating build directories..."
mkdir -p "$OUTPUT_DIR/arm64"
mkdir -p "$OUTPUT_DIR/x86_64"
mkdir -p "$RELEASE_DIR"

# Build for ARM64 architecture (Apple Silicon)
echo "Building for ARM64 architecture (Apple Silicon)..."
swift build --configuration release --arch arm64 -Xswiftc "-target" -Xswiftc "arm64-apple-macosx10.15"
cp -f ".build/arm64-apple-macosx/release/$PROJECT_NAME" "$OUTPUT_DIR/arm64/"

# Build for x86_64 architecture (Intel)
echo "Building for x86_64 architecture (Intel)..."
swift build --configuration release --arch x86_64 -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.15"
cp -f ".build/x86_64-apple-macosx/release/$PROJECT_NAME" "$OUTPUT_DIR/x86_64/"

# Create universal binary
echo "Creating universal binary..."
lipo -create -output "$RELEASE_DIR/$PROJECT_NAME" "$OUTPUT_DIR/arm64/$PROJECT_NAME" "$OUTPUT_DIR/x86_64/$PROJECT_NAME"

# Check the binary architectures
echo "Verifying architectures in the universal binary:"
lipo -info "$RELEASE_DIR/$PROJECT_NAME"

# Create a zip file for distribution
echo "Creating zip archive for distribution..."
cd "$RELEASE_DIR" || exit
zip -r "../$PROJECT_NAME-$VERSION.zip" "$PROJECT_NAME"
cd - || exit

echo "✅ Build complete!"
echo "Universal binary is available at: $RELEASE_DIR/$PROJECT_NAME"
echo "Zip archive is available at: $OUTPUT_DIR/$PROJECT_NAME-$VERSION.zip"