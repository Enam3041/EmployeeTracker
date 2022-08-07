//
//  EmployeeTrackingMapVC.swift
//  EmployeeTracker
//
//  Created by Digital Ride on 02/08/2022.
//

import UIKit
import GoogleMaps

class EmployeeTrackingMapVC: UIViewController {

    @IBOutlet weak var trackingMapView: GMSMapView!
    var busListVC:BusListPageSheet!
    
    var arrMarker               : [GMSMarker] = []
    var locatiopnUpdateTimer = Timer()

    var viewModel : EmployeeTrackingMapViewModel!
    
    deinit{
        self.locatiopnUpdateTimer.invalidate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.locatiopnUpdateTimer = Timer.scheduledTimer(timeInterval: Constants.runAlgorithmAfter, target: self, selector: #selector(getEmployees), userInfo: nil, repeats: true)
        viewModel = EmployeeTrackingMapViewModel(networkService: NetworkService())
        viewModel.didUpdateEmployees = { [weak self] (employees) in
            self?.setEmployeeLocationOnMap(employees)
        }
        getEmployees()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presentEmployeeListVC()

    }
    
   @objc func getEmployees(){
        viewModel.getEmployees()
    }
    
        
    func setupUI(){
        self.trackingMapView?.isMyLocationEnabled = true
        self.trackingMapView.delegate = self
        self.perform(#selector(self.setBusStandLocation), with: self, afterDelay: 1.0)
    }
    
    func presentEmployeeListVC(){
        busListVC = Constants.mainStoryBoard.instantiateViewController(withIdentifier: "BusListPageSheet") as? BusListPageSheet
        busListVC.isModalInPresentation = true

        if #available(iOS 15.0, *) {
            if let sheet = busListVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.selectedDetentIdentifier = .medium
                sheet.largestUndimmedDetentIdentifier = .medium
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.preferredCornerRadius = 20
                sheet.prefersGrabberVisible = true
            }
        } else {
            // Fallback on earlier versions
        }
        busListVC.modalPresentationStyle = .pageSheet
        busListVC.headerTapGesture.addTarget(self, action: #selector(toggleEmpListView))
        self.present(busListVC, animated: true, completion: nil)

    }
    
    @objc func toggleEmpListView(){
        if let sheet = busListVC.sheetPresentationController {
            if sheet.selectedDetentIdentifier == .large {
                sheet.animateChanges {
                    sheet.selectedDetentIdentifier = .medium
                }
            }else{
                sheet.animateChanges {
                    sheet.selectedDetentIdentifier = .large
                }
            }
        }
    }
    
    func changeDentToMedium(){
        if let sheet = busListVC.sheetPresentationController {
               sheet.animateChanges {
                   sheet.selectedDetentIdentifier = .medium
               }
           }
    }
    
    func changeDentToLarge(){
        if let sheet = busListVC.sheetPresentationController {
               sheet.animateChanges {
                   sheet.selectedDetentIdentifier = .large
               }
           }
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
    
    
    @objc func setEmployeeLocationOnMap(_ employees:[EEmployee]){
        trackingMapView.clear()
        var arrivedEmployees:[EEmployee] = []

        for employee in employees {
            let pin = GMSMarker()
            pin.position = CLLocationCoordinate2D(latitude: employee.CurrentLatitude , longitude: employee.CurrentLongitude )
            pin.icon = UIImage(named: "employee_location")
            pin.isTappable = true
            self.arrMarker.append(pin)
            pin.map = self.trackingMapView
          
            setBusStopageAndDestinationOnMap()
            
            if Utility.needTracking() {
                let dist = Constants.busStopageLocation.distance(from: CLLocation(latitude: employee.CurrentLatitude, longitude: employee.CurrentLongitude))// distance in Meter
                if dist <= 5 {
                    employee.IsEmployeeInBus = true
                    arrivedEmployees.append(employee)
                }
            }
          
        }
        
        if Utility.needTracking() {
          if arrivedEmployees.count > 0 {
             viewModel.checkScheduleForDeparture(arrivedEmployees)
         }
            busListVC.lblTotalOccupied.text = "Total: \(PersistanceStore.shared.totalEmployeeCount)"
            busListVC.lblCurrentOccupied.text = "\(PersistanceStore.shared.employeeCountForCurrentBus): \(PersistanceStore.shared.employeeCountForCurrentBus)"
            busListVC.viewModel.getBuses()
        }else{
            busListVC.lblTotalOccupied.text = "Total: 0"
            busListVC.lblCurrentOccupied.text = "\(PersistanceStore.shared.employeeCountForCurrentBus): 0"
        }
    }
    
    func setBusStopageAndDestinationOnMap(){
        let busStopagePin = GMSMarker()
        busStopagePin.position = Constants.busStopageLocation.coordinate
        busStopagePin.icon = UIImage(named: "bus_stop")
        busStopagePin.isTappable = true
        self.arrMarker.append(busStopagePin)
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


extension EmployeeTrackingMapVC : GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        self.trackingMapView.selectedMarker = marker
    }
}

