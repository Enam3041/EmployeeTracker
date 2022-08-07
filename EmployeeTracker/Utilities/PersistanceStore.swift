//
//  PersistanceStore.swift
//  EmployeeTracker
//
//  Created by Digital Ride on 05/08/2022.
//

import Foundation

class PersistanceStore: NSObject {
    static let shared = PersistanceStore()
    let storage = UserDefaults.standard
    
    var isTracking: Bool{
       get{
           let tracking = UserDefaults.standard.bool(forKey: "tracking")
           return tracking
       }
       set(newValue){
           UserDefaults.standard.set(newValue, forKey: "tracking")
           UserDefaults.standard.synchronize()
       }
   }
    
    var employeeCountForCurrentBus: Int{
       get{
           let count = UserDefaults.standard.integer(forKey: "employeeCountForCurrentBus")
           return count == 0 ? 0 : count
       }
       set(newValue){
           UserDefaults.standard.set(newValue, forKey: "employeeCountForCurrentBus")
           UserDefaults.standard.synchronize()
       }
   }
    
    var totalEmployeeCount: Int{
       get{
           let count = UserDefaults.standard.integer(forKey: "totalEmployeeCount")
           return count == 0 ? 0 : count
       }
       set(newValue){
           UserDefaults.standard.set(newValue, forKey: "totalEmployeeCount")
           UserDefaults.standard.synchronize()
       }
   }
    
    
    var currentScheduleBus: String{
       get{
           let bus = UserDefaults.standard.string(forKey: "currentScheduleBus")
           return bus ?? "Bus 1"  
       }
       set(newValue){
           UserDefaults.standard.set(newValue, forKey: "currentScheduleBus")
           UserDefaults.standard.synchronize()
       }
   }
    
    
}
