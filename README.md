## Digital Pet App

This Flutter app is an in-class assignment demonstrating **state management** with a simple digital pet game.  
The pet has changing **happiness**, **hunger**, and **energy** levels, which react to user actions over time.

### Features

- **Play and Feed** buttons that update the pet’s state using `setState`.
- **Dynamic mood color** using `ColorFiltered` (green, yellow, red based on happiness).
- **Mood text and emoji** (Happy / Neutral / Unhappy).
- **Custom pet name** via a text field.
- **Auto-increasing hunger** with a `Timer` from `dart:async`.
- **Win condition**: Happiness > 80 for 3 minutes shows a “You Won!” dialog.
- **Loss condition**: Hunger ≥ 100 and Happiness ≤ 10 shows a “Game Over” dialog.
- **Energy bar** displayed with a `LinearProgressIndicator`.

### How to Run

1. Install Flutter and set up an emulator or connect a device.
2. From the project root:

   ```bash
   flutter pub get
   flutter run
   ```

3. To build a release APK for submission:

   ```bash
   flutter build apk
   ```

   The APK will be in `build/app/outputs/flutter-apk/app-release.apk`.

### Git Commit Screenshot

Include a screenshot of your commit history here for the assignment.  
Example (replace with your actual image or link):

`![Git commit history](path/to/your_git_commits_screenshot.png)`

