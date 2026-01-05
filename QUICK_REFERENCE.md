# 🚀 Quick Reference - Appointment Scheduler SDK

## 📦 Installation

### Xcode (Recommended)
```
File → Add Package Dependencies
URL: https://github.com/eramitkumarsoni/AppointmentSchedulerSDKFlutter.git
Version: 1.3.0
```

### Package.swift
```swift
.package(url: "https://github.com/eramitkumarsoni/AppointmentSchedulerSDKFlutter.git", exact: "1.3.0")
```

---

## 💻 Basic Usage

### 1. Initialize (AppDelegate.swift)
```swift
import AppointmentSchedulerSDKFlutter

AppointmentSchedulerSDK.shared.initialize()
```

### 2. Present (UIKit)
```swift
let vc = AppointmentSchedulerSDK.shared.createViewController()
present(vc, animated: true)
```

### 3. Present (SwiftUI)
```swift
struct FlutterView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> FlutterViewController {
        AppointmentSchedulerSDK.shared.createViewController()
    }
    func updateUIViewController(_ uiViewController: FlutterViewController, context: Context) {}
}

// Use:
.sheet(isPresented: $show) { FlutterView() }
```

---

## 📱 Presentation Styles

```swift
let vc = AppointmentSchedulerSDK.shared.createViewController()

// Full screen
vc.modalPresentationStyle = .fullScreen

// Sheet (iOS 13+)
vc.modalPresentationStyle = .pageSheet

// Custom sheet (iOS 15+)
if let sheet = vc.sheetPresentationController {
    sheet.detents = [.medium(), .large()]
    sheet.prefersGrabberVisible = true
}

present(vc, animated: true)
```

---

## 🔗 Method Channel (Advanced)

```swift
let engine = AppointmentSchedulerSDK.shared.getEngine()
let channel = FlutterMethodChannel(
    name: "com.example.appointment/channel",
    binaryMessenger: engine!.binaryMessenger
)

// Receive from Flutter
channel.setMethodCallHandler { (call, result) in
    switch call.method {
    case "closeScheduler":
        // Handle close
        result(nil)
    default:
        result(FlutterMethodNotImplemented)
    }
}

// Send to Flutter
channel.invokeMethod("methodName", arguments: ["key": "value"])
```

---

## 🔧 Requirements

- iOS 13.0+
- Swift 5.9+
- Xcode 15.0+

---

## 📚 Documentation

- `README.md` - Installation & overview
- `INTEGRATION_GUIDE.md` - Complete guide
- `ExampleIntegration.swift` - Code examples

---

## 🐛 Troubleshooting

**Build fails?**
```
⌘ + Shift + K (Clean)
File → Packages → Reset Package Caches
```

**Firebase conflicts?**
- SDK includes Firebase internally
- Don't duplicate Firebase in your app

**Black screen?**
- Call `initialize()` in AppDelegate
- Check Flutter engine is running

---

## 📊 What's Included

30 frameworks including:
- Flutter engine
- Firebase Core
- Image/Video pickers
- Audio/Video players
- Secure storage
- File management
- And more...

---

## 🏷️ Versions

- **Latest**: v1.3.0 (Recommended)
- **Stable**: v1.2.0
- **Branch**: `main`

---

## 🆘 Support

GitHub: https://github.com/eramitkumarsoni/AppointmentSchedulerSDKFlutter
Issues: GitHub Issues tab

---

**That's it! You're ready to go! 🎉**
