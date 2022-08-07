//
//  EmployeeViewModel.swift
//  EmployeeTracker
//
//  Created by Digital Ride on 04/08/2022.
//

import Foundation

struct BusViewModel {
    
    let bus : EBus

    var name: String {
        return bus.BusName ?? ""
    }
    
    var departureTime: String {
        return bus.DepartureTime!.getTimeInHoursAndMins()
    }
  
  
}
