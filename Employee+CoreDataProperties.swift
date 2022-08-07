//
//  Employee+CoreDataProperties.swift
//  EmployeeTracker
//
//  Created by Digital Ride on 03/08/2022.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var isEmployeeLogedIn: Bool
    @NSManaged public var employeeName: String?
    @NSManaged public var employeePassword: String?
    @NSManaged public var employeeType: String
    @NSManaged public var employeeID: String?
    @NSManaged public var currentLatitude: Double
    @NSManaged public var currentLongitude: Double
    @NSManaged public var isEmployeeInBus: Bool

}

extension Employee : Identifiable {

}
