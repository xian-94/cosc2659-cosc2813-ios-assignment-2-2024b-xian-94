/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 2
  Author: Truong Hong Van
  ID: 3957034
  Created  date: 20/08/2024
  Last modified: 04/09/2024
  Acknowledgement:
 Colligan (2018) How to make a game like Candy Crush with SpriteKit: Part 1, Kodeco website, accessed 20/08/2024. https://www.kodeco.com/55-how-to-make-a-game-like-candy-crush-with-spritekit-and-swift-part-1
 Hacking with Swift website, accessed 20/08/2024. https://www.hackingwithswift.com/
 Pereira (2022) Using SpriteKit in a SwiftUI project, Create with Swift website, accessed 20/08/2024. https://www.createwithswift.com/using-spritekit-in-a-swiftui-project/#:~:text=Even%20though%20the%20default%20Game%20Xcode%20Template%20creates%20the%20project
 
*/

import Foundation
import SwiftUI

struct TargetBox: View {
    @ObservedObject var gameManager: GameManager
    var body: some View {
        VStack {
                HStack {
                    if gameManager.timeLimit != nil {
                        Image(systemName: "clock.circle")
                            .foregroundColor(.appAccent)
                            .modifier(TitleTextSizeModifier())
                        Text("\(gameManager.timeRemaining)")
                            .foregroundStyle(Color.appText)
                            .modifier(MediumTextSizeModifier())
                    }
                    Spacer()
                    Text("Score: \(gameManager.gameState.score)")
                        .foregroundColor(.appText)
                        .modifier(MediumTextSizeModifier())
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
                                        .modifier(MediumTextSizeModifier())
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
                                        .modifier(MediumTextSizeModifier())
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
                                                .modifier(MediumTextSizeModifier())
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
                                        .modifier(MediumTextSizeModifier())
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
