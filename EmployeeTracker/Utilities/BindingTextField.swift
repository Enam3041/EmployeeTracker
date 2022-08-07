//
//  BindingTextField.swift
//  EmployeeTracker
//
//  Created by Digital Ride on 01/08/2022.
//

import Foundation
import UIKit
class BindingTextField: UITextField {
    
    var textChanged: (String)->() = {_ in}
    
    func bind(callBack: @escaping(String)->()) {
        textChanged = callBack
        self.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        textChanged(textField.text!)
    }
  }
