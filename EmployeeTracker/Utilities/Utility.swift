//
//  Utility.swift
//  EmployeeTracker
//
//  Created by Digital Ride on 03/08/2022.
//

import Foundation
import UIKit

class Utility: NSObject {

    static var employee: EEmployee? = nil
    static var currentScheduleBus: EBus? = nil

    class func getCurrentEmploye()->EEmployee?{
       if employee == nil {
           employee = CoreDataStack.shared.getEmployee()
         return employee
    }
     return employee
}

   class func setCurrentEmploye(){
       employee = nil
 }
    
    class func getCurrentScheduleBus()->EBus?{
       if currentScheduleBus == nil {
           currentScheduleBus = CoreDataStack.shared.getBus(with: PersistanceStore.shared.currentScheduleBus)
         return currentScheduleBus
    }
     return currentScheduleBus
}
    
    class func setCurrentScheduleBus(){
        currentScheduleBus = nil
  }
    
  class func goToSettings(){
        if let bundleIdentifier = Bundle.main.bundleIdentifier,
            let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleIdentifier)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }

    }

    
    class func addBusesData(){
        var buses:[EBus] = []
        buses.append(EBus.init(busID: "1000000001", departureTime: Date().setTime(hour: 7, min: 20), busName: "Bus 1", isLeft: false, numberOfOccupiedEmp: 0))
        buses.append(EBus.init(busID: "1000000002", departureTime: Date().setTime(hour: 7, min: 30), busName: "Bus 2", isLeft: false, numberOfOccupiedEmp: 0))
        buses.append(EBus.init(busID: "1000000003", departureTime: Date().setTime(hour: 7, min: 50), busName: "Bus 3", isLeft: false, numberOfOccupiedEmp: 0))
        buses.append(EBus.init(busID: "1000000004", departureTime: Date().setTime(hour: 8, min: 00), busName: "Bus 4", isLeft: false, numberOfOccupiedEmp: 0))
        
        if CoreDataStack.shared.saveBuses(buses) {
            debugPrint("successfully saved")
        }
    }
    
   class func checkMaxWaitingTimeForDeparture()-> String?{
        switch PersistanceStore.shared.currentScheduleBus {
        case "Bus 1":
           // PersistanceStore.shared.currentScheduleBus = "Bus 2"
            if Date().setTime(hour: 7, min: 25) > Date() && Date() >  Date().setTime(hour: 7, min: 00){
                return "Bus 1"
            }else if Date().setTime(hour: 7, min: 25) < Date() && Date() >  Date().setTime(hour: 7, min: 00){
               // left Bus 1
                PersistanceStore.shared.currentScheduleBus = "Bus 2"
                return "Bus 2"
            }else if Date().setTime(hour: 7, min: 50) < Date() && Date() >  Date().setTime(hour: 7, min: 00){
                //left 2
                PersistanceStore.shared.currentScheduleBus = "Bus 3"
                return "Bus 3"

            }else if Date().setTime(hour: 7, min: 55) < Date() && Date() >  Date().setTime(hour: 7, min: 00){
                //left 3
                PersistanceStore.shared.currentScheduleBus = "Bus 4"
                return "Bus 4"

            }else if Date().setTime(hour: 8, min: 00) < Date() && Date() >  Date().setTime(hour: 7, min: 00){
                //left 4
                return nil

            }
            
        case "Bus 2":
            if Date().setTime(hour: 7, min: 50) >= Date() && Date() >  Date().setTime(hour: 7, min: 00){
               // left Bus 1
                return "Bus 2"
            }else if Date().setTime(hour: 7, min: 50) < Date() && Date() >  Date().setTime(hour: 7, min: 00){
                //left 2
                PersistanceStore.shared.currentScheduleBus = "Bus 3"
                return "Bus 3"

            }else if Date().setTime(hour: 7, min: 55) < Date() && Date() >  Date().setTime(hour: 7, min: 00){
                //left 3
                PersistanceStore.shared.currentScheduleBus = "Bus 4"
                return "Bus 4"

            }else if Date().setTime(hour: 8, min: 00) < Date() && Date() >  Date().setTime(hour: 7, min: 00){
                //left 4
                return nil

            }
        case "Bus 3":
            if Date().setTime(hour: 7, min: 55) > Date() && Date() >  Date().setTime(hour: 7, min: 00){
                //left 2
                return "Bus 3"

            }else if Date().setTime(hour: 7, min: 55) < Date() && Date() >  Date().setTime(hour: 7, min: 00){
                //left 3
                PersistanceStore.shared.currentScheduleBus = "Bus 4"
                return "Bus 4"

            }else if Date().setTime(hour: 8, min: 00) < Date() && Date() >  Date().setTime(hour: 7, min: 00){
                //left 4
                return nil

            }
        case "Bus 4":
            if Date().setTime(hour: 8, min: 00) > Date() && Date() >  Date().setTime(hour: 7, min: 00){
                //left 3
                return "Bus 4"

            }else if Date().setTime(hour: 8, min: 00) < Date() && Date() >  Date().setTime(hour: 7, min: 00){
                //left 4
                return nil

            }
        default:
           // PersistanceStore.shared.currentScheduleBus = "Bus 4"
            return nil
        }
        
        return "none"
    }
        
   class func getNextScheduleBus(){
        switch PersistanceStore.shared.currentScheduleBus {
        case "Bus 1":
            PersistanceStore.shared.currentScheduleBus = "Bus 2"
            
        case "Bus 2":
            PersistanceStore.shared.currentScheduleBus = "Bus 3"

        case "Bus 3":
            PersistanceStore.shared.currentScheduleBus = "Bus 4"
            
        default:
            PersistanceStore.shared.currentScheduleBus = "Bus 4"

        }
    }
    
    class func shouldLeaveWithVacancy()-> Bool{
         switch PersistanceStore.shared.currentScheduleBus {
         case "Bus 1":
             return Constants.startBusAt.addingTimeInterval(TimeInterval(Constants.maximumWaitingTime*60)) < Date()
             
         case "Bus 2":
             return Constants.startBusAt.addingTimeInterval(TimeInterval(Constants.maximumWaitingTime*60)) < Date()

         case "Bus 3":
             return Constants.startBusAt.addingTimeInterval(TimeInterval(Constants.maximumWaitingTime*60)) < Date() || Date() > Date().setTime(hour: 7, min: 55)

         default:
             return Constants.startBusAt.addingTimeInterval(TimeInterval(Constants.maximumWaitingTime*60)) < Date() || Date() > Date().setTime(hour: 8, min: 05)
         }
     }
    
    class func needTracking()->Bool{
        return Date() >= Date().setTime(hour: 07, min: 00) && Date() <= Date().setTime(hour: 8, min: 05)
    }
    
   class func leaveAndScheduleNextBus(){
        Constants.startBusAt = Date()
        self.getNextScheduleBus()
        PersistanceStore.shared.employeeCountForCurrentBus = 0
    }

}
