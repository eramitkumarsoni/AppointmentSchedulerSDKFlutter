# Appointment Scheduler SDK - Swift Package

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2013.0+-blue.svg)](https://developer.apple.com/ios/)
[![SPM](https://img.shields.io/badge/SPM-Compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A Swift Package Manager (SPM) package that wraps the Flutter-based Appointment Scheduler SDK for easy integration into native iOS applications.

## 📱 Features

- ✅ **Easy Integration** - Add to your project in just 3 steps
- ✅ **Complete Package** - All 31 dependencies included
- ✅ **UIKit & SwiftUI** - Works with both frameworks
- ✅ **Flexible Presentation** - Push, modal, or embedded
- ✅ **Custom Routes** - Navigate to specific screens
- ✅ **Production Ready** - Tested and optimized

## 📦 What's Included

This package includes:
- **Flutter Engine** - Core Flutter runtime
- **Appointment Scheduler App** - Complete Flutter application
- **31 Plugin Frameworks** - All necessary dependencies
- **Swift Wrapper** - Easy-to-use Swift API

### Framework List
- Core: Flutter, App, FlutterPluginRegistrant
- Firebase: FirebaseCore, FirebaseCoreInternal, firebase_core
- Media: DKImagePickerController, DKPhotoGallery, SDWebImage, SwiftyGif, libwebp, image_picker_ios, image_gallery_saver_plus, photo_manager
- Audio/Video: audio_session, just_audio, media_kit_video, video_player_avfoundation, volume_controller
- Storage: file_picker, file_selector_ios, flutter_secure_storage, path_provider_foundation, sqflite_darwin
- Utilities: connectivity_plus, get_thumbnail_video, package_info_plus, share_plus, url_launcher_ios, wakelock_plus, GoogleUtilities

## 🚀 Installation

### Requirements
- iOS 13.0+
- Xcode 15.0+
- Swift 5.9+

### Swift Package Manager

#### Option 1: Xcode (Recommended)

1. In Xcode, go to **File → Add Packages**
2. Enter the repository URL:
   ```
   https://github.com/eramitkumarsoni/AppointmentSchedulerSDKFlutter.git
   ```
3. Select version rule: **Up to Next Major Version** `1.0.0 < 2.0.0`
4. Click **Add Package**
5. Select your target and click **Add Package**

#### Option 2: Package.swift

Add the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/eramitkumarsoni/AppointmentSchedulerSDKFlutter.git", from: "1.0.0")
]
```

## 📖 Usage

### 1. Initialize in AppDelegate

```swift
import UIKit
import AppointmentSchedulerSPM

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, 
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize the SDK
        AppointmentSchedulerSDK.shared.initialize()
        return true
    }
}
```

### 2. Show Appointment Scheduler

#### Basic Usage (Push Navigation)
```swift
import AppointmentSchedulerSPM

class ViewController: UIViewController {
    func showScheduler() {
        let flutterVC = AppointmentSchedulerSDK.shared.createViewController()
        navigationController?.pushViewController(flutterVC, animated: true)
    }
}
```

#### Modal Presentation
```swift
func showSchedulerModally() {
    let flutterVC = AppointmentSchedulerSDK.shared.createViewController()
    flutterVC.modalPresentationStyle = .fullScreen
    present(flutterVC, animated: true)
}
```

#### With Specific Route
```swift
func showAppointmentDetails() {
    let flutterVC = AppointmentSchedulerSDK.shared.createViewController(withRoute: "/appointments")
    present(flutterVC, animated: true)
}
```

#### SwiftUI Integration
```swift
import SwiftUI
import AppointmentSchedulerSPM

struct AppointmentView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> FlutterViewController {
        return AppointmentSchedulerSDK.shared.createViewController()
    }
    
    func updateUIViewController(_ uiViewController: FlutterViewController, context: Context) {}
}

// Usage
struct ContentView: View {
    @State private var showScheduler = false
    
    var body: some View {
        Button("Show Scheduler") {
            showScheduler = true
        }
        .sheet(isPresented: $showScheduler) {
            AppointmentView()
        }
    }
}
```

## ⚙️ Configuration

### Required Info.plist Permissions

Add these to your app's `Info.plist`:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photo library to select images</string>

<key>NSCameraUsageDescription</key>
<string>We need access to your camera to take photos</string>

<key>NSMicrophoneUsageDescription</key>
<string>We need access to your microphone for audio recording</string>

<key>NSPhotoLibraryAddUsageDescription</key>
<string>We need permission to save images to your photo library</string>
```

