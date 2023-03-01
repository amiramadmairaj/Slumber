//
//  MainMenu.swift
//  SlumbeR
//
//  Created by Amir Mairaj on 2/19/23.
//
import SwiftUI
import HealthKit
import SwiftUICharts


struct SleepDataChart: View {
    let healthStore = HKHealthStore()
    let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
    
    @State var sleepData: [(Date, Double)] = []
        
        var body: some View {
//                    HStack (alignment: .top){ // << moved this up to ZStack
//                        Text("Top Text")
//                            .fontWeight(.light)
//                            .multilineTextAlignment(.center)
//                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
//                            .font(.body)
//                    }
                   
            VStack {
                Text("\(greetingLogic()), \(name)")
                    .multilineTextAlignment(.center)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30)
                    .foregroundColor(themeColor)
                    .shadow(color: themeColor, radius: 16)
                    .padding(.top, 60)
                    .padding(.bottom, 30)
                    .font(.system(size: 40, weight: .bold, design: .default))
                //FIGURE OUT WHY THIS IS SURROUNDED BY A BOX, ALSO IS THIS A GRAPH?
                // PieChartView(data: sleepData.map { $0.1 }, title: "Sleep Data").padding()
                LineChartView(data: sleepData.map { $0.1 }, title: "Sleep Data").padding()
                
                
                Button("Refresh Sleep Data") {
                    authorizeHealthKit()
                    fetchSleepData()
                }
            }
        }
    func authorizeHealthKit() {
        self.healthStore.requestAuthorization(toShare: [], read: [self.sleepType]) { (success,error) in
            if !success {
                print("Authorization failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    @available(iOS 16.0, *)
    func fetchSleepData() {
        let calendar = Calendar.current
        let now = Date()
        let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: now)!
        let predicate = HKQuery.predicateForSamples(withStart: oneWeekAgo, end: now, options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: self.sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
            if let samples = samples as? [HKCategorySample] {
                let data = samples.map { sample -> (Date, Double) in
                    let value = sample.value == HKCategoryValueSleepAnalysis.asleepREM.rawValue ? 1.0 : 0.0
                    return (sample.startDate, value)
                }
                self.sleepData = data
            }
        }
        
        self.healthStore.execute(query)
    }
}




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




    

struct SleepDataChart_Previews: PreviewProvider {
    static var previews: some View {
        SleepDataChart()
    }
}
