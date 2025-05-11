# App Icon

Place your app icon file named `app_icon.png` in this directory.

## Requirements

- The app icon should be a PNG file
- Recommended size: 1024x1024 pixels
- The image should be square
- For best results, ensure the important content is within a safe area (about 80% of the image)
- Transparent background is supported

## Usage

Once you've placed your `app_icon.png` file in this directory, you can generate all the necessary app icons for different platforms by running:

```bash
flutter pub run flutter_launcher_icons
```

This will generate icons for Android, iOS, web, Windows, and macOS based on the configuration in `pubspec.yaml`.
