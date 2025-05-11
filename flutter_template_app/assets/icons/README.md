# App Icon

Place your app icon file named `app_icon.png` in this directory.

## Requirements

- The app icon should be a PNG file
- Recommended size: 1024x1024 pixels
- The image should be square
- For best results, ensure the important content is within a safe area (about 80% of the image)
- Transparent background is supported

## Note on Article Images

For article images in the app:
- Use landscape images with a 16:9 aspect ratio (e.g., 1920x1080 pixels)
- Images will be displayed in a grid layout on tablet and desktop devices
- High-quality images with good contrast work best with the text overlay

## Usage

Once you've placed your `app_icon.png` file in this directory, you can generate all the necessary app icons for different platforms by running:

```bash
flutter pub run flutter_launcher_icons
```

This will generate icons for Android, iOS, web, Windows, and macOS based on the configuration in `pubspec.yaml`.
