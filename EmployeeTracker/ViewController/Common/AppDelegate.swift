//
//  AppDelegate.swift
//  EmployeeTracker
//
//  Created by Digital Ride on 28/07/2022.
//

import UIKit
import CoreData
import FirebaseCore
import GoogleMaps
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        basicConfigure()
        if CoreDataStack.shared.getBuses()?.count == 0{
            Utility.addBusesData()
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
       
    }

}

extension AppDelegate{
    func basicConfigure(){
        
        FirebaseApp.configure()
        GMSServices.provideAPIKey(GoogleKeys.ServiceAPIKey.rawValue)
        GMSPlacesClient.provideAPIKey(GoogleKeys.ServiceAPIKey.rawValue)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            LocationManager.shared.getLocation()            // Ask to enable location service
        }
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
}
