//
//  LoginViewModel.swift
//  EmployeeTracker
//
//  Created by Digital Ride on 31/07/2022.
//

import UIKit
import Foundation


enum ValidationState{
    case Valid
    case Invalid(String)
}

struct ValidationRule {
    var propertyName: String
    var message: String
}

protocol ViewModel {
    var validationRules: [ValidationRule]{get set}
    var isValid: Bool{mutating get}
}

protocol Validation {
    func validate()-> ValidationState
}

class LoginViewModel {
    
    private let networkService: NetworkService

      private let phoneNumberLength = 11
      var EmployeeID:String = ""
      var EmployeePassword:String = ""
    
      init(networkService: NetworkService) {
            self.networkService = networkService
        }


}

extension LoginViewModel: Validation{
    func validate() -> ValidationState {
        if self.EmployeeID.count == 0  {
            return .Invalid("Please enter employye ID")
        }
        if self.EmployeePassword.count == 0  {
            return .Invalid("Please enter password")
        }
        return .Valid
              
    }
    
    func validatePhoneNumber() -> ValidationState {
        if self.EmployeeID.count == 0  {
            return .Invalid("Please enter phone number")
        }
        
        return .Valid
    }
    

    func passwordValidation(_ password: String)-> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let pred = NSPredicate(format:"SELF MATCHES %@" , passwordRegex)
        return pred.evaluate(with: password)
    }

    func updateUserInputPhone(_ phone: String){
        self.EmployeeID = phone
    }
    
    func updateuserInputPassword(_ password: String){
        self.EmployeePassword = password
    }
    
    func login(completion: @escaping(EEmployee?)->Void){
        networkService.getEmployee(with: EmployeeID, password: EmployeePassword) { employee in
            completion(employee)
        }
      
       }
   }
