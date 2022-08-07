//
//  CoreDataStack.swift
//  EmployeeTracker
//
//  Created by Digital Ride on 01/08/2022.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    private init() {}
    
    var mainContext: NSManagedObjectContext {
        container.viewContext
    }
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EmployeeTracker")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        guard mainContext.hasChanges else { return }
        
        mainContext.performAndWait {
            do {
                try mainContext.save()
            } catch let error as NSError {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
 
    func getManagedObejectFromEntity(_ managedObject: NSManagedObject,_ entityObject: NSObject )->NSManagedObject{
        
        if entityObject is EEmployee {
            let manageObj = managedObject as! Employee
            let entityObj = entityObject as! EEmployee
            
            manageObj.employeeID = entityObj.EmployeeID
            manageObj.isEmployeeLogedIn = entityObj.IsEmployeeLogedIn
            manageObj.isEmployeeInBus = entityObj.IsEmployeeInBus
            manageObj.employeeType = entityObj.EmployeeType
            manageObj.employeePassword = entityObj.EmployeePassword
            manageObj.employeeName = entityObj.EmployeeName
            manageObj.currentLatitude = entityObj.CurrentLatitude
            manageObj.currentLongitude = entityObj.CurrentLongitude
            
            return manageObj
            
        }else if entityObject is EBus {
            let manageObj = managedObject as! BBus
            let entityObj = entityObject as! EBus
            
            manageObj.busID = entityObj.BusID
            manageObj.busName = entityObj.BusName
            manageObj.isLeft = entityObj.IsLeft
            manageObj.numberOfOccupiedEmp = Int32(entityObj.NumberOfOccupiedEmp)
            manageObj.departureTime = entityObj.DepartureTime
             
            return manageObj
        }
        return NSManagedObject.init()

    }

    func getEntityFromManagedObeject(_ managedObject: NSManagedObject)->NSObject{
        
        if managedObject is Employee {
            let manageObj = managedObject as! Employee
            let entityObj = EEmployee()
            
            entityObj.EmployeeID = manageObj.employeeID ?? ""
            entityObj.IsEmployeeLogedIn = manageObj.isEmployeeLogedIn
            entityObj.IsEmployeeInBus = manageObj.isEmployeeInBus
            entityObj.EmployeePassword = manageObj.employeePassword
            entityObj.EmployeeName = manageObj.employeeName
            entityObj.EmployeeType = manageObj.employeeType
            entityObj.CurrentLatitude = manageObj.currentLatitude
            entityObj.CurrentLongitude = manageObj.currentLongitude
            
            return entityObj
        }else if managedObject is BBus {
            let manageObj = managedObject as! BBus
            let entityObj = EBus()
            
            entityObj.BusID = manageObj.busID ?? ""
            entityObj.BusName = manageObj.busName
            entityObj.DepartureTime = manageObj.departureTime
            entityObj.IsLeft = manageObj.isLeft
            entityObj.NumberOfOccupiedEmp = Int(manageObj.numberOfOccupiedEmp)
             
            return entityObj
        }
        return NSObject.init()
        
    }
    
    // MARK: -EmployeeModel
    
    func saveEmployee(_ eEmployee: EEmployee)->Bool {
        var isSuccess = true
        let context = self.mainContext

        let entity = NSEntityDescription.entity(forEntityName: "Employee",in: context)!
        var employee  = Employee.init(entity: entity, insertInto: context)
        employee = self.getManagedObejectFromEntity(employee, eEmployee) as! Employee
            
        do {
            try context.save()
        } catch let error as NSError {
            isSuccess = false
            print("Could not save. \(error), \(error.userInfo)")
        }
        return isSuccess

    }
    
    func getEmployee() -> EEmployee? {
        let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
        
        do {
            let employee = try self.mainContext.fetch(fetchRequest).first
            if let _employee = employee{
                return self.getEntityFromManagedObeject(_employee) as? EEmployee
            }else{
                return nil
            }
        } catch let error as NSError {
            print("Error fetching: \(error), \(error.userInfo)")
        }
        
        return nil
    }
    
    
    // MARK: -BusModel
    
    func saveBuses(_ buses: [EBus])->Bool {
        var isSuccess = true
        let context = self.mainContext
        for eBus in buses {
            let entity = NSEntityDescription.entity(forEntityName: "BBus",in: context)!
            var bus  = BBus.init(entity: entity, insertInto: context)
            bus = self.getManagedObejectFromEntity(bus, eBus) as! BBus
        }
        do {
            try context.save()
        } catch let error as NSError {
            isSuccess = false
            print("Could not save. \(error), \(error.userInfo)")
        }
        return isSuccess

    }
    
    
    func upadteBus(with name:String,numberOfOccupiedEmp:Int,departureTime:Date?)->Bool{
        let fetchRequest: NSFetchRequest<BBus> = BBus.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startDate, endDate)
        fetchRequest.predicate = NSPredicate(format: "busName == %@", name)

        let sort = NSSortDescriptor(key: #keyPath(BBus.busName), ascending: true)
          fetchRequest.sortDescriptors = [sort]
        do {
            let buses = try self.mainContext.fetch(fetchRequest)
            if buses.count > 0 {
                let bus = buses.first!
                bus.numberOfOccupiedEmp = Int32(numberOfOccupiedEmp)
                if let departureTime = departureTime{
                    bus.departureTime = departureTime
                }
            }
            do {
                try self.mainContext.save()
            } catch let error as NSError {
                return false
                print("Could not save. \(error), \(error.userInfo)")
            }
          return true
        } catch let error as NSError {
            print("Error fetching: \(error), \(error.userInfo)")
        }
        
        return true
    }
    
    func getBuses() -> [EBus]? {
        var allBus:[EBus] = []
        let fetchRequest: NSFetchRequest<BBus> = BBus.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(BBus.busName), ascending: true)
          fetchRequest.sortDescriptors = [sort]
        do {
            let buses = try self.mainContext.fetch(fetchRequest)
            for bus in buses {
                allBus.append(self.getEntityFromManagedObeject(bus) as! EBus)
            }
          return allBus
        } catch let error as NSError {
            print("Error fetching: \(error), \(error.userInfo)")
        }
        
        return allBus
    }
    
    func getBus(with name:String) -> EBus? {
        let fetchRequest: NSFetchRequest<BBus> = BBus.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startDate, endDate)
        fetchRequest.predicate = NSPredicate(format: "busName == %@", name)

        let sort = NSSortDescriptor(key: #keyPath(BBus.busName), ascending: true)
          fetchRequest.sortDescriptors = [sort]
        do {
            let buses = try self.mainContext.fetch(fetchRequest)
            if buses.count > 0 {
                return self.getEntityFromManagedObeject(buses.first!) as? EBus
            }
            
          return nil
        } catch let error as NSError {
            print("Error fetching: \(error), \(error.userInfo)")
        }
        
        return nil
    }

    
}
