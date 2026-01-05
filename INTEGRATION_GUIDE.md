# iOS Integration Guide - Appointment Scheduler SDK

Complete guide for integrating the Appointment Scheduler Flutter SDK into your iOS project using Swift Package Manager.

## 📦 Step 1: Add the Package

### Option A: Using Xcode GUI

1. Open your iOS project in Xcode
2. Click on your project in the navigator
3. Select your app target
4. Go to the "Package Dependencies" tab
5. Click the **"+"** button
6. Enter the repository URL:
   ```
   https://github.com/eramitkumarsoni/AppointmentSchedulerSDKFlutter.git
   ```
7. Select **"Exact Version"** and enter: `1.3.0`
8. Click **"Add Package"**
9. Select "AppointmentSchedulerSDKFlutter" and click **"Add Package"**

### Option B: Using Package.swift

If you're creating a Swift Package, add this to your `Package.swift`:

```swift
// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "YourApp",
    platforms: [
        .iOS(.v13)
    ],
    dependencies: [
        .package(
            url: "https://github.com/eramitkumarsoni/AppointmentSchedulerSDKFlutter.git",
            exact: "1.3.0"
        )
    ],
    targets: [
        .target(
            name: "YourApp",
            dependencies: [
                .product(name: "AppointmentSchedulerSDKFlutter", package: "AppointmentSchedulerSDKFlutter")
            ]
        )
    ]
)
```

## 🔧 Step 2: Configure Your Project

### Update Info.plist

Add required permissions to your `Info.plist`:

```xml
<!-- Camera Access -->
<key>NSCameraUsageDescription</key>
<string>We need access to your camera to take photos for appointments</string>

<!-- Photo Library Access -->
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photo library to select images</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>We need permission to save images to your photo library</string>

<!-- Microphone Access (if using audio) -->
<key>NSMicrophoneUsageDescription</key>
<string>We need access to your microphone for voice recordings</string>
```

### Firebase Configuration (if needed)

If you're using Firebase in your app:

1. Download `GoogleService-Info.plist` from Firebase Console
2. Add it to your Xcode project root
3. Make sure it's included in your target

## 💻 Step 3: Initialize the SDK

### Update AppDelegate.swift

```swift
import UIKit
import AppointmentSchedulerSDKFlutter

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
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

### For SwiftUI Apps (SceneDelegate)

```swift
import UIKit
import AppointmentSchedulerSDKFlutter

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        // Initialize SDK when scene is created
        AppointmentSchedulerSDK.shared.initialize()
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
}
```

## 🎯 Step 4: Show the Scheduler

### UIKit - Button Action

```swift
import UIKit
import AppointmentSchedulerSDKFlutter

class ViewController: UIViewController {
    
    @IBAction func showSchedulerButtonTapped(_ sender: UIButton) {
        showAppointmentScheduler()
    }
    
    private func showAppointmentScheduler() {
        // Create Flutter view controller
        let flutterVC = AppointmentSchedulerSDK.shared.createViewController()
        
        // Configure presentation style
        flutterVC.modalPresentationStyle = .fullScreen
        flutterVC.modalTransitionStyle = .coverVertical
        
        // Present the scheduler
        present(flutterVC, animated: true, completion: nil)
    }
}
```

### SwiftUI - Integration

```swift
import SwiftUI
import AppointmentSchedulerSDKFlutter

struct ContentView: View {
    @State private var showScheduler = false
    
    var body: some View {
        Button("Show Appointment Scheduler") {
            showScheduler = true
        }
        .sheet(isPresented: $showScheduler) {
            FlutterSchedulerView()
        }
    }
}

// Wrapper for Flutter View Controller
struct FlutterSchedulerView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        return AppointmentSchedulerSDK.shared.createViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No updates needed
    }
}
```

### Navigation Controller Integration

```swift
import UIKit
import AppointmentSchedulerSDKFlutter

class ViewController: UIViewController {
    
    func navigateToScheduler() {
        let flutterVC = AppointmentSchedulerSDK.shared.createViewController()
        navigationController?.pushViewController(flutterVC, animated: true)
    }
}
```

## 🔄 Step 5: Handle Callbacks (Advanced)

### Method Channel Communication

If you need to communicate between native iOS and Flutter:

```swift
import UIKit
import Flutter
import AppointmentSchedulerSDKFlutter

class SchedulerViewController: UIViewController {
    
    private var flutterViewController: FlutterViewController?
    private var methodChannel: FlutterMethodChannel?
    
