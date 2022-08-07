//
//  EmployeeTrackingMapVC.swift
//  EmployeeTracker
//
//  Created by Digital Ride on 02/08/2022.
//

import UIKit
import GoogleMaps

class BusTrackingMapVC: UIViewController {
    
    @IBOutlet weak var trackingMapView: GMSMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setBusStandLocation()
    }
        
        
    func setupUI(){
        self.trackingMapView?.isMyLocationEnabled = true
        self.trackingMapView.delegate = self
        self.perform(#selector(self.setBusStandLocation), with: self, afterDelay: 1.0)
    }
   
    
    @objc func setBusStandLocation(){
        
        guard LocationManager.shared.checkStatus() != .denied else {
            AlertView.shared.showAlert(title: "Location Settings", message: "Do yo want to enable location service?") { respon in
                if respon{
                    Utility.goToSettings()
                }
            }
            return
        }
      //Notun Bazar bus stopage coordinate
        let cameraUpdate = GMSCameraUpdate.setTarget( Constants.busStopageLocation.coordinate, zoom: 12)
        self.trackingMapView.moveCamera(cameraUpdate)
        
        let camera = GMSCameraPosition.camera(withLatitude:  Constants.busStopageLocation.coordinate.latitude, longitude:  Constants.busStopageLocation.coordinate.longitude, zoom: 15,bearing: 0,viewingAngle: 0)


            CATransaction.begin()
        CATransaction.setAnimationDuration(0.5)
            self.trackingMapView.animate(to: camera)
            CATransaction.commit()
        
        setBusStopageAndDestinationOnMap()

    }
    
        
    func setBusStopageAndDestinationOnMap(){
        let busStopagePin = GMSMarker()
        busStopagePin.position = Constants.busStopageLocation.coordinate
        busStopagePin.icon = UIImage(named: "bus_stop")
        busStopagePin.isTappable = true
        busStopagePin.map = self.trackingMapView
        
        
        let destinationPin = GMSMarker()
        destinationPin.isTappable = true
        destinationPin.position = Constants.destinationLocation.coordinate

        if let infoView = Bundle.main.loadNibNamed("MarkerInfoView", owner: nil, options: nil)?.first as? UIView as? MarkerInfoView  {
            infoView.addressLabel.text = "BJIT Head Office"
            infoView.markerImageView.image = UIImage.init(named: "office_location")
            destinationPin.iconView = infoView
      }

        destinationPin.map = trackingMapView
        
    }
}


extension BusTrackingMapVC : GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        self.trackingMapView.selectedMarker = marker
    }
}

