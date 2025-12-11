#!/bin/bash

# HabitTracker Build and Archive Script
# This script builds the app and creates an IPA file

set -e

echo "🏗️  Building HabitTracker..."

# Project settings
PROJECT_NAME="HabitTracker"
SCHEME_NAME="HabitTracker"
CONFIGURATION="Release"
BUILD_DIR="./build"
ARCHIVE_PATH="${BUILD_DIR}/${PROJECT_NAME}.xcarchive"
EXPORT_PATH="${BUILD_DIR}/IPA"

# Create build directory
mkdir -p "${BUILD_DIR}"
mkdir -p "${EXPORT_PATH}"

# Step 1: Clean build folder
echo "🧹 Cleaning build folder..."
xcodebuild clean -project "${PROJECT_NAME}.xcodeproj" -scheme "${SCHEME_NAME}" -configuration "${CONFIGURATION}"

# Step 2: Build Archive
echo "📦 Building archive..."
xcodebuild archive \
    -project "${PROJECT_NAME}.xcodeproj" \
    -scheme "${SCHEME_NAME}" \
    -configuration "${CONFIGURATION} \
    -derivedDataPath "${BUILD_DIR}/DerivedData" \
    -archivePath "${ARCHIVE_PATH}" \
    -allowProvisioningUpdates

# Step 3: Export IPA
echo "📱 Exporting IPA..."

# Create ExportOptions.plist
cat > "${BUILD_DIR}/ExportOptions.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>ad-hoc</string>
    <key>teamID</key>
    <string></string>
    <key>signingStyle</key>
    <string>automatic</string>
    <key>stripSwiftSymbols</key>
    <true/>
    <key>thinning</key>
    <string><none></string>
</dict>
</plist>
EOF

xcodebuild -exportArchive \
    -archivePath "${ARCHIVE_PATH}" \
    -exportOptionsPlist "${BUILD_DIR}/ExportOptions.plist" \
    -exportPath "${EXPORT_PATH}"

# Step 4: Verify IPA
echo "✅ Verifying IPA..."
if [ -f "${EXPORT_PATH}/${PROJECT_NAME}.ipa" ]; then
    IPA_SIZE=$(du -h "${EXPORT_PATH}/${PROJECT_NAME}.ipa" | cut -f1)
    echo "✨ Success! IPA created: ${EXPORT_PATH}/${PROJECT_NAME}.ipa (${IPA_SIZE})"
else
    echo "❌ Error: IPA file not found!"
    exit 1
fi

echo ""
echo "📋 Build Information:"
echo "   Project: ${PROJECT_NAME}"
echo "   Scheme: ${SCHEME_NAME}"
echo "   Configuration: ${CONFIGURATION}"
echo "   Archive: ${ARCHIVE_PATH}"
echo "   IPA Output: ${EXPORT_PATH}/${PROJECT_NAME}.ipa"
echo ""
echo "🎉 Build complete!"
