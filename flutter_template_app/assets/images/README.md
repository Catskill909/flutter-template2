# Splash Screen Images

Place your splash screen images in this directory:

- `splash.png` - For light mode
- `splash_dark.png` - For dark mode

## Requirements

- PNG format is recommended
- Recommended size: 1080x1080 pixels (square)
- Keep the image simple and centered
- For best results, use a transparent background
- The image should be visually appealing on both light and dark backgrounds

## Usage

Once you've placed your splash screen images in this directory, you can generate the native splash screens by running:

```bash
flutter pub run flutter_native_splash:create
```

This will generate splash screens for Android and iOS based on the configuration in `pubspec.yaml`.

To remove the generated splash screens:

```bash
flutter pub run flutter_native_splash:remove
```
