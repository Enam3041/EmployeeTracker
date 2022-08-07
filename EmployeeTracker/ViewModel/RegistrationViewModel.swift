//
//  RegistrationViewModel.swift
//  EmployeeTracker
//
//  Created by Digital Ride on 02/08/2022.
//

import UIKit
import Foundation



class RegistrationViewModel {
    
    private let networkService: NetworkService

      var EmployeeID:String = ""
      var EmployeeName:String = ""
      var Password:String = ""
      var trackingType:String = TrackingType.Employee.rawValue
      var driverSchedule:String = ""

      init(networkService: NetworkService) {
            self.networkService = networkService
        }
    
      
}

extension RegistrationViewModel: Validation{
    func validate() -> ValidationState {
        if self.EmployeeID.count == 0  {
            return .Invalid("Please enter employee ID")
        }
        
        if self.Password.count == 0  {
            return .Invalid("Please enter password")
        }
        return .Valid
              
    }
    
    func validatePhoneNumber() -> ValidationState {
        if self.EmployeeID.count == 0  {
            return .Invalid("Please enter employee ID")
        }
        
        return .Valid
    }
    

    func passwordValidation(_ password: String)-> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let pred = NSPredicate(format:"SELF MATCHES %@" , passwordRegex)
        return pred.evaluate(with: password)
    }

    func updateUserInputEmployeeID(_ phone: String){
        self.EmployeeID = phone
    }

    var employeDict:[String:Any] {
        return ["EmployeeID":EmployeeID,"EmployeeType":trackingType,"EmployeeName":EmployeeName,"EmployeePassword":Password,"IsEmployeeLogedIn":true,"IsEmployeeInBus":false,"CurrentLatitude":trackingType == TrackingType.Employee.rawValue ? LocationManager.shared.lastLocation.coordinate.latitude : 23.7974 ,"CurrentLongitude": trackingType == TrackingType.Employee.rawValue ? LocationManager.shared.lastLocation.coordinate.longitude : 90.4237 ,"driverSchedule":driverSchedule,"AssignedDriverID":""]
    }
    
    var employee:EEmployee{
        let emp = EEmployee()
        emp.EmployeeID = EmployeeID
        emp.EmployeeType = trackingType
        emp.EmployeeName = EmployeeName
        emp.EmployeePassword = Password
        emp.IsEmployeeLogedIn = true
        emp.IsEmployeeInBus = false
        return emp
    }
    
    func updateEmployeeTrackingType(_ trackingType: TrackingType){
        self.trackingType = trackingType.rawValue
     }
 
    func updateDriverSchedule(_ driverSchedule: String){
          self.driverSchedule = driverSchedule
    }
    
    func register(completion: @escaping(EEmployee?)->Void){
        networkService.addEmployee(employeeID: EmployeeID, employeeDict: employeDict) { isSuccess in
            
            if isSuccess{
                completion(self.employee)
            }else{
                completion(nil)
            }
        }
    }
    
    func isAlreadyRegistered(completion: @escaping(Bool)->Void){
        networkService.isAlreadyRegistered(with: EmployeeID) { isRegisterd in
            completion(isRegisterd)
        }
    }
}
