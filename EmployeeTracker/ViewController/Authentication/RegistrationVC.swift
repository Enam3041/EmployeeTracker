//
//  RegistrationVC.swift
//  EmployeeTracker
//
//  Created by Digital Ride on 01/08/2022.
//

import UIKit

class RegistrationVC: UIViewController {
    
    @IBOutlet weak var btnSchedule: UIButton!
    @IBOutlet weak var txtEmployeeID: BindingTextField!{
           didSet{
               self.txtEmployeeID.bind {self.registrationViewModel.EmployeeID = $0 }
           }
       }
    
       @IBOutlet weak var txtEmployeeName: BindingTextField!{
           didSet{
               self.txtEmployeeName.bind {self.registrationViewModel.EmployeeName = $0 }
           }
       }
    
    @IBOutlet weak var txtPassword: BindingTextField!{
        didSet{
            self.txtPassword.bind {self.registrationViewModel.Password = $0 }
        }
    }
    
    @IBOutlet weak var btnCreate: UIButton!
    
    var registrationViewModel : RegistrationViewModel!
    let networkService = NetworkService()
    var trackingType:TrackingType!
    var selectedTextField: UITextField?
    var driverSchedule:String = ""

    override func viewWillLayoutSubviews() {
       applyCornerRadious()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTxtFieldPadding()
        setupScheduleOption()
        registrationViewModel = RegistrationViewModel(networkService: networkService)
        if trackingType == .Employee {
            btnSchedule.isHidden = true
        }else{
            driverSchedule = Schedule.Bus0720.rawValue
        }
                
        txtEmployeeID.attributedPlaceholder = NSAttributedString(string: "EmployeeID",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x85d5cc)])
        
        txtEmployeeName.attributedPlaceholder = NSAttributedString(string: "Employee Name",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x85d5cc)])
        
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x85d5cc)])

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    func applyCornerRadious(){
        btnSchedule.layer.cornerRadius = 10
        btnSchedule.clipsToBounds = true
        txtEmployeeID.layer.cornerRadius = 10
        txtEmployeeID.clipsToBounds = true
        txtEmployeeName.layer.cornerRadius = 10
        txtEmployeeName.clipsToBounds = true
        txtPassword.layer.cornerRadius = 10
        txtPassword.clipsToBounds = true
        btnCreate.layer.cornerRadius = 10
        btnCreate.clipsToBounds = true
    }
    
    func configureTxtFieldPadding(){
        txtEmployeeName.setLeftPadding(20)
        txtEmployeeName.setRightPadding(20)
        txtEmployeeID.setLeftPadding(20)
        txtEmployeeID.setRightPadding(20)
        txtPassword.setLeftPadding(20)
        txtPassword.setRightPadding(20)
    }
    
    func setupScheduleOption(){
        let optionsClosure = { (action: UIAction) in
            print(action.title)
            self.driverSchedule =  action.title
          }
        btnSchedule.menu = UIMenu(children: [
            UIAction(title: Schedule.Bus0720.rawValue, state: .on, handler: optionsClosure),
            UIAction(title: Schedule.Bus0740.rawValue, handler: optionsClosure),
            UIAction(title: Schedule.Bus0750.rawValue, handler: optionsClosure),
            UIAction(title: Schedule.Bus0800.rawValue, handler: optionsClosure)

          ])
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
    
    @IBAction func registerButtonAction(_ sender: UIButton) {
        registrationViewModel.updateDriverSchedule(driverSchedule)
        registrationViewModel.updateEmployeeTrackingType(trackingType)

        
        switch registrationViewModel.validate() {
        case .Valid:
            registrationViewModel.isAlreadyRegistered { isRegistered in
                if isRegistered {
                    AlertView.shared.showAlert(with: "Already Registered. Please try with another ID")
                }else{
                    self.registrationViewModel.register { employee in
                        DispatchQueue.main.async(execute: {
                         if let _employee = employee{
                             if CoreDataStack.shared.saveEmployee(_employee){
                                 let empTrackingVC = Constants.mainStoryBoard.instantiateViewController(withIdentifier: "BusTrackingMapVC") as! BusTrackingMapVC
                                 let nav = UINavigationController(rootViewController: empTrackingVC)
                                 nav.modalPresentationStyle = .fullScreen
                                 self.present(nav, animated: false)
                             }
                         }else{
                             AlertView.shared.showAlert(with: "Something went wrong.")
                         }
                     })
                    }
                }
            }
           
        case .Invalid(let error):
            AlertView.shared.showAlert(with: error)
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}


extension RegistrationVC:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
