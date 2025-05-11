#!/bin/bash

# Script to fix NDK version warnings in Flutter plugins
# This script will find all build.gradle files in the .pub-cache directory
# and replace the NDK version with the one available on the system

# The NDK version available on the system
AVAILABLE_NDK="26.3.11579264"

# The NDK version required by the plugins
REQUIRED_NDK="27.0.12077973"

# Find all build.gradle files in the Flutter plugins directory
find ~/.pub-cache -name "build.gradle" -o -name "build.gradle.kts" | while read -r file; do
    echo "Checking $file"
    
    # Check if the file contains the required NDK version
    if grep -q "$REQUIRED_NDK" "$file"; then
        echo "Fixing NDK version in $file"
        
        # Replace the required NDK version with the available one
        sed -i '' "s/$REQUIRED_NDK/$AVAILABLE_NDK/g" "$file"
        
        echo "Fixed $file"
    fi
done

echo "Done fixing NDK version warnings"
