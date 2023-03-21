import SwiftUI
import HealthKit
import Charts
import SwiftUICharts

// made a global list for list of sleep stages. 0: awake; 1: REM; 2: Core; 3: Deep, 4:total
var myGlobalList: [Double] = [0.0, 0.0, 0.0, 0.0, 0.0]


struct SleepDataChart:
   
    View {
    // Initialize HealthKit store
    let healthStore = HKHealthStore()
    let calendar = Calendar.current
    let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!

    // Load Profile
    @Environment(\.managedObjectContext) var managedContext
    @FetchRequest(sortDescriptors: []) var userProfiles: FetchedResults<UserProfile>
    
    // Define properties to hold sleep data
    
    @State var sleepSamples: [HKCategorySample] = []
    @State var sleepHours: [Double] = []
    @State var sleepData: [Double] = [0.0, 0.0, 0.0, 0.0, 0.0]

    //added
    @State var remSleepSamples: [HKCategorySample] = []


    // Define the start and end date to fetch sleep data
    let startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
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
        VStack {
            let curUser = userProfiles[0]
            if !sleepHours.isEmpty == false {
                Text("\(greetingLogic()), \(curUser.name ?? "No Name")")
                Chart{
                    BarMark(x: .value("Name", "Awake"),
                            y: .value("Sales", sleepData[0])
                    )
//                    .annotation(position: .overlay, alignment: .center) {
//                        Text("\(sleepData[0], format: .number.precision(.fractionLength(2)))")
//                            .foregroundColor(.white)
//                    }
                    BarMark(x: .value("Name", "REM"),
                            y: .value("Sales", sleepData[1])
                    )
//                    .annotation(position: .overlay, alignment: .center) {
//                        Text("\(sleepData[1], format: .number.precision(.fractionLength(2)))")
//                            .foregroundColor(.white)
//                    }
                    BarMark(x: .value("Name", "Core"),
                            y: .value("Sales", sleepData[2])
                    )
//                    .annotation(position: .overlay, alignment: .center) {
//                        Text("\(sleepData[2], format: .number.precision(.fractionLength(2)))")
//                            .foregroundColor(.white)
//                    }
                    BarMark(x: .value("Name", "Deep"),
                            y: .value("Sales", sleepData[3])
                    )
//                    .annotation(position: .overlay, alignment: .center) {
//                        Text("\(sleepData[3], format: .number.precision(.fractionLength(2)))")
//                            .foregroundColor(.white)
//                    }
                    BarMark(x: .value("Name", "Total"),
                            y: .value("Sales", sleepData[4])
                    )
//                    .annotation(position: .overlay, alignment: .center) {
//                        Text("\(sleepData[4], format: .number.precision(.fractionLength(2)))")
//                            .foregroundColor(.white)
//                    }
                }
                .chartYScale(domain: 0...sleepData[4])

            } else {
                Text("No sleep data found\n Please check your settings to ensure SlumbeR has access to HealthKit sleep data")
            }
        }
        .onAppear {
            authorizeHealthKit()
//            print("test")
            querySleepData()
//            print("awake, rem, core, deep")
//            print(myGlobalList)

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




//    //new func yay
    func querySleepData() {
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
            
            myGlobalList[0] = 0.0
            myGlobalList[1] = 0.0
            myGlobalList[2] = 0.0
            myGlobalList[3] = 0.0
            myGlobalList[4] = 0.0
            if let samples = samples as? [HKCategorySample] {
                // Loop through the samples and calculate the duration of each sleep stage
                for sample in samples {
//                    guard myGlobalList[1]+myGlobalList[2]+myGlobalList[3]  == myGlobalList[0] else { break }
                    let value = sample.value
                    let startDate = sample.startDate
                    let endDate = sample.endDate
                    let duration = endDate.timeIntervalSince(startDate)
                    switch value {
                    case HKCategoryValueSleepAnalysis.awake.rawValue:
                        myGlobalList[0] += duration
                    case HKCategoryValueSleepAnalysis.asleepREM.rawValue:
                        myGlobalList[1] += duration
                    case HKCategoryValueSleepAnalysis.asleepCore.rawValue:
                        myGlobalList[2] += duration
                    case HKCategoryValueSleepAnalysis.asleepDeep.rawValue:
                        myGlobalList[3] += duration
                    case HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue:
                        myGlobalList[4] += duration
                    default:
                        continue
                    }
                    
                }
                let total = myGlobalList[1]/3600.0 + myGlobalList[2]/3600.0 + myGlobalList[3]/3600.0 + myGlobalList[4]/3600.0
                // Update the sleepData array with the duration of each sleep stage
                sleepData = [myGlobalList[0]/3600.0, myGlobalList[1]/3600.0, myGlobalList[2]/3600.0, myGlobalList[3]/3600.0, total]
                print(sleepData)
//                sleepData = myGlobalList
            }
        }

        // Execute the query
        healthStore.execute(query)
    }
   }




struct SleepDataChart_Previews: PreviewProvider {
    static var previews: some View {
        SleepDataChart()
    }
}

