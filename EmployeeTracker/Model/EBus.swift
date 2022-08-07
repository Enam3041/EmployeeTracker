//
//  EBus.swift
//  EmployeeTracker
//
//  Created by Digital Ride on 06/08/2022.
//

import Foundation
class EBus: NSObject {
    @objc public var BusID: String = ""
    @objc public var DepartureTime: Date?
    @objc public var BusName: String?
    @objc public var IsLeft: Bool = false
    @objc public var NumberOfOccupiedEmp: Int = 0

    init(busID:String,departureTime:Date,busName:String,isLeft:Bool,numberOfOccupiedEmp:Int) {
        self.BusID = busID
        self.DepartureTime = departureTime
        self.BusName = busName
        self.IsLeft = isLeft
        self.NumberOfOccupiedEmp = numberOfOccupiedEmp

    }

    override init() {}

    init(dictionary: [String: Any]) {
        super.init()
        BusID = dictionary["BusID"] as! String
        DepartureTime = dictionary["DepartureTime"] as? Date
        BusName = dictionary["BusName"] as? String
        NumberOfOccupiedEmp = dictionary["NumberOfOccupiedEmp"] as! Int
        IsLeft = dictionary["IsLeft"] as! Bool
        
    }
    
}
