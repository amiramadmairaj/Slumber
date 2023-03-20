//
//  SlumbeRApp.swift
//  SlumbeR
//
//  Created by Reisha Ladwa on 2/7/23.
//
import SwiftUI

@main
struct SlumbeRApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
