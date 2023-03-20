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
//            commented out for now bc of that chart error
            SleepDataChart()
                .tabItem{
                    Label("Home", systemImage: "powersleep")
                }
            TipsView()
                .tabItem{
                    Label("Tips", systemImage: "lightbulb")
                }
            DebugMLView()
                .tabItem{
                    Label("ML", systemImage: "lightbulb")
                }
        }
        .preferredColorScheme(.dark)
    }
}


struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
