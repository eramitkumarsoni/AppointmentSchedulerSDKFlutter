//
//  ExampleIntegration.swift
//  Example: How to integrate Appointment Scheduler SDK in your iOS app
//
//  Created for AppointmentSchedulerSDKFlutter
//

import UIKit
import AppointmentSchedulerSDKFlutter

// MARK: - Example 1: Basic Integration in AppDelegate

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // ✅ STEP 1: Initialize the SDK
        AppointmentSchedulerSDK.shared.initialize()
        
        print("✅ Appointment Scheduler SDK initialized")
        
        return true
    }
}

// MARK: - Example 2: Simple View Controller Integration

class SimpleSchedulerViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var showButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Appointment Scheduler", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(showSchedulerTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(showButton)
        
        NSLayoutConstraint.activate([
            showButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            showButton.widthAnchor.constraint(equalToConstant: 280),
            showButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func showSchedulerTapped() {
        // ✅ STEP 2: Create and present the Flutter view controller
        let flutterVC = AppointmentSchedulerSDK.shared.createViewController()
        flutterVC.modalPresentationStyle = .fullScreen
        present(flutterVC, animated: true, completion: nil)
    }
}

// MARK: - Example 3: Advanced Integration with Method Channel

class AdvancedSchedulerViewController: UIViewController {
    
    private var flutterViewController: FlutterViewController?
    private var methodChannel: FlutterMethodChannel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSchedulerWithMethodChannel()
    }
    
    private func setupSchedulerWithMethodChannel() {
        // Get the Flutter engine
        guard let engine = AppointmentSchedulerSDK.shared.getEngine() else {
            print("❌ Flutter engine not initialized")
            return
        }
        
        // Create Flutter view controller
        flutterViewController = AppointmentSchedulerSDK.shared.createViewController()
        
        // Setup method channel for bidirectional communication
        methodChannel = FlutterMethodChannel(
            name: "com.example.appointment/channel",
            binaryMessenger: engine.binaryMessenger
        )
        
        // Handle calls FROM Flutter
        methodChannel?.setMethodCallHandler { [weak self] (call, result) in
            switch call.method {
            case "closeScheduler":
                print("📱 Flutter requested to close scheduler")
                self?.dismissScheduler()
                result(nil)
                
            case "appointmentCreated":
                if let args = call.arguments as? [String: Any] {
                    self?.handleAppointmentCreated(args)
                }
                result(nil)
                
            case "appointmentUpdated":
                if let args = call.arguments as? [String: Any] {
                    self?.handleAppointmentUpdated(args)
                }
                result(nil)
                
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    // Send data TO Flutter
    func sendAppointmentData(appointmentId: String, details: [String: Any]) {
        methodChannel?.invokeMethod("loadAppointment", arguments: [
            "id": appointmentId,
            "details": details
        ]) { result in
            if let error = result as? FlutterError {
                print("❌ Error sending data to Flutter: \(error.message ?? "Unknown error")")
            } else {
                print("✅ Data sent to Flutter successfully")
            }
        }
    }
    
    private func handleAppointmentCreated(_ data: [String: Any]) {
        print("✅ Appointment created:")
        print("   ID: \(data["id"] ?? "N/A")")
        print("   Title: \(data["title"] ?? "N/A")")
        print("   Date: \(data["date"] ?? "N/A")")
        
        // Process the appointment data in your app
        // e.g., save to local database, sync with server, etc.
    }
    
    private func handleAppointmentUpdated(_ data: [String: Any]) {
        print("✅ Appointment updated:")
        print("   Data: \(data)")
        
        // Process the updated appointment data
    }
    
    private func dismissScheduler() {
        flutterViewController?.dismiss(animated: true) {
            print("✅ Scheduler dismissed")
        }
    }
}

// MARK: - Example 4: SwiftUI Integration

import SwiftUI

struct SchedulerSwiftUIView: View {
    @State private var showScheduler = false
    @State private var appointmentCount = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Appointments: \(appointmentCount)")
                    .font(.title2)
                    .padding()
                
                Button(action: {
                    showScheduler = true
                }) {
                    HStack {
                        Image(systemName: "calendar.badge.plus")
                        Text("New Appointment")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .navigationTitle("Scheduler Demo")
            .sheet(isPresented: $showScheduler) {
                FlutterSchedulerWrapper()
                    .onAppear {
                        print("✅ Flutter scheduler presented")
                    }
                    .onDisappear {
                        print("✅ Flutter scheduler dismissed")
                        appointmentCount += 1
                    }
            }
        }
    }
}

// SwiftUI wrapper for Flutter view controller
struct FlutterSchedulerWrapper: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> FlutterViewController {
        return AppointmentSchedulerSDK.shared.createViewController()
    }
    
    func updateUIViewController(_ uiViewController: FlutterViewController, context: Context) {
        // No updates needed
    }
}

// MARK: - Example 5: Multiple Engine Management

class MultiEngineSchedulerManager {
    
    static let shared = MultiEngineSchedulerManager()
    
    private init() {}
    
    func createSchedulerWithCustomEngine(named engineName: String) -> FlutterViewController {
        // Create a dedicated engine for this scheduler instance
        let engine = FlutterEngineManager.shared.createEngine(named: engineName)
        
        // Create view controller with the custom engine
        let viewController = FlutterViewController(engine: engine, nibName: nil, bundle: nil)
        
        print("✅ Created scheduler with engine: \(engineName)")
        
        return viewController
    }
    
    func cleanupEngine(named engineName: String) {
        FlutterEngineManager.shared.removeEngine(named: engineName)
        print("✅ Cleaned up engine: \(engineName)")
    }
    
    func cleanupAllEngines() {
        FlutterEngineManager.shared.removeAllEngines()
        print("✅ All engines cleaned up")
    }
}

// Usage example:
/*
 let manager = MultiEngineSchedulerManager.shared
 let scheduler1 = manager.createSchedulerWithCustomEngine(named: "scheduler1")
 let scheduler2 = manager.createSchedulerWithCustomEngine(named: "scheduler2")
 
 // When done
 manager.cleanupEngine(named: "scheduler1")
 manager.cleanupEngine(named: "scheduler2")
 */

// MARK: - Example 6: Navigation Controller Integration

class MainNavigationViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let menuItems = [
        "📅 View Appointments",
        "➕ Create Appointment",
        "📊 Analytics",
        "⚙️ Settings"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Appointment App"
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func openScheduler(mode: String) {
        let flutterVC = AppointmentSchedulerSDK.shared.createViewController()
        
        // Push onto navigation stack
        navigationController?.pushViewController(flutterVC, animated: true)
        
        print("✅ Pushed scheduler to navigation stack (mode: \(mode))")
    }
}

extension MainNavigationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            openScheduler(mode: "view")
        case 1:
            openScheduler(mode: "create")
        default:
            print("Other menu item tapped")
        }
    }
}

