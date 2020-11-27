//
//  MapViewController.swift
//  MapsApp
//
//  Created by Кирилл Романенко on 14.11.2020.
//

import UIKit
import GoogleMaps
import SnapKit
import GoogleMapsUtils

protocol MapViewDelegate {
    func changeImageOfMarker(zoom: Float)
}

class MapViewController: UIViewController {
    
    private var mapView: GMSMapView?
    private var clusterManager: GMUClusterManager?
    private let locationManager = CLLocationManager()
    static let delegates = MultiDelegate<MapViewDelegate>()
    var markerArray = [CustomMarker]()
    
    var addressLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0.85
        label.textAlignment = .center
        label.text = ""
        label.numberOfLines = 0
        label.textColor = .black
        label.backgroundColor = .white
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setup()
        createLocationManager()
        createClusterManager()
        createClusterArray()
    }
    
    func createClusterManager() {
        guard let mapView = mapView else { return }
        
        
        let iconGenerator = MapClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        algorithm.clusters(atZoom: 1)
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        renderer.delegate = self
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        guard let clusterManager = clusterManager else { return }
        clusterManager.setDelegate(self, mapDelegate: self)
        
    }
    
    func createClusterArray() {
        
        
        for _ in 0...100 {
            let marker = setMarker(latitude: 52.341898214209316+(Double.random(in: -0.060000...0.0600000)), longitude: 104.22146882861853+(Double.random(in: -0.060000...0.0600000)))
            marker.postVacancy(number: Int.random(in: 0...20), salary: Int.random(in: 14...50))
            markerArray.append(marker)
        }
        
//        clusterManager?.add(markerArray)
//        clusterManager?.cluster()
    }
    
    func setMarker(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> CustomMarker {
        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let marker = CustomMarker(position: position)
        marker.map = mapView
        return marker
    }
    
    func createLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.requestLocation()
//
//            guard let mapView = mapView else { return }
//            mapView.isMyLocationEnabled = true
//            mapView.settings.myLocationButton = true
//        } else {
//            locationManager.requestWhenInUseAuthorization()
//        }
    }
    
    func setup() {
        mapView = GMSMapView()
        guard let mapView = mapView else { return }
        mapView.delegate = self
        mapView.backgroundColor = .lightGray
        
        [mapView, addressLabel].forEach{ self.view.addSubview($0) }
        
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        addressLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-25)
        }
    }
    
    func reserveGeocode(coordinate: CLLocationCoordinate2D) {
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { (response, error) in
            guard let address = response?.firstResult(), let lines = address.lines else { return }
            
            self.addressLabel.text = lines.joined(separator: "\n")
            
            let labelHeight = self.addressLabel.intrinsicContentSize.height
            let topInset = self.view.safeAreaInsets.top
            
            self.mapView?.padding = UIEdgeInsets(top: topInset, left: 0, bottom: labelHeight, right: 0)
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
        
    }

}

extension MapViewController: GMUClusterRendererDelegate {
    
    
}

extension MapViewController: GMUClusterManagerDelegate {
    
    private func clusterManager(clusterManager: GMUClusterManager, didTapCluster cluster: GMUCluster) {
        guard let mapView = mapView else { return }
        
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
                                                           zoom: mapView.camera.zoom + 1)
        let update = GMSCameraUpdate.setCamera(newCamera)
        mapView.moveCamera(update)
    }
    
}

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reserveGeocode(coordinate: position.target)
//        print(position.target)
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        MapViewController.delegates.invoke {
            $0.changeImageOfMarker(zoom: mapView.camera.zoom)
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        //
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        guard manager.authorizationStatus == .authorizedWhenInUse else { return }
        manager.startUpdatingLocation()
        
        mapView?.isMyLocationEnabled = true
        mapView?.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        mapView?.camera = GMSCameraPosition(
            target: location.coordinate,
            zoom: 15,
            bearing: 0,
            viewingAngle: 0)
        
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }
}
