//
//  TipsView.swift
//  SlumbeR
//
//  Created by Reisha Ladwa on 2/14/23.
//

//
import SwiftUI

let my_age = 18

struct TipsView: View {
    @Environment(\.managedObjectContext) var managedContext
    @FetchRequest(sortDescriptors: []) var userProfiles: FetchedResults<UserProfile>

    @State private var isShowing: [Bool] = Array(repeating: false, count: 7)
    @State private var cards: [String] = []
    
    var body: some View {
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
        

        let oversleeping = ["NO WAY! You’ve overslept. Avoid hitting that snooze button!", "Uh Oh! You’ve overslept. Avoid napping during the day. It can throw off your sleep schedule and make it harder to fall asleep at night.", "Uh Oh! You’ve overslept. Reward yourself for getting up on time. Making your morning routine satisfying and rewarding will make you more eager to wake up on time. Consider preparing a healthy breakfast or scheduling a short morning walk to reward yourself for adhering to your sleep schedule.", "Uh Oh! You’ve overslept. Putting technology away before bed is one step to knowing how to sleep less and better."]
        
        
        let notEnoughRemTips = ["You're not getting enough REM sleep. It is recommended that 20-25% of your total sleep time should be spent in REM sleep. To achieve this, try establishing a consistent sleep schedule and engaging in regular exercise.", "You're not getting enough REM sleep. It is recommended that 20-25% of your total sleep time should be spent in REM sleep. Avoid alcoholic drinks at night. Though they may initially make you sleepy, they actually interfere with sleep, particularly REM sleep.", "You're not getting enough REM sleep. It is recommended that 20-25% of your total sleep time should be spent in REM sleep.Try creating an ideal environment for sleep. That means no bright lights, not too hot and not too cold, and don’t watch television or work on the computer in the bedroom."]
        
        let notEnoughDeepTips = ["You're not getting enough deep sleep. It is recommended that 20-25% of your total sleep time should be spent in deep sleep. Try adding more fiber to your diet. Research suggests that a higher intake of fiber can increase the amount of time spent in the deep sleep stage.", "You're not getting enough deep sleep. It is recommended that 13-23% of your total sleep time should be spent in deep sleep. Avoid consuming caffeine as it can make it harder for you to fall and stay asleep, and reduce the amount of deep sleep you get. Instead, try drinking water, tea, or decaffeinated beverages. Certain drinks, like warm milk or chamomile tea, may also help promote better sleep.", "You're not getting enough deep sleep. It is recommended that 13-23% of your total sleep time should be spent in deep sleep. Try using white noise to block out external sounds if you live in a noisy area. Listening to pink noise, which includes calming nature sounds like rainfall or waves crashing, can increase deep sleep."]
        
        
        let exerFlag = (curUser.avgExercise < projectedExercise)
        let deepFlag = (myDict["deepPercent"]! < idealDeep)
        let remFlag = (myDict["remPercent"]! < idealREM)
        let randomNum = Int.random(in: 0...2)
        var oversleepThresh = 11
        var insufficientThresh = 7
        var appropriateSleep = (7,9)
        VStack {
            Text("Advice For You")
                .onAppear {
                    
                    switch curUser.age {
                    case 1..<2:
                        oversleepThresh = 16
                    case 3..<5:
                        oversleepThresh = 14
                    case 6..<13:
                        oversleepThresh = 12
                    case 14..<25:
                        oversleepThresh = 11
                    case 26..<64:
                        oversleepThresh = 10
                    case 65..<150:
                        oversleepThresh = 9
                    default:
                        break
                    }
                    
                    switch curUser.age {
                    case 1..<2:
                        insufficientThresh = 9
                    case 3..<5:
                        insufficientThresh = 8
                    case 6..<17:
                        insufficientThresh = 7
                    case 18..<64:
                        insufficientThresh = 6
                    case 65..<150:
                        insufficientThresh = 5
                    default:
                        break
                    }
                    
                    switch curUser.age {
                    case 1..<2:
                        appropriateSleep = (11,14)
                    case 3..<5:
                        appropriateSleep = (10, 13)
                    case 6..<12:
                        appropriateSleep = (9,12)
                    case 13..<18:
                        appropriateSleep = (8,10)
                    case 18..<64:
                        appropriateSleep = (7,9)
                    case 65..<150:
                        appropriateSleep = (7,8)
                    default:
                        break
                    }
                    
                    let notEnoughSleepTips = ["You're not getting enough sleep. Based on your age group, you should aim for \(appropriateSleep.0) - \(appropriateSleep.1) hours of sleep per night. Try establishing a consistent sleep schedule and prioritizing sleep.", "Uh Oh! You're not getting enough sleep. Based on your age group, you should aim for \(appropriateSleep.0) - \(appropriateSleep.1) hours of sleep per night. Consider establishing a relaxing bedtime routine, such as taking a warm bath, reading a book, or listening to calming music.", "Yikes! You're not getting enough sleep. Based on your age group, you should aim for \(appropriateSleep.0) - \(appropriateSleep.1) hours of sleep per night. Avoid using electronic devices before bed, as the blue light can interfere with sleep."]
                    
                    if (cards.isEmpty) {
                        // sleep duration recommendation
                        if (myDict["sleepDuration"]! < Double(insufficientThresh)) {
                            cards.append(notEnoughSleepTips[randomNum])
                        } else if (myDict["sleepDuration"]! > Double(oversleepThresh)){
                            cards.append(oversleeping[Int.random(in: 0...3)])
                        } else {
                            cards.append("Fantastic! You got a healthy amount of sleep!")
                        }
                        
                        // rem sleep recommendation
                        if (remFlag) {
                            cards.append(notEnoughRemTips[randomNum])
                        } else {
                            cards.append("Great Job! You’ve got a healthy amount of REM sleep!")
                        }
                        
                        // deep sleep recommendation
                        if (deepFlag) {
                            cards.append(notEnoughDeepTips[randomNum])
                        } else {
                            cards.append("Great Job! You’ve got a healthy amount of deep sleep!")
                        }
                        
                        // exercise recommendation
                        if (exerFlag) {
                            var exerciseStr = ""
                            switch curUser.age {
                            case 1..<2:
                                exerciseStr = "You are too young to be active!"
                            case 3..<5:
                                exerciseStr = "We noticed that you are less active than the CDC recommended amount of activity. According to the CDC, you should be having physical activities everyday of the week and having active play!"
                            case 6..<17:
                                exerciseStr = "We noticed that you are less active than the CDC recommended amount of activity. According to the CDC, you should be engaged in an hour of moderate to vigorous activity daily, preferably including activities that strengthen muscle, bones, and cardiovascular health."
                            case 18..<150:
                                exerciseStr = "We noticed that you are less active than the CDC recommended amount of activity. According to the CDC, you should exercise at least 2.5 hours a week, and aim to strengthen your muscles twice a week."
                            default:
                                exerciseStr = "Just move more bro."
                            }
                            cards.append(exerciseStr)
                        } else {
                            cards.append("Great job! You’ve been exercising a healthy amount each week.")
                        }
                    }
                    print(cards.count)
                }
                .foregroundColor(themeColor)
                .shadow(color: themeColor, radius: 16)
                .padding(.top, 60)
                .padding(.bottom, 30)
                .font(.system(size: 40, weight: .bold, design: .default))
            List {
                ForEach(Array(cards.enumerated()), id: \.1) { (index, card) in
                    ZStack {
                        RoundedRectangle(cornerRadius: 37)
                            .fill(Color(red: 0.726, green: 0.671, blue: 1.000, opacity: 1.0))
                            .shadow(color: Color.cardShadow, radius: 10, x: 0, y: 8)
                            .padding(.vertical, 10) // add space between each card
                        Text(card)
                            .font(.system(size: 25, weight: .light, design: .rounded))
                            .foregroundColor(Color.cardText)
                            .padding(20) // add padding to text
                            .multilineTextAlignment(.center)
                    }
                    .frame(height: 400)
                    .padding(.horizontal)
                    .offset(x: self.isShowing[index] ? 0 : 500)
                    .onAppear {
                        withAnimation(.easeOut(duration: 0.7).delay(Double(index) * 0.2)) {
                            self.isShowing[index] = true
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())

        }
    }
}


struct TipsView_Previews: PreviewProvider {
    static var previews: some View {
        TipsView()
            .environment(\.colorScheme, .light)
    }
}

extension Color {
    static let cardBackground = Color(UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0))
    static let cardShadow = Color(UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3))
    static let cardText = Color(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0))
}
