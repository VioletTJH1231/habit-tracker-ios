# 📦 Building HabitTracker - Complete Guide

This guide explains how to compile the HabitTracker iOS app into an IPA file ready for distribution.

## 📋 Prerequisites

- **Xcode 15.0+** - Download from [App Store](https://apps.apple.com/app/xcode/id497799835)
- **iOS 17.0+** - Target device or simulator running iOS 17 or later
- **Apple Developer Account** - For code signing and distribution
- **CocoaPods** (optional) - If using pods (not needed for this project)

## 🏗️ Project Structure

```
HabitTracker/
├── HabitTracker.xcodeproj/        # Xcode project configuration
│   ├── project.pbxproj            # Project build settings
│   └── HabitTracker.xcconfig       # Build configuration file
├── HabitTracker.xcworkspace/       # Xcode workspace
├── HabitTracker/                   # Main app source code
│   ├── AppDelegate.swift           # App lifecycle management
│   ├── SceneDelegate.swift         # Scene/window management
│   ├── HabitTrackerApp.swift       # SwiftUI app entry
│   ├── Info.plist                  # App configuration
│   ├── LaunchScreen.storyboard     # Launch screen UI
│   ├── Assets.xcassets/            # App icons & colors
│   ├── Models/                     # Data models
│   ├── Views/                      # SwiftUI views
│   ├── ViewModels/                 # MVVM view models
│   ├── Components/                 # Reusable UI components
│   ├── Services/                   # Business logic services
│   ├── Utils/                      # Utility helpers
│   └── Widgets/                    # Home screen widgets
└── build.sh                        # Build automation script
```

## 🔨 Building with Xcode

### Method 1: Using Xcode GUI (Recommended for first-time)

1. **Open the Project**
   ```bash
   open HabitTracker.xcodeproj
   ```
   Or open `HabitTracker.xcworkspace` if using CocoaPods.

2. **Select Target and Scheme**
   - Top menu: Select **HabitTracker** target
   - Scheme dropdown: Select **HabitTracker**

3. **Select Destination**
   - Choose your device or simulator from top menu
   - For real device: Connect iPhone via USB

4. **Build & Run**
   - Press `Cmd + R` to build and run
   - App will install on device/simulator

5. **Archive for Distribution**
   - Menu: `Product` → `Archive`
   - Select the archive in Organizer
   - Click `Distribute App` → Choose distribution method

### Method 2: Using Command Line

#### Build for Simulator

```bash
xcodebuild build \
    -scheme HabitTracker \
    -destination 'generic/platform=iOS Simulator' \
    -configuration Release
```

#### Build for Device

```bash
xcodebuild build-for-testing \
    -scheme HabitTracker \
    -destination 'generic/platform=iOS' \
    -configuration Release
```

#### Create Archive

```bash
xcodebuild archive \
    -project HabitTracker.xcodeproj \
    -scheme HabitTracker \
    -configuration Release \
    -archivePath ./build/HabitTracker.xcarchive
```

## 📱 Creating IPA File

### Method 1: Using Xcode Organizer

1. Open Xcode → `Window` → `Organizer`
2. Select the latest archive
3. Click `Distribute App`
4. Choose distribution method:
   - **Ad Hoc**: For testing on selected devices
   - **Enterprise**: For internal company distribution
   - **TestFlight**: For external beta testing
   - **App Store**: For public distribution

5. Follow prompts and download IPA

### Method 2: Using Command Line Script

```bash
# Make script executable
chmod +x build.sh

# Run build script
./build.sh
```

This will:
- Clean build folder
- Create archive
- Export IPA
- Output: `./build/IPA/HabitTracker.ipa`

### Method 3: Manual Export

```bash
# Create export options
cat > export_options.plist << 'EOF'
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

# Export IPA
xcodebuild -exportArchive \
    -archivePath ./build/HabitTracker.xcarchive \
    -exportOptionsPlist export_options.plist \
    -exportPath ./build/IPA
```

## 🔐 Code Signing

### Automatic Signing (Recommended)

1. Select Project in Xcode
2. Select Target
3. Go to "Signing & Capabilities" tab
4. Enable "Automatically manage signing"
5. Select team (Apple Developer Account)
6. Xcode will handle provisioning profiles

### Manual Signing

1. Go to [Developer.apple.com](https://developer.apple.com)
2. Create App ID
3. Create Provisioning Profile
4. Download and install
5. In Xcode, select profile manually

## 📝 Build Configuration

### Info.plist Settings

Key settings in `HabitTracker/Info.plist`:

```xml
<key>CFBundleIdentifier</key>
<string>com.habittracker.app</string>

<key>CFBundleVersion</key>
<string>1</string>

<key>CFBundleShortVersionString</key>
<string>1.0</string>

<key>LSRequiresIPhoneOS</key>
<true/>

<key>IPHONEOS_DEPLOYMENT_TARGET</key>
<string>17.0</string>
```

### Update Version Numbers

Before building for release:

1. Open `Info.plist`
2. Update:
   - `CFBundleShortVersionString`: User-facing version (1.0, 1.1, etc.)
   - `CFBundleVersion`: Build number (auto-increment)

## ✅ Verification Checklist

Before distributing:

- [ ] App compiles without warnings
- [ ] All tests pass
- [ ] Icons are set in Assets.xcassets
- [ ] LaunchScreen configured
- [ ] Info.plist updated with version
- [ ] Code signing configured
- [ ] Provisioning profile selected
- [ ] App runs on target device
- [ ] All features tested

## 🚀 Distribution Methods

### Ad Hoc Distribution
- For internal testing
- Specific devices only
- No App Store review

### TestFlight
- Beta testing program
- Up to 10,000 testers
- 30-day limit
- Requires App Store Connect

### App Store
- Public distribution
- App Store review required
- Version management
- Automatic updates

### Enterprise Distribution
- Internal company use
- Custom MDM enrollment
- No 1,000 device limit

## 🐛 Troubleshooting

### Build Fails: "No signing identity"
```bash
# Check available certificates
security find-identity -v -p codesigning

# Or use Xcode automatic signing
```

### Archive Not Created
```bash
# Check build settings
xcodebuild -showBuildSettings -scheme HabitTracker

# Verify target SDK
xcode-select --print-path
```

### IPA Won't Install
- Verify Bundle ID matches signing
- Check iOS version compatibility
- Ensure device is in provisioning profile
- Try deleting and reinstalling

### Large IPA File
```bash
# Enable bitcode and optimization
BITCODE_GENERATION_MODE = bitcode
SWIFT_OPTIMIZATION_LEVEL = -O
```

## 📊 Build Performance

### Faster Builds
```bash
# Clean build cache
rm -rf ~/Library/Developer/Xcode/DerivedData

# Use incremental compilation
defaults write com.apple.dt.Xcode IDEIndexDisable 0
```

### Check Build Time
```bash
# Add to scheme
defaults write com.apple.dt.Xcode ShowBuildOperationDuration YES
```

## 📚 Resources

- [Xcode Build System Documentation](https://developer.apple.com/xcode/)
- [App Store Connect Guide](https://help.apple.com/app-store-connect/)
- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [Swift Documentation](https://www.swift.org/documentation/)

## 🎯 Next Steps

1. **Code Sign**: Set up developer account and signing
2. **Test**: Run on simulator and real device
3. **Archive**: Create archive in Xcode
4. **Export**: Generate IPA file
5. **Distribute**: Choose distribution method
6. **Monitor**: Track app performance and feedback

---

**Happy building! 🚀**
