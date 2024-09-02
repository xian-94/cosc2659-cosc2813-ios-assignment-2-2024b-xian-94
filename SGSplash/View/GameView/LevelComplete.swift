//
//  LevelComplete.swift
//  SGSplash
//
//  Created by Xian on 23/8/24.
//

import Foundation
import SwiftUI

struct LevelComplete: View {
    var achievements: [String]
    var combo: Int
    var score: Int
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            Rectangle()
                .frame(maxWidth: UIScreen.main.bounds.width * 0.8, minHeight: UIScreen.main.bounds.height * 0.45, maxHeight: UIScreen.main.bounds.height * 0.5)
                .foregroundColor(Color.background)
                .cornerRadius(20)
            VStack(spacing: 20) {
                Text("Level Complete!")
                    .modifier(TitleTextSizeModifier())
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(Color.appPrimary)
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: UIScreen.main.bounds.width * 0.2) {
                        Text("Score")
                            .foregroundStyle(Color.appText)
                            .modifier(MediumTextSizeModifier())
                        Text("\(score)")
                            .modifier(MediumTextSizeModifier())
                            .foregroundStyle(Color.appText)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    HStack(spacing: UIScreen.main.bounds.width * 0.2) {
                        Text("Combos")
                            .modifier(MediumTextSizeModifier())
                            .foregroundStyle(Color.appText)
                        Text("\(combo)")
                            .modifier(MediumTextSizeModifier())
                            .foregroundStyle(Color.appText)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    if !achievements.isEmpty {
                        Text("Achievements")
                            .foregroundStyle(Color.appText)
                            .modifier(MediumTextSizeModifier())
                        HStack {
                            ForEach(achievements, id: \.self) { a in
                                Image("\(a)")
                                    .resizable()
                                    .frame(minWidth: UIScreen.main.bounds.width * 0.2, maxWidth: UIScreen.main.bounds.width * 0.3, minHeight: UIScreen.main.bounds.height * 0.1, maxHeight: UIScreen.main.bounds.height * 0.15)
                            }
                        }
                    }
                }
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                })  {
                    Text("Back to Level")
                        .modifier(MediumTextSizeModifier())
                        .foregroundStyle(Color.appSecondary)
                }
            }
        }
    }
}

struct LevelComplete_Preview: PreviewProvider {
    static var previews: some View {
        LevelComplete(achievements: ["firstStep", "comboKing"], combo: 5, score: 1000)
    }
}
