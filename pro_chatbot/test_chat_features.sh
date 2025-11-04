#!/bin/bash

# Test script for Chat Page features on all platforms
# Usage: ./test_chat_features.sh [platform]
# Available platforms: android, ios, macos, chrome, all

set -e

echo "🧪 Chat Page Features Test Script"
echo "=================================="
echo ""

# Terminal colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to display a success message
success() {
    echo -e "${GREEN}✓${NC} $1"
}

# Function to display a warning
warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Function to display an error
error() {
    echo -e "${RED}✗${NC} $1"
}

# Check that we are in the correct directory
if [ ! -f "pubspec.yaml" ]; then
    error "Error: This script must be run from the Flutter project root directory"
    exit 1
fi

# Function to test a platform
test_platform() {
    local platform=$1
    echo ""
    echo "📱 Testing on $platform..."
    echo "------------------------"
    
    # Check if platform is available
    if ! flutter devices | grep -i "$platform" > /dev/null; then
        warning "No $platform device detected. Skipping..."
        return
    fi
    
    # Launch the app
    echo "Launching application..."
    flutter run -d "$platform" lib/chat/chat_page.dart &
    local pid=$!
    
    echo ""
    echo "✅ Application launched on $platform"
    echo ""
    echo "🧪 Manual tests to perform:"
    echo "  1. File Picker - Select a file"
    echo "  2. Gallery - Select an image"
    echo "  3. Camera - Take a photo"
    echo "  4. Microphone - Voice recognition test"
    echo ""
    echo "Press Ctrl+C to stop and move to next test..."
    
    # Wait for user to stop the app
    wait $pid 2>/dev/null || true
}

# Function to list available devices
list_devices() {
    echo "📱 Available devices:"
    flutter devices
    echo ""
}

# Clean and prepare
echo "🧹 Cleaning and preparing..."
flutter clean > /dev/null 2>&1
flutter pub get > /dev/null 2>&1
success "Project cleaned and dependencies installed"

# List devices
list_devices

# Determine which platforms to test
PLATFORM=${1:-"all"}

case $PLATFORM in
    android)
        test_platform "android"
        ;;
    ios)
        test_platform "iphone"
        ;;
    macos)
        test_platform "macos"
        ;;
    chrome)
        test_platform "chrome"
        ;;
    all)
        echo "🎯 Testing on all available platforms"
        
        # Android
        if flutter devices | grep -i "android" > /dev/null; then
            test_platform "android"
        fi
        
        # iOS
        if flutter devices | grep -i "iphone\|ios" > /dev/null; then
            test_platform "iphone"
        fi
        
        # macOS
        if flutter devices | grep -i "macos" > /dev/null; then
            test_platform "macos"
        fi
        
        # Chrome
        if flutter devices | grep -i "chrome" > /dev/null; then
            test_platform "chrome"
        fi
        ;;
    *)
        error "Unrecognized platform: $PLATFORM"
        echo "Available platforms: android, ios, macos, chrome, all"
        exit 1
        ;;
esac

echo ""
echo "=================================="
success "Tests completed!"
echo ""
echo "📊 Feature summary by platform:"
echo ""
echo "| Feature           | Android | iOS | macOS | Chrome OS |"
echo "|-------------------|---------|-----|-------|-----------|"
echo "| File Picker       |   ✅    | ✅  |  ✅   |    ✅     |"
echo "| Gallery           |   ✅    | ✅  |  ✅   |    ✅     |"
echo "| Camera            |   ✅    | ✅  |  ❌   |    ✅     |"
echo "| Speech-to-Text    |   ✅    | ✅  |  ✅   |    ⚠️     |"
echo ""
echo "Legend:"
echo "  ✅ Fully supported"
echo "  ⚠️  Limited support"
echo "  ❌ Not supported"
echo ""
echo "For more details, see PLATFORM_COMPATIBILITY.md"
