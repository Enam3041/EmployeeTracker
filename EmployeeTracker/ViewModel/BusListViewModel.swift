//
//  EmployeeListViewModel.swift
//  EmployeeTracker
//
//  Created by Digital Ride on 04/08/2022.
//

import Foundation

class BusListViewModel {
    
    var numberOfBuses: Int { return buses.count }
    
    var didUpdateBuses:    (([EBus]) -> ())?

    var buses: [EBus] = [] {
        didSet {
            didUpdateBuses?(buses)
        }
    }
    
    func getBuses(){
        buses = CoreDataStack.shared.getBuses() ?? []
    }
    
    func bus(at index: Int) -> EBus? {
        guard index < buses.count else { return nil }
        return buses[index]
    }
    
    func viewModelForBus(at index: Int) -> BusViewModel? {
        guard let bus = self.bus(at: index) else { return nil }
        return BusViewModel(bus: bus)
    }
}
