import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let flutterViewController: FlutterViewController = window?.rootViewController as! FlutterViewController

        // Setting up the MethodChannel
        let channel = FlutterMethodChannel(name: "ms_full_screen_mode", binaryMessenger: flutterViewController.binaryMessenger)
        
        // Handle method calls from Flutter
        channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            switch call.method {
            case "enterFullScreen":
                let args = call.arguments as? [String: Any]
                let edge = args?["edge"] as? String ?? "both"
                self?.enterFullScreenMode(edge: edge)
            default:
                 result(FlutterMethodNotImplemented)
        
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // Function to enable full-screen mode based on edge input
    private func enterFullScreenMode(edge: String) {
        // Check if the full-screen mode is already active to prevent redundant calls
            let immersiveViewController = ImmersiveViewController()
            
            // Pass the edge to the ImmersiveViewController
            immersiveViewController.setScreenEdges(edge: edge)
            
            // Replace the root view controller with our immersive view controller
            window?.rootViewController = immersiveViewController
            // Update the state to indicate full-screen mode is active
    }
}

class ImmersiveViewController: FlutterViewController {
    
    private var screenEdge: UIRectEdge = []

    // Set the screen edges based on the Flutter input
    func setScreenEdges(edge: String) {
        switch edge {
        case "top":
            screenEdge = [.top]
        case "bottom":
            screenEdge = [.bottom]
        case "both":
            screenEdge = [.top, .bottom]
        default:
            screenEdge = []
        }
    }
    
    // Hides the Home Indicator
    override var prefersHomeIndicatorAutoHidden: Bool {
        return false
    }

    // Defers system gestures on the specified edges
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return screenEdge
    }
    
    // Ensure the view updates to hide the home indicator and defer gestures
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNeedsUpdateOfHomeIndicatorAutoHidden()
        setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
    }
}
