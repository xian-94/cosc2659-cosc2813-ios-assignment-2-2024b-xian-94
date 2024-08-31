//
//  TargetBox.swift
//  SGSplash
//
//  Created by Xian on 21/8/24.
//

import Foundation
import SwiftUI

//TODO: Change font later
struct TargetBox: View {
    @ObservedObject var gameManager: GameManager
    var body: some View {
        VStack {
//            if let gameState = gameManager.gameState {
                HStack {
                    if gameManager.timeLimit != nil {
                        Image(systemName: "clock.circle")
                            .foregroundColor(.appAccent)
                            .font(.largeTitle)
                        Text("\(gameManager.gameState.timeRemaining)")
                            .foregroundStyle(Color.appText)
                            .font(.title2)
                    }
                    Spacer()
                    Text("Score: \(gameManager.gameState.score)")
                        .foregroundColor(.appText)
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                ZStack {
                    Rectangle()
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.2)
                        .foregroundColor(Color.background)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 10 )
                    VStack {
                        HStack {
                            ZStack {
                                // Moves box
                                ZStack {
                                    Rectangle()
                                        .cornerRadius(20)
                                        .foregroundColor(Color.appTertiary)
                                        .frame(minWidth: UIScreen.main.bounds.width * 0.2 ,maxWidth: UIScreen.main.bounds.width * 0.3, maxHeight: UIScreen.main.bounds.height * 0.13)
                                    Text("\(gameManager.gameState.movesLeft)")
                                        .foregroundColor(.appText)
                                        .font(.title)
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                }
                                ZStack {
                                    Rectangle()
                                        .cornerRadius(20)
                                        .frame(minWidth: UIScreen.main.bounds.width * 0.1, maxWidth: UIScreen.main.bounds.width * 0.2, maxHeight: UIScreen.main.bounds.height * 0.05)
                                        .foregroundColor(Color.appAccent)
                                        .offset(y: -55)
                                    Text("Moves")
                                        .offset(y: -55)
                                        .font(.title2)
                                        .foregroundColor(.appText)
                                }
                            }
                            // Target box
                            ZStack {
                                ZStack {
                                    Rectangle()
                                        .cornerRadius(20)
                                        .foregroundColor(Color.appTertiary)
                                        .frame(minWidth: UIScreen.main.bounds.width * 0.3 ,maxWidth: UIScreen.main.bounds.width * 0.5, maxHeight: UIScreen.main.bounds.height * 0.13)
                                    HStack {
                                        ForEach(gameManager.gameState.goals, id: \.self) { goal in
                                            Image("\(ElementType.getType(name: goal.target))")
                                                .resizable()
                                                .frame(minWidth: UIScreen.main.bounds.width * 0.06, maxWidth: UIScreen.main.bounds.width * 0.12, minHeight: UIScreen.main.bounds.width * 0.06, maxHeight: UIScreen.main.bounds.height * 0.07)
                                            Text("\(goal.quantity)")
                                                .foregroundColor(.appText)
                                                .font(.title2)
                                        }
                                    }
                                }
                                ZStack {
                                    Rectangle()
                                        .cornerRadius(20)
                                        .frame(maxWidth: UIScreen.main.bounds.width * 0.3, maxHeight: UIScreen.main.bounds.height * 0.05)
                                        .foregroundColor(Color.appAccent)
                                        .offset(y: -55)
                                    Text("Goals")
                                        .offset(y: -55)
                                        .font(.title2)
                                }
                            }
                        }
                        
                        
                    }
                }
//            }
        }
        .padding()
    }
}
