import Flutter
import UIKit

/// Manager for multiple Flutter engines
public class FlutterEngineManager {
    /// Shared singleton instance
    public static let shared = FlutterEngineManager()
    
    private var engines: [String: FlutterEngine] = [:]
    
    private init() {}
    
    /// Create or retrieve a Flutter engine with the given name
    /// - Parameter name: Unique name for the engine
    /// - Returns: FlutterEngine instance
    public func createEngine(named name: String) -> FlutterEngine {
        if let existingEngine = engines[name] {
            return existingEngine
        }
        
        let engine = FlutterEngine(name: name)
        engine.run()
        engines[name] = engine
        return engine
    }
    
    /// Get an existing Flutter engine by name
    /// - Parameter name: Name of the engine
    /// - Returns: FlutterEngine instance if exists, nil otherwise
    public func getEngine(named name: String) -> FlutterEngine? {
        return engines[name]
    }
    
    /// Remove a Flutter engine by name
    /// - Parameter name: Name of the engine to remove
    public func removeEngine(named name: String) {
        engines.removeValue(forKey: name)
    }
    
    /// Remove all Flutter engines
    public func removeAllEngines() {
        engines.removeAll()
    }
}