// MARK: - Example 7: Custom Presentation Styles

class CustomPresentationViewController: UIViewController {
    
    // Present as full screen modal
    func presentFullScreen() {
        let flutterVC = AppointmentSchedulerSDK.shared.createViewController()
        flutterVC.modalPresentationStyle = .fullScreen
        flutterVC.modalTransitionStyle = .crossDissolve
        present(flutterVC, animated: true)
    }
    
    // Present as page sheet (iOS 13+)
    func presentAsSheet() {
        let flutterVC = AppointmentSchedulerSDK.shared.createViewController()
        flutterVC.modalPresentationStyle = .pageSheet
        present(flutterVC, animated: true)
    }
    
    // Present with custom sheet configuration (iOS 15+)
    @available(iOS 15.0, *)
    func presentAsCustomSheet() {
        let flutterVC = AppointmentSchedulerSDK.shared.createViewController()
        flutterVC.modalPresentationStyle = .pageSheet
        
        if let sheet = flutterVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        present(flutterVC, animated: true)
    }
    
    // Embed in container view
    func embedInContainer(containerView: UIView) {
        let flutterVC = AppointmentSchedulerSDK.shared.createViewController()
        
        addChild(flutterVC)
        containerView.addSubview(flutterVC.view)
        
        flutterVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            flutterVC.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            flutterVC.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            flutterVC.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            flutterVC.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        flutterVC.didMove(toParent: self)
    }
}

// MARK: - Usage Instructions

/*
 
 HOW TO USE THIS SDK IN YOUR PROJECT:
 
 1️⃣ ADD THE PACKAGE (Choose one method):
    
    Method A - Xcode:
    - File → Add Package Dependencies
    - Enter: https://github.com/eramitkumarsoni/AppointmentSchedulerSDKFlutter.git
    - Select version: 1.3.0
    
    Method B - Package.swift:
    ```
    .package(url: "https://github.com/eramitkumarsoni/AppointmentSchedulerSDKFlutter.git", exact: "1.3.0")
    ```

 2️⃣ INITIALIZE IN APPDELEGATE:
    
    ```swift
    import AppointmentSchedulerSDKFlutter
    
    func application(...) -> Bool {
        AppointmentSchedulerSDK.shared.initialize()
        return true
    }
    ```

 3️⃣ SHOW THE SCHEDULER:
    
    Simple way:
    ```swift
    let flutterVC = AppointmentSchedulerSDK.shared.createViewController()
    present(flutterVC, animated: true)
    ```
    
    With navigation:
    ```swift
    navigationController?.pushViewController(flutterVC, animated: true)
    ```
    
    SwiftUI:
    ```swift
    struct ContentView: View {
        @State private var showScheduler = false
        
        var body: some View {
            Button("Show Scheduler") {
                showScheduler = true
            }
            .sheet(isPresented: $showScheduler) {
                FlutterSchedulerWrapper()
            }
        }
    }
    ```

 4️⃣ THAT'S IT! 🎉
    
    Your appointment scheduler is ready to use!

 📚 For more examples, see:
    - README.md
    - INTEGRATION_GUIDE.md
    - GitHub: https://github.com/eramitkumarsoni/AppointmentSchedulerSDKFlutter

 */
