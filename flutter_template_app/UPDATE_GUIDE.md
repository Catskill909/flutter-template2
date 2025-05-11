# Dove Trail App Update Guide

This guide provides step-by-step instructions for updating the Dove Trail Flutter app to resolve the current dependency and version compatibility issues.

## Current Issues

The app is currently experiencing the following issues:

1. Unsupported Kotlin plugin version (1.7.10)
2. Android SDK version requirement (requires SDK 35)
3. Plugin compatibility issues with shared_preferences and url_launcher

## Step-by-Step Update Process

### Step 1: Update Flutter SDK

First, ensure you have the latest Flutter SDK:

```bash
flutter upgrade
```

### Step 2: Update Kotlin Version

Edit the `android/build.gradle` file:

```bash
# Open the file
nano android/build.gradle

# Update the Kotlin version from 1.7.10 to 1.8.10
# Change this line:
ext.kotlin_version = '1.7.10'
# To:
ext.kotlin_version = '1.8.10'

# Save the file
```

### Step 3: Update Android SDK Version

Edit the `android/app/build.gradle` file:

```bash
# Open the file
nano android/app/build.gradle

# Update the compileSdkVersion from 33 to 35
# Change this line:
compileSdkVersion 33
# To:
compileSdkVersion 35

# Update the targetSdkVersion from 33 to 35
# Change this line:
targetSdkVersion 33
# To:
targetSdkVersion 35

# Save the file
```

### Step 4: Add Suppression for Unsupported CompileSdk

Edit the `android/gradle.properties` file:

```bash
# Open the file
nano android/gradle.properties

# Add this line at the end of the file:
android.suppressUnsupportedCompileSdk=35

# Save the file
```

### Step 5: Update Dependencies in pubspec.yaml

Edit the `pubspec.yaml` file:

```bash
# Open the file
nano pubspec.yaml

# Update the dependencies section to use the latest versions:
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0
  url_launcher: ^6.1.14
  xml: ^6.3.0
  html: ^0.15.4
  flutter_riverpod: ^2.4.0
  pull_to_refresh: ^2.0.0
  shared_preferences: ^2.2.0

# Update the environment section:
environment:
  sdk: ">=3.0.0 <4.0.0"
  flutter: ">=3.10.0"

# Save the file
```

### Step 6: Clean and Get Dependencies

```bash
# Clean the project
flutter clean

# Get dependencies
flutter pub get
```

### Step 7: Update Gradle Version (if needed)

If you're still experiencing Gradle-related issues, update the Gradle version:

```bash
# Open the file
nano android/gradle/wrapper/gradle-wrapper.properties

# Update the distributionUrl to use Gradle 7.5
# Change this line:
distributionUrl=https\://services.gradle.org/distributions/gradle-7.4-all.zip
# To:
distributionUrl=https\://services.gradle.org/distributions/gradle-7.5-all.zip

# Save the file
```

### Step 8: Fix Plugin-specific Issues

If you're still having issues with specific plugins:

```bash
# For shared_preferences:
flutter pub remove shared_preferences
flutter pub get
flutter pub add shared_preferences

# For url_launcher:
flutter pub remove url_launcher
flutter pub get
flutter pub add url_launcher
```

### Step 9: Test the App

Run the app to ensure all issues are resolved:

```bash
flutter run -d chrome
```

## Troubleshooting Common Issues

### Issue: "Execution failed for task ':app:compileDebugKotlin'"

**Solution:**
This is often related to Kotlin version incompatibility. Make sure you've updated both:
- The Kotlin version in `android/build.gradle`
- The Kotlin Gradle plugin version in the same file

### Issue: "Plugin requires a higher Flutter SDK version"

**Solution:**
Update your Flutter SDK to the latest version:
```bash
flutter upgrade
```

### Issue: "Gradle build fails with compileSdk 35"

**Solution:**
Make sure you've added the suppression line to `android/gradle.properties`:
```
android.suppressUnsupportedCompileSdk=35
```

### Issue: "Cannot find symbol class Registrar"

**Solution:**
This is typically related to outdated plugin implementations. Try:
1. Updating the plugin to the latest version
2. Removing and re-adding the plugin
3. Checking if the plugin has migration instructions for newer Flutter versions

## Verifying the Update

After completing all steps, verify that:

1. The app builds successfully
2. The app runs without errors
3. All features work as expected
4. No warning messages appear in the console related to dependencies or versions

## Future-proofing

To avoid similar issues in the future:

1. **Regular Updates**: Schedule regular dependency updates (monthly or quarterly)
2. **Version Pinning**: Consider pinning critical dependencies to specific versions
3. **CI/CD Testing**: Set up CI/CD to test with the latest dependencies
4. **Dependency Dashboard**: Use a dependency dashboard to track outdated packages

By following this guide, you should be able to resolve the current dependency and version compatibility issues in the Dove Trail Flutter app.
