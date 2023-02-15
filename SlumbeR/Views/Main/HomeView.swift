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
    var body: some View{
        NavigationView(){
            VStack(spacing: 20) {
                Text("Slumber")
                    .font(.system(size: 48, weight: .black, design: .monospaced))
                    .multilineTextAlignment(.center)
                    .foregroundColor(themeColor)
                    .shadow(color: themeColor, radius: 16)
                    .shadow(color: themeColor, radius: 16)
                NavigationLink(destination: FirstTimeSetupView()){
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
        FirstAccessView()
        }
        
}

struct FirstTimeSetupView: View{
    // figure out how to change colors
    // add next button and proceed to ask permission for HealthKit
    @State private var name = ""
    @State private var age = ""
    @State private var weight = ""
    @State private var height = ""
    var body: some View{
        Text("Let's get to know you a little!")
            .padding()
        Form{
            Group{
                Section(header: Text("What's your name?")){
                    TextField("Username", text: $name)
                        .keyboardType(.decimalPad)
                }
            }
            Group{
                Section(header: Text("Personal Information")) {
                    TextField("Age", text: $age)
                        .keyboardType(.numberPad)
                    TextField("Weight (in lbs)", text: $weight)
                        .keyboardType(.decimalPad)
                    TextField("Height (in inches)", text: $height)
                        .keyboardType(.decimalPad)
                }
            }
        }
        VStack{
            NavigationLink(destination: FirstTimeSetupSleepView()){
                Text("Next").frame(alignment: .bottom)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View{
        HomeView()
    }
}

