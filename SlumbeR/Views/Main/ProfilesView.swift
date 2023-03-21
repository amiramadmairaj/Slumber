//
//  Profiles.swift
//  SlumbeR
//
//  Created by Perry Liu on 3/20/23.
//
import SwiftUI

struct UserInfoDisplayView: View{
    @Environment(\.managedObjectContext) var managedContext
    @FetchRequest(sortDescriptors: []) var userProfiles: FetchedResults<UserProfile>
    @Environment(\.presentationMode) var presentation
    @State private var showingAlert = false
    var user: UserProfile
    var body: some View {
        
        VStack {
            Text("Username: \(user.name ?? "No name")")
            Text("Age: \(user.age)")
            HStack{
                Button("Select") {
                    identification.currentUserID = Int(user.uid)
                }
                Button("Delete") {
                    if (userProfiles.count == 1) {
                    } else {
                        if (identification.currentUserID == user.uid) {
                            identification.currentUserID = Int(userProfiles.first?.uid ?? -1)
                        }
                        for tempUser in userProfiles {
                            if (user.uid == tempUser.uid) {
                                managedContext.delete(tempUser)
                            }
                            
                        }
                        try? managedContext.save()
                        presentation.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}


struct NewProfileView: View {
    @Environment(\.managedObjectContext) var managedContext
    @FetchRequest(sortDescriptors: []) var userProfiles: FetchedResults<UserProfile>
    @Environment(\.presentationMode) var presentation
    @State private var name = ""
    @State private var age: Int16 = 0
    @State private var weight: Int16 = 0
    @State private var height: Int16 = 0
    @State private var smokes = false
    @State private var gender = false
    @State private var avgExercise: Int16 = 0
    @State private var feet = 0
    @State private var inches = 0
    @State private var w = 0
    @State private var a = 0
    @State private var e = 0
    
    func createNewProfile(age: Int16, height: Int16, weight: Int16, name: String, gender: Bool, smokes: Bool, avgExercise: Int16) {
        // this function attempts to create a new UserProfile object and store it in the
        // NSManagedObjectContext manageContext.
        // not all attributes are stored at this moment.
        let newProf = UserProfile(context: managedContext)
        newProf.age = age
        newProf.height = height
        newProf.weight = weight
        newProf.name = name
        newProf.gender = gender
        newProf.smokes = smokes
        newProf.avgExercise = avgExercise
        newProf.firstAccess = false
        newProf.uid = Int16(userProfiles.count + 1)
        identification.currentUserID = Int(newProf.uid)
        // no error handling as of now
        try? managedContext.save()
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
                
                Section(header: Text("Personal Information")) {
                    
                    
                    Text("What is your age?")
                    Picker(
                        selection: $a,
                        label: Text("Age"),
                        content: {
                            ForEach(0..<1000, id: \.self) {aaa in
                                Text("\(aaa) years old")
                                    .tag(aaa)
                                
                            }
                            
                        })
                    .pickerStyle(.wheel)
                    .frame(width: 150, height: 110)
                    
                    
                    Text("What is your weight?")
                    Picker(
                        selection: $w,
                        label: Text("Weight"),
                        content: {
                            ForEach(0..<1000, id: \.self) {www in
                                Text("\(www) lbs")
                                    .tag(www)
                                
                            }
                            
                        })
                    .pickerStyle(.wheel)
                    .frame(width: 150, height: 110)
                    
                    
                    
                    Text("What is your gender?")
                    Picker(selection: $gender, label: Text("")) {
                        Text("Male").tag(true)
                        Text("Female").tag(false)
                    }
                    .frame(width: 200, height: 100)
                    .pickerStyle(.wheel)
                    
                    
                    
                    
                    Text("How tall are you?")
                    HStack {
                        Picker("Feet", selection: $feet) {
                            ForEach(0..<9) { feet in
                                Text("\(feet) ft").tag(feet)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 150, height: 110)
                        
                        
                        Picker("Inches", selection: $inches) {
                            ForEach(0..<12) { inch in
                                Text("\(inch) in").tag(inch)
                                
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 150, height: 110)
                    }
                    
                    
                    
                }
                
                
                Section(header: Text("Health Questionnaire")) {
                    Text("How many times (on average) do you exercise a week?")
                    Picker(
                        selection: $e,
                        label: Text("Weekly Exercise"),
                        content: {
                            ForEach(0..<20, id: \.self) {e in
                                Text("\(e) times")
                                    .tag(e)
                                
                            }
                            
                        })
                    .pickerStyle(.wheel)
                    .frame(width: 150, height: 110)
                    
                    
                    Text("Do you smoke?")
                    Picker(selection: $smokes, label: Text("")) {
                        Text("Yes").tag(true)
                        Text("No").tag(false)
                    }
                    .frame(width: 200, height: 100)
                    .pickerStyle(.wheel)
                }
            }
    }.onDisappear{
            self.height = Int16(truncatingIfNeeded:(feet * 12) + inches)
            self.weight = Int16(truncatingIfNeeded: w)
            self.age =  Int16(truncatingIfNeeded: a)
            self.avgExercise =  Int16(truncatingIfNeeded: e)
            createNewProfile(age: self.age,
                                       height: self.height,
                                       weight: self.weight,
                                       name: self.name,
                                       gender: self.gender,
                                       smokes: self.smokes,
                                       avgExercise: self.avgExercise)
            }
        Button("Done") {
            presentation.wrappedValue.dismiss()
        }
    }
}

struct ProfilesView: View {
    @Environment(\.managedObjectContext) var managedContext
    @FetchRequest(sortDescriptors: []) var userProfiles: FetchedResults<UserProfile>
    var body: some View {
        NavigationStack {
            List(userProfiles) { profile in
                NavigationLink(profile.name ?? "No name", value: profile)
            }
            .navigationDestination(for: UserProfile.self) { profile in
                UserInfoDisplayView(user: profile)
            }
            NavigationLink("New Profile", destination: NewProfileView().navigationBarBackButtonHidden(true))
        }
        .preferredColorScheme(.dark)
    }
}

struct Profiles_Previews: PreviewProvider {
    static var previews: some View {
        ProfilesView()
    }
}
