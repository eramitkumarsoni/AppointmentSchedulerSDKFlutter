# Appointment Scheduler SPM

Swift Package Manager package for the Appointment Scheduler Flutter SDK.

## Installation

### Xcode

1. In Xcode, go to File → Add Packages
2. Enter the repository URL or select "Add Local..." for local development
3. Select the version or branch
4. Click "Add Package"

### Package.swift

Add the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://your-repo-url/AppointmentSchedulerSPM.git", from: "1.0.0")
]
```

## Usage

### Initialize in AppDelegate

```swift
import UIKit
import AppointmentSchedulerSPM

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, 
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppointmentSchedulerSDK.shared.initialize()
        return true
    }
}
```

### Show Appointment Scheduler

```swift
import UIKit
import AppointmentSchedulerSPM

class ViewController: UIViewController {
    func showScheduler() {
        let flutterVC = AppointmentSchedulerSDK.shared.createViewController()
        navigationController?.pushViewController(flutterVC, animated: true)
    }
}
```

## Requirements

- iOS 13.0+
- Swift 5.9+
- Xcode 15.0+

## License

See LICENSE file for details.
