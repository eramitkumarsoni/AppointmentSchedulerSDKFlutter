import Flutter
import UIKit

public class FlutterEngineManager {
    public static let shared = FlutterEngineManager()
    private var engines: [String: FlutterEngine] = [:]
    
    private init() {}
    
    public func createEngine(named name: String) -> FlutterEngine {
        if let existingEngine = engines[name] {
            return existingEngine
        }
        
        let engine = FlutterEngine(name: name)
        engine.run()
        engines[name] = engine
        return engine
    }
    
    public func getEngine(named name: String) -> FlutterEngine? {
        return engines[name]
    }
    
    public func removeEngine(named name: String) {
        engines.removeValue(forKey: name)
    }
}
