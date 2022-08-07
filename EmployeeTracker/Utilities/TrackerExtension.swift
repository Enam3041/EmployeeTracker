//
//  TrackerExtension.swift
//  EmployeeTracker
//
//  Created by Digital Ride on 05/08/2022.
//

import Foundation
import UIKit

   protocol Dateable {
        func getTimeInHoursAndMins() -> String
        func setTime(hour: Int, min: Int)-> Date
    }

    extension Date: Dateable {

        func getTimeInHoursAndMins() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: self)
        }
        
        func setTime(hour: Int, min: Int) -> Date {
            let x: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
            let cal = Calendar.current
            var components = cal.dateComponents(x, from: self)

            components.hour = hour
            components.minute = min
            
            return cal.date(from: components) ?? Date()
        }

    }

extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    convenience init(rgb: UInt, alpha: CGFloat) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}


extension UIApplication {
    
    var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
   
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
       if let navigationController = controller as? UINavigationController {
           return topViewController(controller: navigationController.visibleViewController)
       }
       if let tabController = controller as? UITabBarController {
           if let selected = tabController.selectedViewController {
               return topViewController(controller: selected)
           }
       }
       if let presented = controller?.presentedViewController {
           return topViewController(controller: presented)
       }
       
       return controller
   }
}


extension UITextField {
    func setLeftPadding(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPadding(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}


