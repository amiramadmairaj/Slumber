//
//  MainMenu.swift
//  SlumbeR
//
//  Created by Amir Mairaj on 2/19/23.
//
//import SwiftUI
//import HealthKit
//import SwiftUICharts
//
//
//struct SleepDataChart: View {
//    let healthStore = HKHealthStore()
//    let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
//
//    @State var sleepData: [(Date, Double)] = []
//
//        var body: some View {
////                    HStack (alignment: .top){ // << moved this up to ZStack
////                        Text("Top Text")
////                            .fontWeight(.light)
////                            .multilineTextAlignment(.center)
////                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
////                            .font(.body)
////                    }
//
//            VStack {
//                Text("\(greetingLogic()), \(name)")
//                    .multilineTextAlignment(.center)
//                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30)
//                    .foregroundColor(themeColor)
//                    .shadow(color: themeColor, radius: 16)
//                    .padding(.top, 60)
//                    .padding(.bottom, 30)
//                    .font(.system(size: 40, weight: .bold, design: .default))
//                //FIGURE OUT WHY THIS IS SURROUNDED BY A BOX, ALSO IS THIS A GRAPH?
//                // PieChartView(data: sleepData.map { $0.1 }, title: "Sleep Data").padding()
//                LineChartView(data: sleepData.map { $0.1 }, title: "Sleep Data").padding()
//
//
//                Button("Refresh Sleep Data") {
//                    authorizeHealthKit()
//                    fetchSleepData()
//                }
//            }
//        }
//    func authorizeHealthKit() {
//        self.healthStore.requestAuthorization(toShare: [], read: [self.sleepType]) { (success,error) in
//            if !success {
//                print("Authorization failed: \(error?.localizedDescription ?? "Unknown error")")
//            }
//        }
//    }
//
//    @available(iOS 16.0, *)
//    func fetchSleepData() {
//        let calendar = Calendar.current
//        let now = Date()
//        let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: now)!
//        let predicate = HKQuery.predicateForSamples(withStart: oneWeekAgo, end: now, options: .strictStartDate)
//
//        let query = HKSampleQuery(sampleType: self.sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
//            if let samples = samples as? [HKCategorySample] {
//                let data = samples.map { sample -> (Date, Double) in
//                    let value = sample.value == HKCategoryValueSleepAnalysis.asleepREM.rawValue ? 1.0 : 0.0
//                    return (sample.startDate, value)
//                }
//                self.sleepData = data
//            }
//        }
//
//        self.healthStore.execute(query)
//    }
//}
//
//
//
//
//func greetingLogic() -> String {
//  let hour = Calendar.current.component(.hour, from: Date())
//  let NEW_DAY = 0
//  let NOON = 12
//  let SUNSET = 18
//  let MIDNIGHT = 24
//  var greetingText = "Hello" // Default greeting text
//  switch hour {
//  case NEW_DAY..<NOON:
//      greetingText = "Good Morning"
//  case NOON..<SUNSET:
//      greetingText = "Good Afternoon"
//  case SUNSET..<MIDNIGHT:
//      greetingText = "Good Evening"
//  default:
//      _ = "Hello"
//  }
//
//  return greetingText
//}
//
//
//
//
//
//
//struct SleepDataChart_Previews: PreviewProvider {
//    static var previews: some View {
//        SleepDataChart()
//    }
//}
//
//  MainMenu.swift
//  SlumbeR
//
//  Created by Amir Mairaj on 2/19/23.
//
import SwiftUI
import HealthKit
import Charts
import SwiftUICharts

// made a global list for list of sleep stages. 0: asleep; 1: Deep; 2: REM; 3: Core
var myGlobalList: [Double] = [0.0, 0.0, 0.0, 0.0]
//@State var sleepData: [Double] = [0.0, 0.0, 0.0, 0.0]


