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
        self.mapKit.delegate = self
        
        self.destinationViewController.delegate = self
        
        self.motionViewModel.delegate = self
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak var mapKit: MKMapView!
    
    // MARK: - Public let / var
    public var locationManager : CLLocationManager?
    
    //        Accelerometer & Gyroscope
    public let motionViewModel : MotionViewModel = MotionViewModel()
    @IBOutlet var lblGyroscopeColl: [UILabel]!
    @IBOutlet var lblAccelerometerColl: [UILabel]!
    
    //MAP KIT
    var currentLocation: CLLocation?
    var destinationLocation: CLLocation?
    var lastMKPolygon : MKPolyline?
    var isScannedQR : Bool = true
    
    let destinationViewController = ScannerViewController()
    
    // MARK: - Private let / var
    
    
    // MARK: - IBAction
    @IBAction func startScanQR(_ sender: UIButton) {
        self.destinationViewController.modalPresentationStyle = .fullScreen
        self.present(destinationViewController, animated: true)
    }
}

// MARK: - Public Func
extension ViewController {
    
    func drawRoute(sourcePlacemark: MKPlacemark, destinationPlacemark: MKPlacemark) {
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionsRequest = MKDirections.Request()
        
        directionsRequest.source = sourceMapItem
        directionsRequest.destination = destinationMapItem
        directionsRequest.transportType = .walking
        
        let directions = MKDirections(request: directionsRequest)
        
        directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Error en la solicitud de direcciones: \(error.localizedDescription)")
                }
                return
            }
            
            if let lastMKPolygon = self.lastMKPolygon {
                self.mapKit.removeOverlay(lastMKPolygon)
            }
            
            let route = response.routes[0]
            self.lastMKPolygon = route.polyline
            
            let rect = route.polyline.boundingMapRect
            
            self.mapKit.setRegion(MKCoordinateRegion(rect), animated: true)
//            self.mapKit.setRegion(MKCoordinateRegion(center: route.polyline.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)), animated: true)
            
            self.mapKit.addOverlay(self.lastMKPolygon!)
        }
    }
}

// MARK: - Private Func
extension ViewController {
    
}

// MARK: - Services
extension ViewController : ScannerViewDelegate{
    func didscanned(code: String) {
        
        guard let code = code.data(using: .utf8) else { return }
        
        do {
            let location = try JSONDecoder().decode(CLLocationScanQRModel.self, from: code)
            print(location)
            self.destinationLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
            self.isScannedQR = true
        } catch {
            print(error.localizedDescription)
        }
        
    }
}

extension ViewController : MotionDelegate{
    func didUpdateAcceleromer(x: Double, y: Double, z: Double) {

        let x = round(x * 100000) / 100000
        let y = round(y * 100000) / 100000
        let z = round(z * 100000) / 100000
        
        self.lblAccelerometerColl[0].text = "x: \(x)"
        self.lblAccelerometerColl[1].text = "y: \(y)"
        self.lblAccelerometerColl[2].text = "z: \(z)"
    }
    
    func didUpdateGyro(x: Double, y: Double, z: Double) {
        
        let x = round(x * 100000) / 100000
        let y = round(y * 100000) / 100000
        let z = round(z * 100000) / 100000
        
        self.lblGyroscopeColl[0].text = "x: \(x)"
        self.lblGyroscopeColl[1].text = "y: \(y)"
        self.lblGyroscopeColl[2].text = "z: \(z)"
    }
    
}

extension ViewController : MKMapViewDelegate {
    
    // Este método se llama cada vez que se agrega una superposición al mapa
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polylineOverlay = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polylineOverlay)
        renderer.strokeColor = .black
        renderer.lineWidth = 5
        
        return renderer
    }
    
}


// MARK: - CLLocationManagerDelegate
extension ViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {")
        
        guard let currentLocation = locations.last else { return }
        self.currentLocation = currentLocation
        
        if self.isScannedQR {
            self.isScannedQR = false
            
            let center = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            self.mapKit.setRegion(region, animated: true)
            
            // Si se ha recibido la ubicación de destino, dibujar la ruta
            if let destinationLocation = destinationLocation {
                let sourcePlacemark = MKPlacemark(coordinate: currentLocation.coordinate)
                let destinationPlacemark = MKPlacemark(coordinate: destinationLocation.coordinate)
                drawRoute(sourcePlacemark: sourcePlacemark, destinationPlacemark: destinationPlacemark)
            }
        }
        
        
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
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
}


