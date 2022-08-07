//
//  AlertView.swift
//  EmployeeTracker
//
//  Created by Digital Ride on 01/08/2022.
//

import UIKit

class AlertView {
    
    static let shared = AlertView()
    private init(){}
    
    // MARK: - Alert
    
    func showAlert( with message:String){
        if var topController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            }
            alertController.addAction(okAction)
            topController.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showAlert(title: String , message: String, completion: @escaping (_ respon: Bool) -> Void)
    {
        let attributedString = NSAttributedString(string: "YES", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20) ,NSAttributedString.Key.foregroundColor : UIColor.link
            ])
        
        let alert     : UIAlertController   = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        alert.message                       = message
        alert.title                         = title
        let action_Yes                       = UIAlertAction(title: "YES", style: .default) { (UIAlertAction) in
            completion(true)
        }
        
        alert.view.tintColor = .link
        
        let action_No                   = UIAlertAction(title:"NO", style: .destructive) { (UIAlertAction) in
            completion(false)
        }
        alert.addAction(action_No)

        alert.addAction(action_Yes)
        
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
}



