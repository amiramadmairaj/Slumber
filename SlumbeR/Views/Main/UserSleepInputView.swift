//
//  firsttimesetup3.swift
//  SlumbeR
//
//  Created by Amir Mairaj on 2/9/23.
//


import SwiftUI

struct FirstTimeSetupSleepView: View {

    @State private var wakeUpDate = Date()
    @State private var bedTimeDate = Date()

    var body: some View {
        VStack {
            Form {
                Section(header:Text("Tell us about your current sleeping habits")){
                    VStack(spacing: 20) {
                        Text("What is your average wake up time?")
                            .font(.body)
                            .foregroundColor(.blue)
                        DatePicker("", selection: $wakeUpDate, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .datePickerStyle(WheelDatePickerStyle())
                            .foregroundColor(.blue)
                    }
                    VStack(spacing: 40)  {
                        Text("What is your average bed time?")
                            .font(.body)
                            .foregroundColor(.blue)
                        DatePicker("", selection: $bedTimeDate, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .datePickerStyle(WheelDatePickerStyle())
                            .foregroundColor(.blue)
                    }
                }
            }
            VStack{
                NavigationLink(destination: TabBar()){
                    Text("Next").frame(alignment: .bottom)
                }
            }

        }

    }
}

