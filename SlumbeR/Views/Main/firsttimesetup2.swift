//
//  firsttimesetup2.swift
//  SlumbeR
//
//  Created by Amir Mairaj on 2/9/23.
//

import SwiftUI

struct userdatacollection: View {
    @State private var age = ""
    @State private var weight = ""
    @State private var height = ""
    
    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                TextField("Age", text: $age)
                    .keyboardType(.numberPad)
                TextField("Weight (in lbs)", text: $weight)
                    .keyboardType(.decimalPad)
                TextField("Height (in inches)", text: $height)
                    .keyboardType(.decimalPad)
            }
        }
        VStack{
            NavigationLink(destination: userdatacollection2()){
                Text("Next").frame(alignment: .bottom)
            }
            
            
        }
    }
}
