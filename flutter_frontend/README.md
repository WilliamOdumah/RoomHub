# RoomHub: flutter_frontend

## Getting Started
Clone the Repository
```
git clone <repo-url>
```
After cloning, they should navigate to the project's root directory:
```
cd flutter_frontend
```
## Prerequisites for running the android version
1. **Android Studio** installed with Flutter and Dart plugins.
2. **Flutter SDK** installed.
3. **APK** file built and ready.

### Instructions:
#### 1. **Launch Android Studio**:
   - Open Android Studio on your computer.
#### 2. **Start Android Emulator**:
   - On the top right of Android Studio, click the **Device Manager** icon (a phone-shaped icon).
   - Select or create an Android Virtual Device (AVD) to simulate a phone. Once ready, click **Run** (green play button) to start the emulator.
#### 3. **Access the Android Emulator**:
   - Once the emulator starts, it will display a virtual Android device.
   - Keep this emulator open while you run the APK.
#### 4. **Locate the APK file**
     ```
    RoomHub/flutter_frontend/flutter-apk.zip
     ```
#### 5. **Install APK on the Emulator**:
   Unzip and you can install the APK using two methods:
   ##### Method 1: Drag-and-Drop APK
   - Drag the APK file from your computer and drop it onto the emulator screen. The APK will automatically install and launch.
#### 6. **Launch the App**:
   - Once the APK is installed, you should see the flutter icon on the emulator’s home screen.
   - Tap the icon to launch your Flutter app.


## Prerequisites for running the ios version

Step 1: Install Xcode

Open the App Store on your Mac.
Search for Xcode and click Get to download it.
Install Xcode by following the on-screen instructions.
Open Xcode after installation to complete the setup.
Step 2: Install Xcode Command-Line Tools

Open Terminal (found in Applications > Utilities).
Run the following command to set the Xcode developer directory:
bash
Copy code
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
Accept the Xcode License Agreement:
You can do this by opening Xcode, which will prompt you to accept the agreement, or by running the following command in Terminal:
bash
Copy code
sudo xcodebuild -license accept
Step 3: Install Homebrew

In the Terminal, run the following command to install Homebrew:
bash
Copy code
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
Follow the on-screen instructions. You may need to enter your password.
Step 4: Install CocoaPods

After installing Homebrew, install CocoaPods by running:
bash
Copy code
brew install cocoapods
Step 5: Install Flutter

If you haven’t installed Flutter yet, download the Flutter SDK from the Flutter official website.
Extract the downloaded archive to a desired location (e.g., ~/flutter).
Add Flutter to your PATH by adding the following line to your .bash_profile, .zshrc, or .bashrc file (depending on your shell):
bash
Copy code
export PATH="$PATH:`pwd`/flutter/bin"
Run the following command to apply the changes:
bash
Copy code
source ~/.bash_profile   # or source ~/.zshrc
Step 6: Verify Flutter Installation

Run flutter doctor in the Terminal to check if Flutter is set up correctly:
bash
Copy code
flutter doctor
Follow any prompts to install missing dependencies or resolve issues.



 
Finally run in your vscode terminal:
```
flutter run
```



