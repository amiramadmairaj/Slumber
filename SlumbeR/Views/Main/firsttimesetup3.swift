//
//  firsttimesetup3.swift
//  SlumbeR
//
//  Created by Amir Mairaj on 2/9/23.
//


import SwiftUI

struct userdatacollection2: View {
    @State private var avg_bedtime = ""
    @State private var avg_wakeup = ""
    @State private var avg_hours_of_sleep = ""
    
    var body: some View {
        Form {
            Section(header: Text("Tell Us More About You")) {
                TextField("How many hours of sleep do you get each night on average?", text: $avg_hours_of_sleep)
                    .keyboardType(.numberPad)
                TextField("What time do you wake up usally?", text: $avg_wakeup)
                    .keyboardType(.numberPad)
                TextField("What time do you go to bed usally?", text: $avg_bedtime)
                    .keyboardType(.numberPad)
            }
        }
        VStack{
            NavigationLink(destination: userdatacollection()){ // change this to next window
                Text("Next").frame(alignment: .bottom)
            }
            
            
        }
    }
}
