import Flutter
import UIKit

/// Main SDK class for Appointment Scheduler
public class AppointmentSchedulerSDK {
    /// Shared singleton instance
    public static let shared = AppointmentSchedulerSDK()
    
    private var flutterEngine: FlutterEngine?
    
    private init() {}
    
    /// Initialize the Flutter engine
    /// Call this method in your AppDelegate's didFinishLaunchingWithOptions
    public func initialize() {
        flutterEngine = FlutterEngine(name: "AppointmentScheduler")
        flutterEngine?.run()
    }
    
    /// Create a Flutter view controller
    /// - Returns: FlutterViewController instance
    public func createViewController() -> FlutterViewController {
        guard let engine = flutterEngine else {
            fatalError("FlutterEngine not initialized. Call initialize() first.")
        }
        return FlutterViewController(engine: engine, nibName: nil, bundle: nil)
    }
    
    /// Create a Flutter view controller with a specific route
    /// - Parameter route: The initial route to navigate to
    /// - Returns: FlutterViewController instance
    public func createViewController(withRoute route: String) -> FlutterViewController {
        guard let engine = flutterEngine else {
            fatalError("FlutterEngine not initialized. Call initialize() first.")
        }
        engine.navigationChannel.invokeMethod("setInitialRoute", arguments: route)
        return FlutterViewController(engine: engine, nibName: nil, bundle: nil)
    }
    
    /// Get the current Flutter engine instance
    /// - Returns: FlutterEngine instance if initialized, nil otherwise
    public func getEngine() -> FlutterEngine? {
        return flutterEngine
    }
}
