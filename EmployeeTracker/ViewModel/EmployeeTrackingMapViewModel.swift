//
//  EmployeeTrackingMapViewModel.swift
//  EmployeeTracker
//
//  Created by Digital Ride on 06/08/2022.
//

import Foundation

class EmployeeTrackingMapViewModel {
    private let networkService: NetworkService
    var didUpdateEmployees:    (([EEmployee]) -> ())?

    init(networkService: NetworkService) {
          self.networkService = networkService
      }

    var employees: [EEmployee] = [] {
        didSet {
            didUpdateEmployees?(employees)
        }
    }
    
    func getEmployees(){
        networkService.getAllEmployees {[weak self] employees in
            if employees.count > 0{
                self?.employees = employees
            }
        }
    }
    
    func checkScheduleForDeparture(_ emps:[EEmployee]){
        var updatedEmps:[EEmployee] = []
        var isOccupied = false
        for emp in emps {
            PersistanceStore.shared.totalEmployeeCount = PersistanceStore.shared.totalEmployeeCount + 1
            PersistanceStore.shared.employeeCountForCurrentBus = PersistanceStore.shared.employeeCountForCurrentBus + 1
            updatedEmps.append(emp)
            
            if PersistanceStore.shared.employeeCountForCurrentBus == 50 {
                isOccupied = true
                break
            }
        }
        
        if isOccupied {
            //Update & Leave the current buse
            networkService.updateEmployeeOnBatch(employees: updatedEmps) { isUpdated in
                if isUpdated{
                    if CoreDataStack.shared.upadteBus(with: PersistanceStore.shared.currentScheduleBus, numberOfOccupiedEmp: PersistanceStore.shared.employeeCountForCurrentBus, departureTime: Date()) {
                        Utility.leaveAndScheduleNextBus()
                    }
                }
            }
        }else{
            if  Utility.shouldLeaveWithVacancy(){
                networkService.updateEmployeeOnBatch(employees: updatedEmps) { isUpdated in
                    if isUpdated{
                        if CoreDataStack.shared.upadteBus(with: PersistanceStore.shared.currentScheduleBus, numberOfOccupiedEmp: PersistanceStore.shared.employeeCountForCurrentBus, departureTime: Date()) {
                            Utility.leaveAndScheduleNextBus()
                        }
                    }
                }
            }else{
                networkService.updateEmployeeOnBatch(employees: updatedEmps) { isUpdated in
                    if isUpdated{
                        if CoreDataStack.shared.upadteBus(with: PersistanceStore.shared.currentScheduleBus, numberOfOccupiedEmp: PersistanceStore.shared.employeeCountForCurrentBus, departureTime: nil) {
                        }
                    }
                }
            }
        }
    }
        
}
