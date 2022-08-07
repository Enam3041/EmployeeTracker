//
//  ViewController.swift
//  EmployeeTracker
//
//  Created by Digital Ride on 28/07/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btnDriver: UIButton!
    @IBOutlet weak var btnEmployee: UIButton!
    
    override func viewWillLayoutSubviews() {
        btnEmployee.layer.cornerRadius = btnEmployee.frame.height/2
        btnDriver.layer.cornerRadius = btnEmployee.frame.height/2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == nil { return }
        if segue.identifier == "employee" || segue.identifier == "tracking" {
            if segue.identifier == "employee" {
                let registrationVC = segue.destination as! RegistrationVC
                registrationVC.trackingType = .Employee
            }else{
                PersistanceStore.shared.isTracking = true
            }
        }
    }
    

}

