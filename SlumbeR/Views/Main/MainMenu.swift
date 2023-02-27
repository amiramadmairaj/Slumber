//
//  MainMenu.swift
//  SlumbeR
//
//  Created by Amir Mairaj on 2/19/23.
//
import SwiftUI
import HealthKit
import Charts

struct SleepDataChart:
    View {
    // Initialize HealthKit store
    let healthStore = HKHealthStore()
    let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
       
    // Define properties to hold sleep data
    @State var sleepSamples: [HKCategorySample] = []
    @State var sleepHours: [Double] = []
    
    // Define the start and end date to fetch sleep data
    let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
    let endDate = Date()
    

    func greetingLogic() -> String {
        
      let hour = Calendar.current.component(.hour, from: Date())
      
      let NEW_DAY = 0
      let NOON = 12
      let SUNSET = 18
      let MIDNIGHT = 24
      
      var greetingText = "Hello" // Default greeting text
      switch hour {
      case NEW_DAY..<NOON:
          greetingText = "Good Morning"
      case NOON..<SUNSET:
          greetingText = "Good Afternoon"
      case SUNSET..<MIDNIGHT:
          greetingText = "Good Evening"
      default:
          _ = "Hello"
      }
      
      return greetingText
    }
    
    var body: some View {
        // Fetch sleep data from HealthKit
        VStack {
            if !sleepHours.isEmpty == false {
                Text("\(greetingLogic()), \(name)")
                Text(" YEET, IMAGINE A GRAPH OF SLEEP DATA IS HERE ")
                // Graph Sleep Health Data Here (7 day period)
                
                
           
                
            } else {
                Text("No sleep data found\n Please check your settings to ensure SlumbeR has access to HealthKit sleep data")
            }
        }
        .onAppear {
            authorizeHealthKit()
            fetchSleepData()
        }
    }
    
    // Request authorization to access HealthKit data
    func authorizeHealthKit() {
        let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!
        
        healthStore.requestAuthorization(toShare: [], read: [sleepType]) { (success,error) in
            if !success {
                print("Authorization failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func fetchSleepData() {
           let calendar = Calendar.current
           let now = Date()
           let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: now)!
           let predicate = HKQuery.predicateForSamples(withStart: oneWeekAgo, end: now, options: .strictStartDate)

           let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
               if let samples = samples as? [HKCategorySample] {
                   self.processSleepData(samples)
               }
           }

           healthStore.execute(query)
       }
       
       func processSleepData(_ samples: [HKCategorySample]) {
           let sleepData = samples.map { sample -> (Date, Double) in
               let value = sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue ? 1.0 : 0.0
               return (sample.startDate, value)
           }
           
           
       }
       
   }
    
    

struct SleepDataChart_Previews: PreviewProvider {
    static var previews: some View {
        SleepDataChart()
    }
}