    func setupScheduler() {
        // Get the Flutter engine
        guard let engine = AppointmentSchedulerSDK.shared.getEngine() else {
            print("Flutter engine not initialized")
            return
        }
        
        // Create Flutter view controller
        flutterViewController = FlutterViewController(engine: engine, nibName: nil, bundle: nil)
        
        // Setup method channel
        methodChannel = FlutterMethodChannel(
            name: "com.example.appointment/channel",
            binaryMessenger: engine.binaryMessenger
        )
        
        // Handle method calls from Flutter
        methodChannel?.setMethodCallHandler { [weak self] (call, result) in
            switch call.method {
            case "closeScheduler":
                self?.dismiss(animated: true, completion: nil)
                result(nil)
                
            case "appointmentCreated":
                if let args = call.arguments as? [String: Any] {
                    self?.handleAppointmentCreated(args)
                }
                result(nil)
                
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        
        // Present Flutter view controller
        if let flutterVC = flutterViewController {
            flutterVC.modalPresentationStyle = .fullScreen
            present(flutterVC, animated: true)
        }
    }
    
    private func handleAppointmentCreated(_ data: [String: Any]) {
        print("Appointment created with data: \(data)")
        // Handle the appointment data
    }
    
    // Send data to Flutter
    func sendDataToFlutter(appointmentId: String) {
        methodChannel?.invokeMethod("loadAppointment", arguments: ["id": appointmentId])
    }
}
```

## 📱 Step 6: Customize Presentation

### Custom Modal Presentation

```swift
func showCustomScheduler() {
    let flutterVC = AppointmentSchedulerSDK.shared.createViewController()
    
    // Custom presentation
    flutterVC.modalPresentationStyle = .pageSheet
    
    // Configure sheet (iOS 15+)
    if #available(iOS 15.0, *) {
        if let sheet = flutterVC.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
        }
    }
    
    present(flutterVC, animated: true)
}
```

### Embed in Container View

```swift
class ContainerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        embedFlutterScheduler()
    }
    
    private func embedFlutterScheduler() {
        let flutterVC = AppointmentSchedulerSDK.shared.createViewController()
        
        // Add as child view controller
        addChild(flutterVC)
        view.addSubview(flutterVC.view)
        
        // Setup constraints
        flutterVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            flutterVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            flutterVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            flutterVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            flutterVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        flutterVC.didMove(toParent: self)
    }
}
```

## 🧪 Testing

### Sample Test Case

```swift
import XCTest
import AppointmentSchedulerSDKFlutter

class SchedulerTests: XCTestCase {
    
    func testSDKInitialization() {
        // Initialize SDK
        AppointmentSchedulerSDK.shared.initialize()
        
        // Verify engine is created
        let engine = AppointmentSchedulerSDK.shared.getEngine()
        XCTAssertNotNil(engine, "Flutter engine should be initialized")
    }
    
    func testCreateViewController() {
        AppointmentSchedulerSDK.shared.initialize()
        
        let viewController = AppointmentSchedulerSDK.shared.createViewController()
        XCTAssertNotNil(viewController, "Should create Flutter view controller")
        XCTAssertTrue(viewController.isKind(of: FlutterViewController.self))
    }
}
```

## 🚨 Common Issues & Solutions

### Issue 1: Build Errors

**Problem**: Build fails with framework linking errors

**Solution**:
1. Clean build folder: `⌘ + Shift + K`
2. Delete derived data
3. Reset package caches: `File` → `Packages` → `Reset Package Caches`
4. Rebuild project

### Issue 2: Firebase Conflicts

**Problem**: Duplicate Firebase symbols

**Solution**:
- Remove Firebase frameworks from your project if SDK includes them
- Use the same Firebase version throughout your app

### Issue 3: App Crashes on Launch

**Problem**: App crashes when initializing SDK

**Solution**:
- Ensure you call `AppointmentSchedulerSDK.shared.initialize()` in AppDelegate
- Check console for specific error messages
- Verify all permissions are added to Info.plist

### Issue 4: Black Screen

**Problem**: Flutter view controller shows black screen

**Solution**:
- Ensure Flutter engine is initialized before creating view controller
- Check if `initialize()` was called in AppDelegate
- Verify the Flutter app builds correctly

## 📊 Performance Tips

1. **Initialize Early**: Call `initialize()` in AppDelegate for faster first load
2. **Reuse Engine**: Keep the Flutter engine alive if showing scheduler multiple times
3. **Memory Management**: Properly dismiss Flutter view controllers to free memory

## 🔐 Security Considerations

1. Always validate data received from Flutter
2. Use secure storage for sensitive appointment data
3. Implement proper authentication before showing scheduler
4. Follow iOS security best practices for data handling

## 📚 Additional Resources

- [Flutter iOS Integration](https://docs.flutter.dev/platform-integration/ios)
- [Method Channels Documentation](https://docs.flutter.dev/platform-integration/platform-channels)
- [SPM Documentation](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app)

## ✅ Checklist

Before deploying to production:

- [ ] SDK properly initialized in AppDelegate
- [ ] All required Info.plist permissions added
- [ ] Firebase configured (if using)
- [ ] Tested on multiple iOS versions
- [ ] Tested on different device sizes
- [ ] Memory leaks checked with Instruments
- [ ] Proper error handling implemented
- [ ] Analytics/logging configured
- [ ] Tested modal dismissal and navigation
- [ ] Performance tested with real data

---

**Need help?** Open an issue on [GitHub](https://github.com/eramitkumarsoni/AppointmentSchedulerSDKFlutter)
