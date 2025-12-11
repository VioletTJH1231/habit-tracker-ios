.PHONY: help build run test archive clean install-deps

PROJECT_NAME := HabitTracker
SCHEME := HabitTracker
CONFIGURATION := Release
BUILD_DIR := ./build
ARCHIVE_PATH := $(BUILD_DIR)/$(PROJECT_NAME).xcarchive
IPA_PATH := $(BUILD_DIR)/IPA

help:
	@echo "📱 HabitTracker Build Commands"
	@echo ""
	@echo "make build          - Build for simulator"
	@echo "make build-device   - Build for physical device"
	@echo "make run            - Build and run on simulator"
	@echo "make test           - Run unit tests"
	@echo "make archive        - Create archive"
	@echo "make ipa            - Create IPA file"
	@echo "make clean          - Clean build artifacts"
	@echo "make open           - Open project in Xcode"
	@echo "make format         - Format code with SwiftFormat"
	@echo "make lint           - Run SwiftLint"
	@echo ""

build:
	@echo "🏗️  Building for simulator..."
	xcodebuild build \
		-scheme $(SCHEME) \
		-configuration $(CONFIGURATION) \
		-derivedDataPath $(BUILD_DIR)/DerivedData \
		-destination 'generic/platform=iOS Simulator'

build-device:
	@echo "🏗️  Building for device..."
	xcodebuild build-for-testing \
		-scheme $(SCHEME) \
		-configuration $(CONFIGURATION) \
		-derivedDataPath $(BUILD_DIR)/DerivedData \
		-destination 'generic/platform=iOS'

run:
	@echo "▶️  Building and running on simulator..."
	xcodebuild \
		-scheme $(SCHEME) \
		-configuration Debug \
		-derivedDataPath $(BUILD_DIR)/DerivedData \
		-destination 'platform=iOS Simulator,name=iPhone 15'

test:
	@echo "🧪 Running tests..."
	xcodebuild test \
		-scheme $(SCHEME) \
		-configuration Debug \
		-derivedDataPath $(BUILD_DIR)/DerivedData \
		-destination 'platform=iOS Simulator,name=iPhone 15'

archive:
	@echo "📦 Creating archive..."
	@mkdir -p $(BUILD_DIR)
	xcodebuild archive \
		-project $(PROJECT_NAME).xcodeproj \
		-scheme $(SCHEME) \
		-configuration $(CONFIGURATION) \
		-derivedDataPath $(BUILD_DIR)/DerivedData \
		-archivePath $(ARCHIVE_PATH)
	@echo "✅ Archive created at $(ARCHIVE_PATH)"

ipa: archive
	@echo "📱 Exporting IPA..."
	@mkdir -p $(IPA_PATH)
	@cat > $(BUILD_DIR)/ExportOptions.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>method</key>
	<string>ad-hoc</string>
	<key>signingStyle</key>
	<string>automatic</string>
	<key>stripSwiftSymbols</key>
	<true/>
</dict>
</plist>
EOF
	xcodebuild -exportArchive \
		-archivePath $(ARCHIVE_PATH) \
		-exportOptionsPlist $(BUILD_DIR)/ExportOptions.plist \
		-exportPath $(IPA_PATH)
	@echo "✨ IPA created at $(IPA_PATH)/$(PROJECT_NAME).ipa"
	@ls -lh $(IPA_PATH)/$(PROJECT_NAME).ipa

clean:
	@echo "🧹 Cleaning build artifacts..."
	rm -rf $(BUILD_DIR)
	rm -rf .build
	xcodebuild clean \
		-project $(PROJECT_NAME).xcodeproj \
		-scheme $(SCHEME)
	@echo "✅ Clean complete"

open:
	@echo "📂 Opening project in Xcode..."
	open $(PROJECT_NAME).xcodeproj

format:
	@echo "🎨 Formatting code..."
	@if ! command -v swiftformat &> /dev/null; then \
		echo "SwiftFormat not installed. Installing..."; \
		brew install swiftformat; \
	fi
	swiftformat .

lint:
	@echo "🔍 Running SwiftLint..."
	@if ! command -v swiftlint &> /dev/null; then \
		echo "SwiftLint not installed. Installing..."; \
		brew install swiftlint; \
	fi
	swiftlint

install-deps:
	@echo "📦 Installing dependencies..."
	@echo "Checking Xcode tools..."
	xcode-select --install || true

check-env:
	@echo "🔍 Checking build environment..."
	@echo "Xcode version:"
	@xcodebuild -version
	@echo ""
	@echo "Swift version:"
	@swift --version
	@echo ""
	@echo "iOS SDK version:"
	@xcrun --show-sdk-version --sdk iphoneos