## 🔧 Advanced Usage

### Multiple Flutter Engines

```swift
import AppointmentSchedulerSPM

// Create separate engines for different purposes
let mainEngine = FlutterEngineManager.shared.createEngine(named: "main")
let backgroundEngine = FlutterEngineManager.shared.createEngine(named: "background")

// Use specific engine
if let engine = FlutterEngineManager.shared.getEngine(named: "main") {
    let flutterVC = FlutterViewController(engine: engine, nibName: nil, bundle: nil)
    present(flutterVC, animated: true)
}

// Cleanup when done
FlutterEngineManager.shared.removeEngine(named: "background")
```

### Method Channel Communication

```swift
guard let engine = AppointmentSchedulerSDK.shared.getEngine() else { return }

let channel = FlutterMethodChannel(
    name: "com.example.appointment/channel",
    binaryMessenger: engine.binaryMessenger
)

// Call Flutter method
channel.invokeMethod("getAppointments", arguments: nil) { result in
    if let appointments = result as? [[String: Any]] {
        print("Received appointments: \(appointments)")
    }
}

// Handle Flutter calls
channel.setMethodCallHandler { (call, result) in
    switch call.method {
    case "saveAppointment":
        // Handle save
        result(["success": true])
    default:
        result(FlutterMethodNotImplemented)
    }
}
```

## 📊 API Reference

### AppointmentSchedulerSDK

Main SDK class for managing the Appointment Scheduler.

#### Methods

- `initialize()` - Initialize the Flutter engine (call in AppDelegate)
- `createViewController() -> FlutterViewController` - Create a basic Flutter view controller
- `createViewController(withRoute: String) -> FlutterViewController` - Create with specific route
- `getEngine() -> FlutterEngine?` - Get the current Flutter engine instance

### FlutterEngineManager

Utility class for managing multiple Flutter engines.

#### Methods

- `createEngine(named: String) -> FlutterEngine` - Create or get an engine
- `getEngine(named: String) -> FlutterEngine?` - Get existing engine
- `removeEngine(named: String)` - Remove specific engine
- `removeAllEngines()` - Remove all engines

## 🐛 Troubleshooting

### Build Errors

**"No such module 'AppointmentSchedulerSPM'"**
- Clean build folder: `⌘+Shift+K`
- Delete derived data
- Rebuild: `⌘+B`

**"Framework not found"**
- Verify package is added to your target
- Check minimum iOS deployment target is 13.0+

### Runtime Errors

**"FlutterEngine not initialized"**
- Ensure `initialize()` is called in AppDelegate's `didFinishLaunchingWithOptions`

**Crash on launch**
- Check all required permissions are in Info.plist
- Verify minimum iOS version

## 📈 Performance Tips

1. **Initialize Early** - Call `initialize()` in AppDelegate for faster first load
2. **Reuse Engine** - The SDK reuses the same FlutterEngine instance for better performance
3. **Preload** - Initialize the SDK even if you don't show it immediately
4. **Memory** - The Flutter engine stays in memory for quick subsequent loads

## 📦 Package Size

- **Total Size**: ~37 MB (without debug symbols)
- **Frameworks**: 31 xcframeworks
- **Minimum iOS**: 13.0

## 🔄 Version History

### 1.0.0 (Current)
- Initial release
- Complete SPM package with all dependencies
- Swift wrapper API
- UIKit and SwiftUI support

## 🤝 Contributing

This is a wrapper package for the Flutter-based Appointment Scheduler. For issues or feature requests related to the Flutter app itself, please contact the app developers.

## 📄 License

This package is available under the MIT License. See LICENSE file for details.

## 📞 Support

For integration help:
- Check the [Integration Guide](https://github.com/eramitkumarsoni/AppointmentSchedulerSDKFlutter/wiki)
- Review code examples in the repository
- Open an issue for bugs or questions

## 🔗 Links

- **Repository**: https://github.com/eramitkumarsoni/AppointmentSchedulerSDKFlutter
- **Issues**: https://github.com/eramitkumarsoni/AppointmentSchedulerSDKFlutter/issues
- **Releases**: https://github.com/eramitkumarsoni/AppointmentSchedulerSDKFlutter/releases

## ⭐ Acknowledgments

Built with:
- [Flutter](https://flutter.dev) - UI framework
- [Swift Package Manager](https://swift.org/package-manager/) - Dependency management
- Various Flutter plugins (see framework list above)

---

**Made with ❤️ for iOS developers**

For the complete integration guide and examples, see the documentation in the repository.
