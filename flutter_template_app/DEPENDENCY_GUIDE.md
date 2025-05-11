# Flutter Dependency and Version Guide

This guide addresses common dependency and version compatibility issues in the Flutter Dove Trail app and provides solutions to resolve them.

## Common Issues and Solutions

### 1. Unsupported Kotlin Plugin Version

**Issue:**
```
Unsupported Kotlin plugin version.
Flutter support for your project's Kotlin version (1.7.10) will soon be dropped. 
Please upgrade your Kotlin version to a version of at least 1.8.10 soon.
```

**Solution:**

Update the Kotlin version in your `android/build.gradle` file:

```gradle
buildscript {
    ext.kotlin_version = '1.8.10' // Update this line
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:7.3.0'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
}
```

### 2. Android SDK Version Requirement

**Issue:**
```
The plugin path_provider_android requires Android SDK version 35 or higher.
We recommend using a newer Android Gradle plugin to use compileSdk = 35
```

**Solution:**

Update the `compileSdkVersion` in your `android/app/build.gradle` file:

```gradle
android {
    compileSdkVersion 35 // Update this line
    
    // ...
    
    defaultConfig {
        // ...
        minSdkVersion 21 // Ensure this is set to at least 21
        targetSdkVersion 35 // Update this line
        // ...
    }
}
```

If you're still getting warnings about the Android Gradle plugin, add the following to your `android/gradle.properties` file:

```
android.suppressUnsupportedCompileSdk=35
```

### 3. Plugin Compatibility Issues

**Issue:**
```
SharedPreferencesPlugin.java cannot find symbol class Registrar
url_launcher_android:compileDebugJavaWithJavac
```

**Solution:**

Update your plugin dependencies in `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.0
  url_launcher: ^6.1.14
  # Other dependencies...
```

Then run:

```bash
flutter pub get
flutter clean
flutter pub get
```

## Comprehensive Dependency Update Guide

To ensure all dependencies are up-to-date and compatible, follow these steps:

### 1. Update Flutter SDK

First, update your Flutter SDK to the latest stable version:

```bash
flutter upgrade
```

### 2. Update pubspec.yaml

Update your dependencies in `pubspec.yaml` to the latest compatible versions:

```yaml
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
```

### 3. Update Android Configuration

Update the following files:

**android/build.gradle**:
```gradle
buildscript {
    ext.kotlin_version = '1.8.10'
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:7.3.0'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
}
```

**android/app/build.gradle**:
```gradle
android {
    compileSdkVersion 35
    
    // ...
    
    defaultConfig {
        // ...
        minSdkVersion 21
        targetSdkVersion 35
        // ...
    }
}
```

**android/gradle.properties**:
```
android.suppressUnsupportedCompileSdk=35
```

### 4. Clean and Rebuild

Clean your project and get dependencies again:

```bash
flutter clean
flutter pub get
```

### 5. Resolve Plugin-specific Issues

If you're still encountering issues with specific plugins, try the following:

#### For shared_preferences:

```bash
flutter pub remove shared_preferences
flutter pub get
flutter pub add shared_preferences
```

#### For url_launcher:

```bash
flutter pub remove url_launcher
flutter pub get
flutter pub add url_launcher
```

### 6. Check for Conflicting Dependencies

Run the following command to check for conflicting dependencies:

```bash
flutter pub deps
```

Look for any conflicts or version constraints that might be causing issues.

## Troubleshooting

### Issue: Plugin Requires a Higher Flutter SDK Version

**Solution:**
Update your Flutter SDK version constraint in `pubspec.yaml`:

```yaml
environment:
  sdk: ">=3.0.0 <4.0.0"
  flutter: ">=3.10.0"
```

### Issue: Gradle Build Failures

**Solution:**
Try updating your Gradle version in `android/gradle/wrapper/gradle-wrapper.properties`:

```
distributionUrl=https\://services.gradle.org/distributions/gradle-7.5-all.zip
```

### Issue: Incompatible Plugin Versions

**Solution:**
Check the compatibility matrix for Flutter plugins at [pub.dev](https://pub.dev) and ensure you're using compatible versions.

## Best Practices for Dependency Management

1. **Regular Updates**: Regularly update your dependencies to stay current with security patches and new features.

2. **Version Constraints**: Use caret (^) version constraints to allow compatible updates.

3. **Dependency Locking**: Consider using a dependency locking mechanism for production builds.

4. **Testing After Updates**: Always test your app thoroughly after updating dependencies.

5. **Gradual Updates**: Update dependencies one at a time to isolate issues.

By following this guide, you should be able to resolve common dependency and version compatibility issues in your Flutter project.
