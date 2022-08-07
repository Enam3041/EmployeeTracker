//
//  Bus+CoreDataProperties.swift
//  EmployeeTracker
//
//  Created by Digital Ride on 06/08/2022.
//
//

import Foundation
import CoreData


extension BBus {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BBus> {
        return NSFetchRequest<BBus>(entityName: "BBus")
    }

    @NSManaged public var busID: String?
    @NSManaged public var departureTime: Date?
    @NSManaged public var busName: String?
    @NSManaged public var numberOfOccupiedEmp: Int32
    @NSManaged public var isLeft: Bool

}

extension BBus : Identifiable {

}
