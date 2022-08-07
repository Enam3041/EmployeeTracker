//
//  FireRefManager.swift
//  EmployeeTracker
//
//  Created by Digital Ride on 01/08/2022.
//


import Foundation
import FirebaseFirestore

struct FireRefManager{
    static let db = Firestore.firestore()
    
    static func referenceForEmployeeDocument(_ uid: String)-> DocumentReference{
        return db.collection(FireStoreKeys.CollectionPath.employees).document(uid)
    }
  
}


struct FireStoreKeys {
    struct CollectionPath {
        static let employees = "Employees"
    }
}


enum GoogleKeys : String {
    case ServiceAPIKey = "AIzaSyC4f5Av36OO9W9ndswWqhjlygcm0hulUdw"
}


enum TrackingType:String{
    case Employee
    case Bus
}

enum Schedule:String{
    case Bus0720
    case Bus0740
    case Bus0750
    case Bus0800
}
