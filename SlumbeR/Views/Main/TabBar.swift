//
//  TabBar.swift
//  SlumbeR
//
//  Created by Reisha Ladwa on 2/7/23.
//

import SwiftUI

struct TabBar: View {
    var body: some View {
        TabView {
//            HomeView()
//                .tabItem{
//                    Label("Home", systemImage: "person")
//                }
            ContentView()
                .tabItem{
                    Label("Track", systemImage: "square.fill.text.grid.1x2")
                }
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
