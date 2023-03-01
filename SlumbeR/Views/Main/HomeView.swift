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
            .preferredColorScheme(.dark) //default to dark mode
        }
    }
}

struct HomeView: View{
    @Environment(\.managedObjectContext) var managedContext
    @FetchRequest(sortDescriptors: []) var userProfiles: FetchedResults<UserProfile>
    @State private var firstTimeUser: Bool = true
    //fetching user profile if user has one. Default is [0] since only one user profile saved
    var body: some View {
        let _ = {
            print("\(userProfiles.count)")
            if (userProfiles.count == 0) {
                firstTimeUser = false
            }
            else
            {
                firstTimeUser = userProfiles[0].firstAccess
            }
        }
        if (firstTimeUser) {
            FirstAccessView()
        }
        else {
            TabBar()
        }
    }
}

struct FirstTimeSetupView: View{
    // below environment injects core data context into this scope
    @Environment(\.managedObjectContext) var managedContext
    // this should fetch an empty list of profiles.
    // maybe look into a way to manage 1 single profile in the future
    // but now default index 0 as current user profile
    @FetchRequest(sortDescriptors: []) var userProfiles: FetchedResults<UserProfile>
    
    @State private var name = ""
    @State private var age: Int16 = 0
    @State private var weight: Int16 = 0
    @State private var height: Int16 = 0
    @State private var smokes = false
    @State private var gender = false
    @State private var avgExercise: Int16 = 0
    
    
    func createNewProfile(age: Int16, height: Int16, weight: Int16, name: String, gender: Bool, smokes: Bool, avgExercise: Int16) {
        // this function attempts to create a new UserProfile object and store it in the
        // NSManagedObjectContext manageContext.
        // not all attributes are stored at this moment.
        if (userProfiles.count == 0) {
            let newProf = UserProfile(context: managedContext)
            newProf.age = age
            newProf.height = height
            newProf.weight = weight
            newProf.name = name
            newProf.gender = gender
            newProf.smokes = smokes
            newProf.avgExercise = avgExercise
            newProf.firstAccess = false
            // no error handling as of now
            try? managedContext.save()
        }
    }
    
    var body: some View{
        Text("Let's get to know you a little!")
            .padding()
        Form{
            Group{
                Section(header: Text("What Should We Call You?")){
                    TextField("Username", text: $name)
                        .keyboardType(.default)
                }
            }
            Group{
                // need fixing the UI it looks weird right now.
                Section(header: Text("Personal Information")) {
                    Text("What is your age?")
                    TextField("Age", value: $age, format:.number)
                    Text("What is your gender?")
                    Picker(selection: $smokes, label: Text("")) {
                        Text("Male").tag(true)
                        Text("Female").tag(false)
                    }
                    Text("What is your weight?")
                    TextField("Weight (in lbs)", value: $weight, format: .number)
                    Text("How tall are you?")
                    TextField("Height (in inches)", value: $height, format:.number)
                    
                }
                Section(header: Text("Health Questionnaire")) {
                    Text("How many times (on average) do you exercise a week?")
                    TextField("Weekly Exercise", value: $avgExercise, format:.number)
                    Text("Do you smoke?")
                    Picker(selection: $smokes, label: Text("")) {
                        Text("Yes").tag(true)
                        Text("No").tag(false)
                    }
                }
            }
        }
        VStack{
            // the "combined" Done button and navigation button.
            // the createProfile function is used when the next view in the navigation
            // appears.
            NavigationLink(destination: FirstTimeSetupSleepView().onAppear(perform: { createNewProfile(age: self.age, height: self.height, weight: self.weight, name: self.name, gender: self.gender, smokes: self.smokes, avgExercise: self.avgExercise)})){
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

