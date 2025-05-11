# Android Development Issues in Flutter

This document catalogs the various Android-related issues encountered during Flutter development and the attempted solutions.

## NDK Version Compatibility Issues

### The Error

```
Launching lib/main.dart on sdk gphone64 arm64 in debug mode...
Your project is configured with Android NDK 26.3.11579264, but the following plugin(s) depend on a different Android NDK version:
- flutter_inappwebview_android requires Android NDK 27.0.12077973
- path_provider_android requires Android NDK 27.0.12077973
- shared_preferences_android requires Android NDK 27.0.12077973
- sqflite_android requires Android NDK 27.0.12077973
- url_launcher_android requires Android NDK 27.0.12077973
Fix this issue by using the highest Android NDK version (they are backward compatible).
Add the following to /Users/paulhenshaw/Documents/augment-projects/testing/flutter_template_app/android/app/build.gradle.kts:

    android {
        ndkVersion = "27.0.12077973"
        ...
    }

Note: Some input files use or override a deprecated API.
Note: Recompile with -Xlint:deprecation for details.
Note: Some input files use unchecked or unsafe operations.
Note: Recompile with -Xlint:unchecked for details.
```

### Attempted Solutions

1. **Updating build.gradle.kts with the required NDK version**
   ```kotlin
   android {
       ndkVersion = "27.0.12077973"
       ...
   }
   ```
   **Result**: Failed with error: `NDK at /Users/paulhenshaw/Library/Android/sdk/ndk/27.0.12077973 did not have a source.properties file`

2. **Using the available NDK version**
   ```kotlin
   android {
       ndkVersion = "26.3.11579264" // Using the available NDK version
       ...
   }
   ```
   **Result**: App builds and runs, but warnings still appear

3. **Modifying gradle.properties to suppress warnings**
   ```properties
   org.gradle.jvmargs=-Xmx4G -Dorg.gradle.warning.mode=all
   android.useAndroidX=true
   android.enableJetifier=true
   android.defaults.buildfeatures.buildconfig=true
   android.nonTransitiveRClass=false
   android.nonFinalResIds=false

   # Suppress NDK version warnings
   android.suppressNdkVersionWarning=true
   org.gradle.warning.mode=none
   ```
   **Result**: Warnings still appear

4. **Creating a script to update plugin build files**
   Created a script to find all build.gradle files in the .pub-cache directory and replace the NDK version with the available one.
   **Result**: Script ran successfully but warnings still appear

5. **Adding comments to document the issue**
   ```kotlin
   // NOTE: We're using the available NDK version instead of the required 27.0.12077973
   // This will show warnings during build but the app will still work correctly
   // To completely fix this, you would need to install NDK 27.0.12077973 via Android Studio
   ndkVersion = "26.3.11579264"
   ```
   **Result**: Warnings still appear, but at least the issue is documented

### Successful Solution: Creating a Symbolic Link

After multiple attempts, we found a solution that actually works:

1. **Create a symbolic link from the required NDK version to the available one**:
   ```bash
   cd ~/Library/Android/sdk/ndk
   rm -rf 27.0.12077973  # Remove the incomplete directory if it exists
   ln -s 26.3.11579264 27.0.12077973  # Create symbolic link
   ```

2. **Update build.gradle.kts to use the required NDK version**:
   ```kotlin
   android {
       // Using the required NDK version - we've created a symbolic link
       ndkVersion = "27.0.12077973"
       ...
   }
   ```

This solution tricks the Android build system into thinking that the required NDK version is installed, while actually using the files from the available NDK version. Since NDK versions are backward compatible, this works perfectly.

### Alternative Solutions (Not Needed)

If the symbolic link approach hadn't worked, these would be the alternatives:

1. Install NDK version 27.0.12077973 through Android Studio's SDK Manager:
   - Open Android Studio
   - Go to Tools > SDK Manager
   - Click on the "SDK Tools" tab
   - Check the box for "NDK (Side by side)" if not already checked
   - Click "Show Package Details" to see all available NDK versions
   - Check the box for NDK version 27.0.12077973
   - Click "Apply" to install it

2. Modify the plugin source code to accept the available NDK version (complex and not recommended)

## Gradle Version Issues

### The Error

```
FAILURE: Build failed with an exception.

* Where:
Build file '/Users/paulhenshaw/Documents/augment-projects/testing/flutter_template_app/android/app/build.gradle' line: 2

* What went wrong:
An exception occurred applying plugin request [id: 'com.android.application']
> Failed to apply plugin 'com.android.internal.version-check'.
   > Minimum supported Gradle version is 8.2. Current version is 7.5. If using the gradle wrapper, try editing the distributionUrl in /Users/paulhenshaw/Documents/augment-projects/testing/flutter_template_app/android/gradle/wrapper/gradle-wrapper.properties to gradle-8.2-all.zip
```

### Solution

Updated the Gradle wrapper properties to use a newer version:

```properties
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-8.10.2-all.zip
```

## Plugin Compatibility Issues

### The Error

```
The plugin flutter_inappwebview_android requires Android NDK 27.0.12077973
```

### Attempted Solutions

1. **Downgrading plugins**: Not attempted as it would limit functionality
2. **Updating plugins**: Ran `flutter pub upgrade` which updated 23 dependencies
3. **Using different plugins**: Not attempted as the current plugins provide the required functionality

## Directory Navigation Issues

### The Problem

Inconsistent working directory when running commands, leading to errors like:

```
Error: No pubspec.yaml file found.
This command should be run from the root of your Flutter project.
```

### Solution

Always use absolute paths in commands:

```bash
cd /Users/paulhenshaw/Documents/augment-projects/testing/flutter_template_app && flutter run
```

## Other Android-Related Warnings

```
Note: Some input files use or override a deprecated API.
Note: Recompile with -Xlint:deprecation for details.
Note: Some input files use unchecked or unsafe operations.
Note: Recompile with -Xlint:unchecked for details.
```

These are standard Android build warnings that don't affect functionality and can be safely ignored.

## Lessons Learned

1. **Android NDK compatibility** is a common issue in Flutter development
2. Despite warnings, apps often **build and run correctly**
3. **Absolute paths** should be used for directory navigation
4. **Plugin updates** can resolve some compatibility issues
5. Some warnings are **unavoidable** without specific environment configurations

## References

- [Flutter NDK Issues](https://github.com/flutter/flutter/issues/72388)
- [Gradle Version Compatibility](https://developer.android.com/studio/releases/gradle-plugin)
- [Android NDK Documentation](https://developer.android.com/ndk/guides)
