import UIKit
import Flutter
import CoreLocation

@main
@objc class AppDelegate: FlutterAppDelegate, CLLocationManagerDelegate {
    private let CHANNEL = "com.flutter_getx_clean_architecture/gps"
    private let EVENT_CHANNEL = "com.flutter_getx_clean_architecture/gps_stream"
    
    private var locationManager: CLLocationManager?
    private var eventSink: FlutterEventSink?
    private var isTracking = false
    private var locationUpdateTimer: Timer?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        
        // Method Channel
        let methodChannel = FlutterMethodChannel(
            name: CHANNEL,
            binaryMessenger: controller.binaryMessenger
        )
        
        methodChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard let self = self else { return }
            
            switch call.method {
            case "isGpsEnabled":
                result(self.isGpsEnabled())
                
            case "startGpsTracking":
                self.startGpsTracking()
                result(true)
                
            case "stopGpsTracking":
                self.stopGpsTracking()
                result(true)
                
            case "getCurrentLocation":
                self.getCurrentLocation(result: result)
                
            case "requestLocationPermission":
                self.requestLocationPermission()
                result(true)
                
            case "openLocationSettings":
                self.openLocationSettings()
                result(nil)
                
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        
        // Event Channel
        let eventChannel = FlutterEventChannel(
            name: EVENT_CHANNEL,
            binaryMessenger: controller.binaryMessenger
        )
        
        eventChannel.setStreamHandler(LocationStreamHandler(delegate: self))
        
        // Initialize location manager
        setupLocationManager()
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.distanceFilter = 10 // meters
        locationManager?.allowsBackgroundLocationUpdates = false
        locationManager?.pausesLocationUpdatesAutomatically = false
    }
    
    private func isGpsEnabled() -> Bool {
      let isEnabled =  CLLocationManager.locationServicesEnabled()
        if !isEnabled {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }

        guard let locationManager = locationManager else { return false }
        
        if #available(iOS 14.0, *) {
            return locationManager.authorizationStatus == .authorizedWhenInUse ||
                   locationManager.authorizationStatus == .authorizedAlways
        } else {
            return CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                   CLLocationManager.authorizationStatus() == .authorizedAlways
        }
    }
    
    private func requestLocationPermission() {
        locationManager?.requestWhenInUseAuthorization()
        // If you need always authorization:
        // locationManager?.requestAlwaysAuthorization()
    }
    
    private func startGpsTracking() {
        guard let locationManager = locationManager else { return }
        
        // Check permission
        let authStatus: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            authStatus = locationManager.authorizationStatus
        } else {
            authStatus = CLLocationManager.authorizationStatus()
        }
        
        guard authStatus == .authorizedWhenInUse || authStatus == .authorizedAlways else {
            requestLocationPermission()
            return
        }
        
        guard !isTracking else { return }
        
        isTracking = true
        
        // Start location updates
        locationManager.startUpdatingLocation()
        
        // Start timer to send updates every 2 seconds
        locationUpdateTimer = Timer.scheduledTimer(
            withTimeInterval: 2.0,
            repeats: true
        ) { [weak self] _ in
            guard let self = self,
                  let location = self.locationManager?.location else { return }
            
            self.sendLocationUpdate(location: location)
        }
    }
    
    private func stopGpsTracking() {
        guard let locationManager = locationManager else { return }
        
        isTracking = false
        
        // Stop location updates
        locationManager.stopUpdatingLocation()
        
        // Invalidate timer
        locationUpdateTimer?.invalidate()
        locationUpdateTimer = nil
    }
    
    private func getCurrentLocation(result: @escaping FlutterResult) {
        guard let locationManager = locationManager else {
            result(FlutterError(
                code: "LOCATION_MANAGER_ERROR",
                message: "Location manager not initialized",
                details: nil
            ))
            return
        }
        
        guard let location = locationManager.location else {
            result(FlutterError(
                code: "NO_LOCATION",
                message: "No location available",
                details: nil
            ))
            return
        }
        
        let locationData = createLocationData(from: location)
        result(locationData)
    }
    
    private func sendLocationUpdate(location: CLLocation) {
        guard let eventSink = eventSink else { return }
        
        let locationData = createLocationData(from: location)
        eventSink(locationData)
    }
    
    private func createLocationData(from location: CLLocation) -> [String: Any] {
        return [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
            "accuracy": location.horizontalAccuracy,
            "altitude": location.altitude,
            "timestamp": Int(location.timestamp.timeIntervalSince1970 * 1000)
        ]
    }
    
    private func openLocationSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    func setEventSink(_ eventSink: FlutterEventSink?) {
        self.eventSink = eventSink
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // This will be called when location updates
        // But we're also using timer for consistent 2-second intervals
        if isTracking {
            sendLocationUpdate(location: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
        
        eventSink?(FlutterError(
            code: "LOCATION_ERROR",
            message: error.localizedDescription,
            details: nil
        ))
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Location authorization changed: \(status.rawValue)")
        
        // You can notify Flutter about authorization changes if needed
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            // Permission granted
            if isTracking {
                manager.startUpdatingLocation()
            }
        case .denied, .restricted:
            // Permission denied
            stopGpsTracking()
        case .notDetermined:
            // Permission not determined
            break
        @unknown default:
            break
        }
    }
    
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationManager(manager, didChangeAuthorization: manager.authorizationStatus)
    }
}

// MARK: - Stream Handler

class LocationStreamHandler: NSObject, FlutterStreamHandler {
    weak var delegate: AppDelegate?
    
    init(delegate: AppDelegate) {
        self.delegate = delegate
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        delegate?.setEventSink(events)
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        delegate?.setEventSink(nil)
        return nil
    }
}
