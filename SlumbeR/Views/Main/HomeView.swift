//
//  HomeView.swift
//  SlumbeR
//
//  Created by Reisha Ladwa on 2/7/23.
//

import SwiftUI
import HealthKit

let healthStore = HKHealthStore()
// Define the start and end date to fetch sleep data
let startDate = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
let endDate = Date()

var name = "User"
let themeColor = Color(red: 0.364, green: 0.247, blue: 0.827, opacity: 1.0)
let translucentBlack = Color(red: 0, green: 0, blue: 0, opacity: 0.9)
var myDict = ["sleepDuration": 0.0, "remPercent": 0.0, "deepPercent": 0.0]



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

struct DebugView: View{
    @Environment(\.managedObjectContext) var managedContext
    @FetchRequest(sortDescriptors: []) var userProfiles: FetchedResults<UserProfile>
    var body: some View{
        NavigationView {
            VStack{
                List(userProfiles) { user in
                    Text(user.name ?? "No name")
                    Text("User height: \(user.height)")
                    Text("User weight: \(user.weight)")
                    Text("User age: \(user.age)")
                }
                
                Button("Delete") {
                    for user in userProfiles {
                        managedContext.delete(user)
                    }
                    try? managedContext.save()
                }
                NavigationLink("First Access", destination: FirstAccessView())
                NavigationLink("TabBar", destination: TabBar())
                NavigationLink("ML Debug",destination: DebugMLView())
                    .navigationBarHidden(true)
            }
            .preferredColorScheme(.dark)
        }
    }
}


struct DebugMLView: View {
    @Environment(\.managedObjectContext) var managedContext
    @FetchRequest(sortDescriptors: []) var userProfiles: FetchedResults<UserProfile>
    var body: some View {
        VStack {
            let curUser = userProfiles[0]
            // Hard coded values need to be replaced with Apple HealthKit queries.
            let theySmoke = Double(curUser.smokes ? 1 : 0)
            let theirGender = Double(curUser.gender ? 0 : 1) // male is 0 female is 1
            let sleepEff = getSleepEff(age: Double(curUser.age),
                                       gender: theirGender,
                                       sleepDuration: myDict["sleepDuration"]!,
                                       remSleepPerc: myDict["remPercent"]!,
                                       deepSleepPerc: myDict["deepPercent"]!,
                                       smoking: theySmoke,
                                       exerciseFreq: Double(curUser.avgExercise))
            
            let idealREM = getREMSleepPerc(age: Double(curUser.age),
                                           gender: theirGender,
                                           sleepDuration: myDict["sleepDuration"]!,
                                           sleepEfficiency: Double(90.0),
                                           deepSleepPerc: myDict["deepPercent"]!,
                                           smoking: theySmoke,
                                           exerciseFreq: Double(curUser.avgExercise))
            
            let idealDeep = getDeepSleepPerc(age: Double(curUser.age),
                                             gender: theirGender,
                                             sleepDuration: myDict["sleepDuration"]!,
                                             sleepEfficiency: Double(90.0),
                                             remSleepPerc: myDict["remPercent"]!,
                                             smoking: theySmoke,
                                             exerciseFreq: Double(curUser.avgExercise))
            
            let predictAge = getAge(gender: theirGender,
                                    sleepDuration: myDict["sleepDuration"]!,
                                    sleepEfficiency: sleepEff,
                                    remSleepPerc: myDict["remPercent"]!,
                                    deepSleepPerc: myDict["deepPercent"]!,
                                    smoking: theySmoke,
                                    exerciseFreq: Double(curUser.avgExercise))
            
            let projectedExercise = classifyExerciseFreq(age: Double(curUser.age),
                                                         gender: theirGender,
                                                         sleepEff: sleepEff,
                                                         sleepDuration: myDict["sleepDuration"]!,
                                                         remSleepPerc: myDict["remPercent"]!,
                                                         deepSleepPerc: myDict["deepPercent"]!,
                                                         smoking: theySmoke)
            Text("Current sleep efficiency is: ")
            Text("\(sleepEff)")
            Text("Ideal REM Sleep Percentage: ")
            Text("\(idealREM)")
            Text("Ideal Deep Sleep Percentage: ")
            Text("\(idealDeep)")
            Text("Sleeping age: ")
            Text("\(predictAge)")
            Text("Ideal amount of exercise: ")
            Text("\(projectedExercise) times a week")
        }
        .onAppear{querySleepDataML()}
    }
}

func querySleepDataML() {
    // Define the sleep analysis type
    let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!
    
    // Define the query start and end dates
    let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
    
    // Define the query
    let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
        if let error = error {
            print("Error fetching sleep data: \(error.localizedDescription)")
            return
        }
        myDict["sleepDuration"] = 0.0
        myDict["remPercent"] = 0.0
        myDict["deepPercent"] = 0.0
        var awakey = 0.0
        if let samples = samples as? [HKCategorySample] {
            // Loop through the samples and calculate the duration of each sleep stage
            for sample in samples {
                let value = sample.value
                let startDate = sample.startDate
                let endDate = sample.endDate
                let duration = endDate.timeIntervalSince(startDate)
                switch value {
                case HKCategoryValueSleepAnalysis.asleepREM.rawValue:
                    myDict["sleepDuration"]! += duration
                    myDict["remPercent"]! += duration
                case HKCategoryValueSleepAnalysis.awake.rawValue:
                    awakey += duration
                case HKCategoryValueSleepAnalysis.asleepCore.rawValue:
                    myDict["sleepDuration"]! += duration
                case HKCategoryValueSleepAnalysis.asleepDeep.rawValue:
                    myDict["sleepDuration"]! += duration
                    myDict["deepPercent"]! += duration
                default:
                    continue
                }
            }
        }
        myDict["deepPercent"]! = myDict["deepPercent"]!/(myDict["sleepDuration"]! + awakey)
        myDict["remPercent"]! = myDict["remPercent"]!/(myDict["sleepDuration"]! + awakey)
        print("HELLO LOOK HERE")
        print(myDict)
        
    }
    
    // Execute the query
    healthStore.execute(query)
}

struct HomeView: View{
    @Environment(\.managedObjectContext) var managedContext
    @FetchRequest(sortDescriptors: []) var userProfiles: FetchedResults<UserProfile>
    @State var debug = true
    //fetching user profile if user has one. Default is [0] since only one user profile saved
    var body: some View {
        if (debug == true) {
            DebugView()
        }
        else if (userProfiles.count == 0) {
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
                    Picker(selection: $gender, label: Text("")) {
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
            NavigationLink(destination: FirstTimeSetupSleepView().onAppear(perform: {
                createNewProfile(age: self.age,
                                 height: self.height,
                                 weight: self.weight,
                                 name: self.name,
                                 gender: self.gender,
                                 smokes: self.smokes,
                                 avgExercise: self.avgExercise)
                
            })) {
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




















































