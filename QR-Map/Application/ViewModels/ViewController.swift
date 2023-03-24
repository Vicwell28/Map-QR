//
//  ViewController.swift
//  QR-Map
//
//  Created by soliduSystem on 22/03/23.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    // MARK: - Override Func
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.requestAlwaysAuthorization()
        self.locationManager?.requestWhenInUseAuthorization()
        
        self.mapKit.showsUserLocation = true
        self.mapKit.userTrackingMode = .follow
        self.mapKit.backgroundColor = .darkGray
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }
    
    
    // MARK: - IBOutlet
    @IBOutlet weak var mapKit: MKMapView!
    
    // MARK: - Public let / var
    public var locationManager : CLLocationManager?
    
    // MARK: - Private let / var
    
    
    // MARK: - IBAction
    
    @IBAction func startScanQR(_ sender: UIButton) {
        print("va a comenzar a scan QR ")
    }
    
}

// MARK: - Public Func
extension Example_ViewController {
    
}

// MARK: - Private Func
extension Example_ViewController {
    
}

// MARK: - Services
extension Example_ViewController {
    
}


// MARK: - CLLocationManagerDelegate
extension ViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {")
        // 2
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            self.mapKit.setRegion(region, animated: true)
        }
        
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {")
        //1
        print(manager.authorizationStatus)
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways :
            manager.startUpdatingLocation()
            break
        case .denied:
            break
        case .restricted:
            break
        case .notDetermined:
            break
        @unknown default:
            print(manager.authorizationStatus)
            
        }
        
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {")
        
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        print("func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        print("func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {")
        
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailRangingFor beaconConstraint: CLBeaconIdentityConstraint, error: Error) {
        print("func locationManager(_ manager: CLLocationManager, didFailRangingFor beaconConstraint: CLBeaconIdentityConstraint, error: Error) {")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        print("func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        print("func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print("func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {")
        
    }
    
   
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        print("func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {")
        
    }
    
    
}


