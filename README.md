# Appointment Scheduler SDK Flutter - SPM Package

A Swift Package Manager (SPM) package containing the Appointment Scheduler Flutter SDK for iOS integration.

## 📦 Installation

### Using Xcode

1. **Open your iOS project in Xcode**
2. **Go to**: `File` → `Add Package Dependencies...`
3. **Enter the repository URL**:
   ```
   https://github.com/eramitkumarsoni/AppointmentSchedulerSDKFlutter.git
   ```
4. **Select version**: `1.3.0` (or `main` branch for latest)
5. **Click**: `Add Package`

### Using Package.swift

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/eramitkumarsoni/AppointmentSchedulerSDKFlutter.git", from: "1.4.0")
]
```

Then add it to your target dependencies:

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "AppointmentSchedulerSDKFlutter", package: "AppointmentSchedulerSDKFlutter")
        ]
    )
]
```

## 🚀 Quick Start

### 1. Import the SDK

```swift
import AppointmentSchedulerSDKFlutter
```

### 2. Initialize in AppDelegate

```swift
import UIKit
import AppointmentSchedulerSDKFlutter

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Initialize the Appointment Scheduler SDK
        AppointmentSchedulerSDK.shared.initialize()
        return true
    }
}
```

### 3. Show the Appointment Scheduler

```swift
import UIKit
import AppointmentSchedulerSDKFlutter

class ViewController: UIViewController {
    
    @IBAction func showSchedulerTapped(_ sender: UIButton) {
        // Create a Flutter view controller
        let flutterVC = AppointmentSchedulerSDK.shared.createViewController()
        
        // Present it modally
        flutterVC.modalPresentationStyle = .fullScreen
        present(flutterVC, animated: true)
        
        // Or push it in a navigation stack
        // navigationController?.pushViewController(flutterVC, animated: true)
    }
}
```

## 🎯 Advanced Usage

### Custom Initial Route

```swift
let flutterVC = AppointmentSchedulerSDK.shared.createViewController(withRoute: "/custom-route")
present(flutterVC, animated: true)
```

### Multiple Engine Management

For advanced use cases where you need multiple Flutter engines:

```swift
import AppointmentSchedulerSDKFlutter

// Create a named engine
let engine = FlutterEngineManager.shared.createEngine(named: "appointmentEngine")

// Get an existing engine
if let existingEngine = FlutterEngineManager.shared.getEngine(named: "appointmentEngine") {
    // Use the engine
}

// Clean up when done
FlutterEngineManager.shared.removeEngine(named: "appointmentEngine")
```

## 📋 Requirements

- **iOS**: 13.0+
- **Swift**: 5.9+
- **Xcode**: 15.0+

## 🔥 Firebase Integration

This SDK includes Firebase Core support. Make sure to:

1. Add your `GoogleService-Info.plist` to your iOS project
2. Configure Firebase in your AppDelegate if needed

```swift
import Firebase

func application(_ application: UIApplication, 
                didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Initialize Firebase (if needed for your app)
    FirebaseApp.configure()
    
    // Initialize Appointment Scheduler SDK
    AppointmentSchedulerSDK.shared.initialize()
    
    return true
}
```

## 📚 What's Included

This package includes the following frameworks:

### Core Frameworks
- **App.xcframework** - Flutter App code
- **Flutter.xcframework** - Flutter engine
- **firebase_core** - Firebase Core plugin
- **FirebaseCore** - Firebase Core SDK
- **FirebaseCoreInternal** - Firebase internal components
- **GoogleUtilities** - Google utilities

### Plugin Frameworks
- **audio_session** - Audio session management
- **connectivity_plus** - Network connectivity
- **file_picker** - File selection
- **file_selector_ios** - iOS file selector
- **flutter_secure_storage** - Secure storage
- **get_thumbnail_video** - Video thumbnails
- **image_gallery_saver_plus** - Save images to gallery
- **image_picker_ios** - Image picker
- **just_audio** - Audio playback
- **media_kit_video** - Video player
- **package_info_plus** - Package information
- **path_provider_foundation** - Path utilities
- **photo_manager** - Photo library management
- **share_plus** - Share functionality
- **sqflite_darwin** - SQLite database
- **url_launcher_ios** - URL launching
- **video_player_avfoundation** - Video playback
- **volume_controller** - Volume control
- **wakelock_plus** - Screen wakelock

### UI Frameworks
- **DKImagePickerController** - Image picker UI
- **DKPhotoGallery** - Photo gallery UI
- **SDWebImage** - Image loading and caching
- **SwiftyGif** - GIF support
- **libwebp** - WebP image format

## 🔖 Version History

### v1.3.0 (Latest)
- ✅ Updated frameworks with latest Flutter code
- ✅ Added Firebase support (FirebaseCore, FirebaseCoreInternal, GoogleUtilities)
- ✅ UI improvements and bug fixes
- ✅ Removed debug symbols to reduce package size

### v1.2.0
- ✅ Renamed components to match repository name
- ✅ Improved package structure

### v1.1.1
- ✅ Fixed package naming issues

### v1.1.0
- ✅ Removed duplicate Firebase dependencies

### v1.0.0
- ✅ Initial release

## 🐛 Troubleshooting

### Build Issues

If you encounter build issues:

1. **Clean build folder**: `⌘ + Shift + K`
2. **Delete derived data**
3. **Reset package caches**: `File` → `Packages` → `Reset Package Caches`
4. **Update packages**: `File` → `Packages` → `Update to Latest Package Versions`

### Firebase Conflicts

If you have conflicts with Firebase:

- This package includes Firebase Core internally
- Make sure you're not including conflicting Firebase versions in your main app
- Use the same Firebase version across your app and this SDK

## 📖 Documentation

For more detailed documentation, visit the [main repository](https://github.com/eramitkumarsoni/AppointmentSchedulerSDKFlutter).

## 📄 License

See the LICENSE file in the repository for details.

## 👥 Support

For issues, questions, or contributions, please visit the [GitHub repository](https://github.com/eramitkumarsoni/AppointmentSchedulerSDKFlutter).

---

**Made with ❤️ using Flutter and Swift**
