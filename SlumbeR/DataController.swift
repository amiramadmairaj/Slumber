//
//  AppDelegate.swift
//  SlumbeR
//
//  Created by Perry Liu on 2/14/23.
//
import Foundation
import CoreData

class DataController: ObservableObject {

    let container = NSPersistentContainer(name: "Model")
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
