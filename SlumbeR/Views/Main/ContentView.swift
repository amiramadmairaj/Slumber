//
//  ContentView.swift
//  SlumbeR
//
//  Created by Reisha Ladwa on 2/7/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Text("Sleep Tracking Page!")
                .navigationTitle("Sleep Tracking Page!")
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
