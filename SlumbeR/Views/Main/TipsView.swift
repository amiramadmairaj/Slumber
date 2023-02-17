//
//  TipsView.swift
//  SlumbeR
//
//  Created by Reisha Ladwa on 2/14/23.
//

//
import SwiftUI

struct TipsView: View {
    
    
    //add if statements here to change up the "cards" list for personalization
    let cards = ["Drink water", "Sleep more", "Ur mom", "Hello", "Bye bye", "Queen RiRi", "Listen to this very important piece of advice for ur sleep basically you have to sleep more so that you get good rest okay"]


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
//                            .frame(height: 600)
                        Text(card)
                            .font(.system(size: 25, weight: .light, design: .rounded))
                            .foregroundColor(Color.cardText)
                    }
                    .frame(height: 120)
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
