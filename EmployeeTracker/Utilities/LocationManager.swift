//
//  LocationManager.swift
//  EmployeeTracker
//
//  Created by Digital Ride on 02/08/2022.
//

import Foundation
import CoreLocation


class LocationManager: NSObject {
    static let shared : LocationManager = LocationManager()

    typealias LocationManagerCallback = (_ location: CLLocation?) -> Void
    
    var lastLocationUpdatedTimeStamp:Date?
    var lastLocation: CLLocation = CLLocation()
    var previousLocation: CLLocation = CLLocation()
    var locationManagerCallback: LocationManagerCallback?

    
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        // _locationManager.requestAlwaysAuthorization()
        _locationManager.pausesLocationUpdatesAutomatically = false
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
      _locationManager.allowsBackgroundLocationUpdates = true
     // _locationManager.distanceFilter = 10.0

        return _locationManager
    }()
    
    func startUpdatingLocation() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
                locationManager.allowsBackgroundLocationUpdates = true
                locationManager.startUpdatingLocation()
                locationManager.startMonitoringVisits()
                locationManager.startMonitoringSignificantLocationChanges()
        }else{
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func stopUpdatingLocation()  {
        locationManager.allowsBackgroundLocationUpdates = false
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringVisits()
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    //TODO: To get permission is allowed or declined
    func checkStatus() -> CLAuthorizationStatus{
        return CLLocationManager.authorizationStatus()
    }
    
    func getLocation() {
        locationManager.requestWhenInUseAuthorization()
        //locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()
            }
    }
    
    
    func locateMeOnLocationChange(callback: @escaping LocationManagerCallback) {
        self.locationManagerCallback = callback
//        if lastLocation == nil {
//            enableLocationServices()
//        } else {
           callback(lastLocation)
       // }
    }
}

extension LocationManager: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        previousLocation = lastLocation
        lastLocation = location
        
        
        let now:Date = Date()
        var interval:TimeInterval = 0

        if let _lastLocationUpdatedTimeStamp = lastLocationUpdatedTimeStamp{
            interval = now.timeIntervalSince(_lastLocationUpdatedTimeStamp)
            
            if (interval >= 60)
                {
                    self.lastLocationUpdatedTimeStamp = now
                if let emp = Utility.getCurrentEmploye(){
                    self.lastLocationUpdatedTimeStamp = now
                    emp.CurrentLatitude = location.coordinate.latitude
                    emp.CurrentLongitude = location.coordinate.longitude

                NetworkService().updateEmployeeLocation(employee: emp) { status in
                    if status {
                      debugPrint("successfully updated")
                    }
                }
            }
        }
    }
 
         
         if let locationManagerCallback = self.locationManagerCallback{
             locationManagerCallback(location)
           //  completion(location.coordinate)
         }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError: Error) {
        print("Error")
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status {
            
        case .denied:
            print("Permission Denied")
            break
        case .notDetermined:
            print("Permission Not Determined G")
            break
            
        default:
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.startUpdatingLocation()
            break
        }
    }
}
