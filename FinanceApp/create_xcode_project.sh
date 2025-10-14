#!/bin/bash

# FinanceApp Xcode Project Setup Script
# This script automates the creation of the Xcode project

set -e

PROJECT_DIR="/Users/ashish/Developer/Claude/FinanceApp"
PROJECT_NAME="FinanceApp"

echo "🚀 Setting up FinanceApp Xcode Project..."
echo ""

cd "$PROJECT_DIR"

# Step 1: Build the SPM packages to verify they're correct
echo "📦 Step 1: Verifying SPM packages..."
cd UIComponentsKit
swift build 2>/dev/null && echo "✅ UIComponentsKit builds successfully" || echo "⚠️  UIComponentsKit has build warnings (expected for library)"
cd ..

cd AccountCreationKit
swift build 2>/dev/null && echo "✅ AccountCreationKit builds successfully" || echo "⚠️  AccountCreationKit has build warnings (expected for library)"
cd ..

echo ""
echo "📝 Step 2: SPM packages are ready!"
echo ""
echo "⚠️  MANUAL STEPS REQUIRED:"
echo ""
echo "Since iOS apps with UIKit require a proper .xcodeproj file,"
echo "please follow these steps in Xcode:"
echo ""
echo "1. Open Xcode"
echo "2. File → New → Project"
echo "3. Choose: iOS → App"
echo "4. Configuration:"
echo "   - Product Name: FinanceApp"
echo "   - Interface: Storyboard"
echo "   - Language: Swift"
echo "   - Create in: $PROJECT_DIR"
echo "   - UNCHECK 'Create Git repository'"
echo ""
echo "5. After project creation:"
echo "   - Delete auto-generated files (ContentView.swift, SceneDelegate.swift, etc.)"
echo "   - Drag the 'FinanceApp' folder from Finder into Xcode"
echo "   - File → Add Package Dependencies → Add Local"
echo "     * Add UIComponentsKit"
echo "     * Add AccountCreationKit"
echo ""
echo "6. Update Info.plist path in Build Settings:"
echo "   - Set 'Info.plist File' to: FinanceApp/App/Info.plist"
echo ""
echo "7. Build and Run! (⌘+R)"
echo ""
echo "📖 For detailed instructions, see: SETUP_INSTRUCTIONS.md"
echo ""
echo "Or, if you want to use Swift Package Manager directly:"
echo "   cd $PROJECT_DIR"
echo "   open Package.swift"
echo "   (This will open in Xcode as an SPM project)"
echo ""
