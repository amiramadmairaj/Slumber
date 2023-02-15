//
//  AppDelegate.swift
//  SlumbeR
//
//  Created by Perry Liu on 2/14/23.
//
import UIKit
import CoreData

class AppDelegate: UIResponder, UIApplicationDelegate {


    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()

}
