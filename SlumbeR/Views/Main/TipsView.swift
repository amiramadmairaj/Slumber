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

    var cards: [String] = []
    init() {
        if my_age == 18{
            cards.append("Uh Oh! You're not getting enough sleep. Ideally, you should aim for 7-9 hours of sleep per night. Avoid using electronic devices before bed, as the blue light can interfere with sleep.")
            cards.append("You're not getting enough REM sleep. It is recommended that 20-25% of your total sleep time should be spent in REM sleep.Try creating an ideal environment for sleep. That means no bright lights, not too hot and not too cold, and don’t watch television or work on the computer in the bedroom.")
            cards.append("You're not getting enough deep sleep. It is recommended that 20-25% of your total sleep time should be spent in REM sleep.Try adding more fiber to your diet. Research suggests that a higher intake of fiber can increase the amount of time spent in the deep sleep stage.")
            }
        }

    @State private var isShowing: [Bool] = Array(repeating: false, count: 7)

    var body: some View {

        VStack {

            Text("Advice For You")
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
