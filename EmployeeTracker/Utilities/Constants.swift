//
//  Constants.swift
//  EmployeeTracker
//
//  Created by Digital Ride on 01/08/2022.
//

import Foundation
import UIKit
import CoreLocation

struct Constants {
    static let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
    static let capacityOfBus = 50
    static let runAlgorithmAfter:TimeInterval = 5*60 //seconds
    static let arrivedDiameter = 5 //meter
    static let maximumWaitingTime = 25 //minutes
    static let timeToReachDestination = 20 //minutes
    static var startBusAt = Date().setTime(hour: 7, min: 0)
    static let busStopageLocation:CLLocation = CLLocation(latitude: 23.8007, longitude: 90.4262)
    static let destinationLocation:CLLocation = CLLocation(latitude: 23.7947473, longitude: 90.4250696)


}