struct SleepDataChart:
                            



    View {
    // Initialize HealthKit store
    let healthStore = HKHealthStore()
    let calendar = Calendar.current
    let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!



    // Define properties to hold sleep data
    @State var sleepSamples: [HKCategorySample] = []
    @State var sleepHours: [Double] = []
    @State var sleepData: [Double] = [0.0, 0.0, 0.0, 0.0]
    
    //added
    @State var remSleepSamples: [HKCategorySample] = []


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
//        querySleepData()
        VStack {
            if !sleepHours.isEmpty == false {
                Text("\(greetingLogic()), \(name)")
                Text(" YEET, IMAGINE A GRAPH OF SLEEP DATA IS HERE ")
                let _ = print(querySleepData())
//                Text("\(sleepData[0])")
//                ForEach(sleepData.indices, id: \.self) { index in
//                                    Text("\(sleepData[index])")
//                                }
//
                Chart{
                    BarMark(x: .value("Name", "Asleep"),
                            y: .value("Sales", sleepData[0])
                    )
                    BarMark(x: .value("Name", "Deep"),
                            y: .value("Sales", sleepData[1])
                    )
                    BarMark(x: .value("Name", "REM"),
                            y: .value("Sales", sleepData[2])
                    )
                    BarMark(x: .value("Name", "Core"),
                            y: .value("Sales", sleepData[3])
                    )
                    
                }

            } else {
                Text("No sleep data found\n Please check your settings to ensure SlumbeR has access to HealthKit sleep data")
            }
        }
        .onAppear {
            authorizeHealthKit()
            print("test")
            querySleepData()
            print(myGlobalList)
            
        }
    }

    // Request authorization to access HealthKit data
    func authorizeHealthKit() {
        print("in authorizeHealthKit")
        let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!

        healthStore.requestAuthorization(toShare: [], read: [sleepType]) { (success,error) in
            if !success {
                print("Authorization failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    //reisha
    func fetchSleepData() {
        print("in fetchSleepData")
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            print("Sleep analysis not available")
            return
        }

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            if let error = error {
                print("Error fetching sleep data: \(error.localizedDescription)")
                return
            }

            if let samples = samples as? [HKCategorySample] {
                for sample in samples {
                    let startDate = sample.startDate
                    let endDate = sample.endDate
                    let value = sample.value

                    print("Sleep analysis sample:")
                    print("Start time: \(startDate)")
                    print("End time: \(endDate)")
                    print("Value: \(value)")
                }
            }
        }

        HKHealthStore().execute(query)
    }

    // WORKSSS
    func querySleepData() {
            // Define the sleep analysis type
            let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!

            // Get the current date
            let currentDate = Date()

            // Define the query interval
            var interval = DateComponents()
            interval.day = 1

            // Define the query start and end dates
            var anchorComponents = calendar.dateComponents([.day, .month, .year], from: currentDate)
            anchorComponents.hour = 0
            let anchorDate = calendar.date(from: anchorComponents)!
            let startDate = calendar.date(byAdding: .day, value: -7, to: anchorDate)!
            let endDate = currentDate

            // Define the predicate to query for sleep data between the start and end dates
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)

        // Create the query to get the sleep data
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) { (query, samples, error) in
            if let error = error {
                print(error)
                return
            }

            guard let samples = samples as? [HKCategorySample] else {
                print("No samples")
                return
            }

            for sample in samples {
                let value = HKCategoryValueSleepAnalysis(rawValue: sample.value)!
//                let startDate = sample.startDate
//                let endDate = sample.endDate

                switch value {
                case .inBed:
                    print("In bed")
                case .asleep:
                    print("Asleep")

                    // Query for detailed sleep stages within the sleep sample
                    let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) { (query, subSamples, error) in
                        if let error = error {
                            print(error)
                            return
                        }

                        guard let subSamples = subSamples as? [HKCategorySample] else {
                            print("No sub-samples")
                            return
                        }

                        for subSample in subSamples {
                            let subValue = HKCategoryValueSleepAnalysis(rawValue: subSample.value)!
// Asleep, Deep, REM, Core
                            switch subValue.rawValue {
                            case HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue:
                                print("Asleep")
                                let subStartDate = subSample.startDate
                                let subEndDate = subSample.endDate
                                myGlobalList[0] = subEndDate.timeIntervalSince(subStartDate)/60
                                
                            case HKCategoryValueSleepAnalysis.asleepDeep.rawValue:
                                print("Deep sleep")
                                let subStartDate = subSample.startDate
                                let subEndDate = subSample.endDate
                                myGlobalList[1] = subEndDate.timeIntervalSince(subStartDate)/60
                                
                            case HKCategoryValueSleepAnalysis.asleepREM.rawValue:
                                print("REM sleep")
                                let subStartDate = subSample.startDate
                                let subEndDate = subSample.endDate
                                myGlobalList[2] = subEndDate.timeIntervalSince(subStartDate)/60
                                
                            case HKCategoryValueSleepAnalysis.asleepCore.rawValue:
                                print("Core (light) sleep")
                                let subStartDate = subSample.startDate
                                let subEndDate = subSample.endDate
                                myGlobalList[3] = subEndDate.timeIntervalSince(subStartDate)/60
                                
                            default:
                                continue
                            }
                            sleepData = myGlobalList
//                            print(myGlobalList)

                        }
                    }

                    // Execute the sub-query for detailed sleep stages
                    healthStore.execute(query)

                default:
                    continue
                }
            }
        }

        // Execute the query
        healthStore.execute(query)
        
    }
    
//    //new func yay
   }



struct SleepDataChart_Previews: PreviewProvider {
    static var previews: some View {
        SleepDataChart()
    }
}







