//
//  NetworkService.swift
//  EmployeeTracker
//
//  Created by Digital Ride on 01/08/2022.
//

import Foundation
import FirebaseFirestore


 class NetworkService{
          
     func isAlreadyRegistered(with employeeID:String,completion: @escaping ( _ isRegisterd: Bool) -> Swift.Void) {
         
         FireRefManager.db.collection(FireStoreKeys.CollectionPath.employees).whereField("EmployeeID", isEqualTo: employeeID).getDocuments() { (querySnapshot, err) in
             if let err = err {
                 print("Error getting documents: \(err)")
                 completion(false)
             } else {
                 if querySnapshot!.documents .count > 0 {
                         completion(true)
                 }else{
                     completion(false)
                 }
             }
         }
     }

     func addEmployee(employeeID: String,employeeDict: [String : Any], completion: @escaping (_ isSuccess: Bool) -> Swift.Void) {
          FireRefManager.db.collection(FireStoreKeys.CollectionPath.employees).document(employeeID).setData(employeeDict){ err in
             if let err = err {
                 print("Error writing document: \(err)")
                 completion(false)
                 return
             } else {
                 print("Employee Document added Successfully")
                 completion(true)
             }
         }
     }
     
     func getEmployee(with employeeID: String, password:String,completion: @escaping ( _ employee: EEmployee?) -> Swift.Void) {
         
         FireRefManager.db.collection(FireStoreKeys.CollectionPath.employees).whereField("EmployeeID", isEqualTo: employeeID).whereField("EmployeePassword", isEqualTo: password).getDocuments() { (querySnapshot, err) in
             if let err = err {
                 print("Error getting documents: \(err)")
                 completion(nil)
             } else {
                 if querySnapshot!.documents .count > 0 {
                         let document = querySnapshot!.documents.first!
                         print("\(document.documentID) => \(document.data())")
                         var employee = EEmployee()
                         employee = EEmployee(dictionary: document.data() as [String : AnyObject])
                         employee.EmployeeID = document.documentID
                         completion(employee)
                     
                 }else{
                     completion(nil)
                 }
             }
         }
     }
     
     func getAllEmployees(completion: @escaping ( _ employee: [EEmployee]) -> Swift.Void) {
         var employees: [EEmployee] = []

             FireRefManager.db.collection(FireStoreKeys.CollectionPath.employees).whereField("IsEmployeeInBus", isEqualTo: false).getDocuments() { (querySnapshot, err) in
                 if let err = err {
                     print("Error getting documents: \(err)")
                 } else {
                     for document in querySnapshot!.documents {
                         print("\(document.documentID) => \(document.data())")
                         var employee = EEmployee()
                         employee = EEmployee(dictionary: document.data() as [String : AnyObject])
                         employee.EmployeeID = document.documentID
                         employees.append(employee)
                     }
                 }
                 completion(employees)
             }
        
     }

     
     func updateEmployeeOnBatch(employees: [EEmployee], completion: @escaping (Bool) -> Swift.Void){
         let batch = FireRefManager.db.batch()
         for employee in employees {
             let ref = FireRefManager.db.collection(FireStoreKeys.CollectionPath.employees).document(employee.EmployeeID)
             batch.updateData(["IsEmployeeInBus": true], forDocument: ref)
         }
         batch.commit(completion: { (error) in
             guard let error = error else {
                 completion(true)
                 return
             }
             print("Error: \(error). Check your Firestore permissions.")
             completion(false)

         })

     }
     
     func updateEmployeeLocation(employee: EEmployee, completion: @escaping (Bool) -> Swift.Void){
         let ref = FireRefManager.db.collection(FireStoreKeys.CollectionPath.employees).document(employee.EmployeeID)
         ref.updateData(["CurrentLatitude": employee.CurrentLatitude,"CurrentLongitude": employee.CurrentLongitude]){ err in
             if let err = err {
                 print("Error updating location: \(err)")
             } else {
                 print("Location successfully updated!")
             }
         }
         
     }

 }

