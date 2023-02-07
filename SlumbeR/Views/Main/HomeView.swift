//
//  HomeView.swift
//  SlumbeR
//
//  Created by Reisha Ladwa on 2/7/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            Text("Hello, Home!")
                .navigationTitle("Hello, Home!")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

