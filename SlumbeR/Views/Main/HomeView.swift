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
            VStack{
                NavigationLink(destination: userdatacollection()){
                    Text("Click Start Here to Begin Your \n Slumber Journey").frame(width: 300, height: 300,alignment: .center)
                        .cornerRadius(50)
                }
            }.navigationTitle("Welcome to Slumber")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

