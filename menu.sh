#!/bin/bash

# Function to clean and fetch dependencies
clean_flutter() {
    echo -e "\033[34m🔄 Cleaning Flutter project...\033[0m"
    flutter clean
    rm -f pubspec.lock
    rm -rf .dart_tool build
    flutter pub get
    echo -e "\033[32m✅\033[35m Flutter cleanup and dependency fetch complete.\033[0m"
}

# Function to build Android APK
build_apk() {
    echo -e "\033[34m📦 Building Android APK...\033[0m"
    flutter build apk --split-per-abi
    echo -e "\033[32m✅\033[35m Android APK build complete.\033[0m"
}

# Function to build Tizen TPK
build_tpk() {
    echo -e "\033[34m📦 Building Tizen TPK...\033[0m"
    flutter-tizen build tpk
    echo -e "\033[32m✅\033[35m Tizen TPK build complete.\033[0m"
}

# Main menu loop
while true; do
    echo ""
    echo -e "\033[36mWelcome to the Build Menu. You can do the following:\033[0m"
    echo -e "\033[35m    1\033[0m: Clean up Flutter App and download dependencies"
    echo -e "\033[35m    2\033[0m: Build Android APK"
    echo -e "\033[35m    3\033[0m: Build Tizen TPK"
    echo -e "\033[35m    x\033[0m: Exit"
    echo -e -n "\033[36mPlease select an option: \033[35m"
    read -r choice

    case "$choice" in
        1)
            clean_flutter
            ;;
        2)
            build_apk
            ;;
        3)
            build_tpk
            ;;
        x)
            echo -e "\033[33m👋 Exiting. Goodbye!\033[0m"
            break
            ;;
        *)
            echo -e "\033[31m❌ That is not a valid selection.\033[0m"
            ;;
    esac
done
