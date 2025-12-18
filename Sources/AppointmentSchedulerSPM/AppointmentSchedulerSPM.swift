import Flutter
import UIKit

public class AppointmentSchedulerSDK {
    public static let shared = AppointmentSchedulerSDK()
    private var flutterEngine: FlutterEngine?
    
    private init() {}
    
    public func initialize() {
        flutterEngine = FlutterEngine(name: "AppointmentScheduler")
        flutterEngine?.run()
    }
    
    public func createViewController() -> FlutterViewController {
        guard let engine = flutterEngine else {
            fatalError("FlutterEngine not initialized. Call initialize() first.")
        }
        return FlutterViewController(engine: engine, nibName: nil, bundle: nil)
    }
    
    public func createViewController(withRoute route: String) -> FlutterViewController {
        guard let engine = flutterEngine else {
            fatalError("FlutterEngine not initialized. Call initialize() first.")
        }
        engine.navigationChannel.invokeMethod("setInitialRoute", arguments: route)
        return FlutterViewController(engine: engine, nibName: nil, bundle: nil)
    }
}
