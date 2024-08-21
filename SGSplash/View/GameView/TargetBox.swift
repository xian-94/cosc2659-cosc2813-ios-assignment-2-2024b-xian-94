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
        ZStack {
                Rectangle()
                .cornerRadius(10)
                    .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.2)
                    .foregroundColor(Color.background)
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 10 )
                HStack {
                    ZStack {
                        // Moves box
                        ZStack {
                            Rectangle()
                                .cornerRadius(20)
                                .foregroundColor(Color.lightPink)
                                .frame(minWidth: UIScreen.main.bounds.width * 0.2 ,maxWidth: UIScreen.main.bounds.width * 0.3, maxHeight: UIScreen.main.bounds.height * 0.13)
                            Text("\(gameManager.moves)")
                                .font(.title)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        }
                        ZStack {
                            Rectangle()
                                .cornerRadius(20)
                                .frame(minWidth: UIScreen.main.bounds.width * 0.1, maxWidth: UIScreen.main.bounds.width * 0.2, maxHeight: UIScreen.main.bounds.height * 0.05)
                                .foregroundColor(Color.accentGreen)
                                .offset(y: -55)
                            Text("Moves")
                                .offset(y: -55)
                                .font(.title2)
                        }
                    }
                    // Target box
                    ZStack {
                        ZStack {
                            Rectangle()
                                .cornerRadius(20)
                                .foregroundColor(Color.lightPink)
                                .frame(minWidth: UIScreen.main.bounds.width * 0.3 ,maxWidth: UIScreen.main.bounds.width * 0.5, maxHeight: UIScreen.main.bounds.height * 0.13)
                            HStack {
                                Image("\(gameManager.target)")
                                    .resizable()
                                    .frame(minWidth: UIScreen.main.bounds.width * 0.06, maxWidth: UIScreen.main.bounds.width * 0.12, minHeight: UIScreen.main.bounds.width * 0.06, maxHeight: UIScreen.main.bounds.height * 0.07)
                                Text("\(gameManager.quantity)")
                                    .font(.title2)
                            }
                        }
                        ZStack {
                            Rectangle()
                                .cornerRadius(20)
                                .frame(maxWidth: UIScreen.main.bounds.width * 0.3, maxHeight: UIScreen.main.bounds.height * 0.05)
                                .foregroundColor(Color.accentGreen)
                                .offset(y: -55)
                            Text("Goals")
                                .offset(y: -55)
                                .font(.title2)
                        }
                    }
                }
                
                
            }
            .padding()
        }
    }

