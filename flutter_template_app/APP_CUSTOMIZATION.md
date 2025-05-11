# App Customization Guide

This guide explains how to customize the app's appearance, including the app icon and splash screen.

## App Icon

The app icon is the image that appears on the device's home screen, app drawer, and in the app store.

### Steps to Change the App Icon:

1. Create a square PNG image (recommended size: 1024x1024 pixels)
2. Name it `app_icon.png` and place it in the `assets/icons/` directory
3. Run the following command to generate all necessary icon sizes for different platforms:

```bash
flutter pub run flutter_launcher_icons
```

### Configuration:

The app icon configuration is in the `pubspec.yaml` file under the `flutter_launcher_icons` section. You can customize the following:

- `android`: The name of the Android icon resource
- `ios`: Whether to generate iOS icons
- `image_path`: The path to your icon image
- `min_sdk_android`: The minimum Android SDK version
- Platform-specific configurations for web, Windows, and macOS

## Splash Screen

The splash screen is displayed when the app is starting up.

### Steps to Change the Splash Screen:

1. Create PNG images for both light and dark modes (recommended size: 1080x1080 pixels)
2. Name them `splash.png` (light mode) and `splash_dark.png` (dark mode)
3. Place them in the `assets/images/` directory
4. Run the following command to generate the native splash screens:

```bash
flutter pub run flutter_native_splash:create
```

To remove the generated splash screens:

```bash
flutter pub run flutter_native_splash:remove
```

### Configuration:

The splash screen configuration is in the `pubspec.yaml` file under the `flutter_native_splash` section. You can customize the following:

- `color`: Background color for light mode
- `image`: Image path for light mode
- `color_dark`: Background color for dark mode
- `image_dark`: Image path for dark mode
- `android_12`: Android 12-specific configurations
- `web`: Whether to generate a web splash screen

## Theme Customization

The app's theme (colors, fonts, etc.) can be customized in the `lib/config/theme.dart` file.

## App Name

To change the app name:

1. Android: Edit `android/app/src/main/AndroidManifest.xml` and update the `android:label` attribute
2. iOS: Edit `ios/Runner/Info.plist` and update the `CFBundleName` key
3. Web: Edit `web/index.html` and update the `<title>` tag
4. Windows/macOS/Linux: Update the respective configuration files in their platform directories
