//
//  LoginVC.swift
//  EmployeeTracker
//
//  Created by Digital Ride on 31/07/2022.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var txtEmployeeID: BindingTextField!{
           didSet{
               self.txtEmployeeID.bind {self.loginViewModel.EmployeeID = $0 }
           }
       }
    
       @IBOutlet weak var txtPassword: BindingTextField!{
           didSet{
               self.txtPassword.bind {self.loginViewModel.EmployeePassword = $0 }
           }
       }
    
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var viewPhoneNumber: UIView!
    @IBOutlet weak var viewPassword: UIView!
    
    
    var selectedTextField: UITextField?
    let networkService = NetworkService()
    var loginViewModel : LoginViewModel!

    
    override func viewWillLayoutSubviews() {
       
        viewPhoneNumber.layer.cornerRadius = viewPhoneNumber.frame.height / 2
        viewPhoneNumber.clipsToBounds = true
        
        viewPassword.layer.cornerRadius = viewPhoneNumber.frame.height / 2
        viewPassword.clipsToBounds = true
        
        btnLogin.layer.cornerRadius = btnLogin.frame.height / 2
        btnLogin.clipsToBounds = true
    }

    
    override func viewDidLoad() {
      super.viewDidLoad()
        txtEmployeeID.setLeftPadding(10)
        txtEmployeeID.setRightPadding(10)
        txtPassword.setLeftPadding(10)
        txtPassword.setRightPadding(10)

        loginViewModel = LoginViewModel(networkService: networkService)
        
        txtEmployeeID.attributedPlaceholder = NSAttributedString(string: "EmployeeID",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x85d5cc)])
        
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x85d5cc)])
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0{
                    self.view.frame.origin.y -= keyboardSize.height
                }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y = 0
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func tapGestureAction(_ sender: UITapGestureRecognizer) {
        if let textField = selectedTextField {
            textField.resignFirstResponder()
            selectedTextField = nil
        }
      
    }
    
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        switch loginViewModel.validate() {
        case .Valid:
            loginViewModel.login { employee in
                DispatchQueue.main.async(execute: {
                 if let _employee = employee{
                     if CoreDataStack.shared.saveEmployee(_employee){
                         let empTrackingVC = Constants.mainStoryBoard.instantiateViewController(withIdentifier: "BusTrackingMapVC") as! BusTrackingMapVC
                         let nav = UINavigationController(rootViewController: empTrackingVC)
                         nav.modalPresentationStyle = .fullScreen
                         self.present(nav, animated: false)
                     }
                 }else{
                     AlertView.shared.showAlert(with: "No employee  found with this credentials")
                 }
             })
            }
           
        case .Invalid(let error):
            AlertView.shared.showAlert(with: error)
        }
    }
    
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
  
  }


extension LoginVC:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
