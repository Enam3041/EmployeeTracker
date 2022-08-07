//
//  SceneDelegate.swift
//  EmployeeTracker
//
//  Created by Digital Ride on 28/07/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

            window = UIWindow(frame: windowScene.coordinateSpace.bounds)
            window?.windowScene = windowScene
            gotoInitialScreen()
           
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
       
        CoreDataStack.shared.saveContext()
    }


}

extension SceneDelegate{
    func gotoInitialScreen() {
        if Utility.getCurrentEmploye() != nil{
                let busTrackingVC = Constants.mainStoryBoard.instantiateViewController(withIdentifier: "BusTrackingMapVC") as! BusTrackingMapVC
                let nav = UINavigationController(rootViewController: busTrackingVC)
                window?.rootViewController = nav
                self.window?.makeKeyAndVisible()
            
        }else if  PersistanceStore.shared.isTracking{
            let empTrackingVC = Constants.mainStoryBoard.instantiateViewController(withIdentifier: "EmployeeTrackingMapVC") as! EmployeeTrackingMapVC
            let nav = UINavigationController(rootViewController: empTrackingVC)
            window?.rootViewController = nav
            self.window?.makeKeyAndVisible()
        }
        else{
                let empTrackingVC = Constants.mainStoryBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                let nav = UINavigationController(rootViewController: empTrackingVC)
                window?.rootViewController = nav
                self.window?.makeKeyAndVisible()
                    
            }
        }
}

