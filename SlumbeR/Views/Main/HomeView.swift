//
//  HomeView.swift
//  SlumbeR
//
//  Created by Reisha Ladwa on 2/7/23.
//

import SwiftUI

var name = "User"
let themeColor = Color(red: 0.364, green: 0.247, blue: 0.827, opacity: 1.0)
let translucentBlack = Color(red: 0, green: 0, blue: 0, opacity: 0.9)

struct FirstAccessView: View{
    // first time access user get to see this view.
    // should only be used once.
    var dest: ResultView
    var body: some View{
        NavigationView(){
            VStack(spacing: 20) {
                Text("Slumber")
                    .font(.system(size: 48, weight: .black, design: .monospaced))
                    .multilineTextAlignment(.center)
                    .foregroundColor(themeColor)
                    .shadow(color: themeColor, radius: 16)
                    .shadow(color: themeColor, radius: 16)
                NavigationLink(destination: ResultView()){
                    Text("Let's get started!")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(translucentBlack)
        }
    }
}

struct HomeView: View{
    @State private var firstTimeUser: Bool = true
    var body: some View{
        FirstAccessView(dest: ResultView())
        }
        
}

struct ResultView: View{
    // figure out how to change colors
    // add next button and proceed to ask permission for HealthKit
    @State var name: String = ""
    var body: some View{
        Text("Let's get to know you a little!")
            .padding()
        Form{
            Section(header: Text("What's your name?")){
                TextField("Username", text: $name)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View{
        HomeView()
    }
}

