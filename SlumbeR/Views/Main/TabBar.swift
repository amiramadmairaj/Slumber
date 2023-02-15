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
            ContentView()
                .tabItem{
                    Label("Home", systemImage: "powersleep")
                }
            TipsView()
                .tabItem{
                    Label("Tips", systemImage: "lightbulb")
                }
        }
    }
}


struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
