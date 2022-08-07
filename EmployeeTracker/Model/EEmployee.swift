//
//  EEmployee.swift
//  EmployeeTracker
//
//  Created by Digital Ride on 01/08/2022.
//

import Foundation

class EEmployee: NSObject {
    @objc public var EmployeeID: String = ""
    @objc public var EmployeeType: String = TrackingType.Employee.rawValue
    @objc public var EmployeeName: String?
    @objc public var EmployeePassword: String?
    @objc public var IsEmployeeLogedIn: Bool = false
    @objc public var IsEmployeeInBus: Bool = false
    @objc public var CurrentLatitude: Double = 0
    @objc public var CurrentLongitude: Double = 0
    @objc public var AssignedDriverID: String = ""

    override init() {}

    init(dictionary: [String: Any]) {
        super.init()
        EmployeeID = dictionary["EmployeeID"] as! String
        AssignedDriverID = dictionary["AssignedDriverID"] as! String
        EmployeeType = dictionary["EmployeeType"] as! String
        EmployeeName = dictionary["EmployeeName"] as? String
        EmployeePassword = dictionary["EmployeePassword"] as? String
        IsEmployeeLogedIn = dictionary["IsEmployeeLogedIn"] as! Bool
        IsEmployeeInBus = dictionary["IsEmployeeInBus"] as! Bool
        CurrentLatitude = dictionary["CurrentLatitude"] as! Double
        CurrentLongitude = dictionary["CurrentLongitude"] as! Double
       
    }
    
}
