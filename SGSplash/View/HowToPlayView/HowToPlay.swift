//
//  HowToPlay.swift
//  SGSplash
//
//  Created by Xian on 1/9/24.
//

import Foundation
import SwiftUI
import SpriteKit

struct HowToPlay: View {
    @AppStorage("user_theme") private var theme: Theme = .light
    @StateObject private var gameManager: GameManager
    @State private var currentStep: Int = 0
    @State private var highlightSwap: Swap? = nil
    @Environment(\.dismiss) var dismiss
    
    let midY = UIScreen.main.bounds.height / 2
    
    // Initialization
    init() {
        _gameManager = StateObject(wrappedValue: GameManager(
            viewSize: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height),
            mode: "tutorial",
            levelNumber: 0
        ))
    }
    var body: some View {
        ZStack {
            Image(theme == .light ? "lightBackground" : "darkbg")
                .resizable()
                .ignoresSafeArea(.all)
            if gameManager.isComplete {
                LevelComplete(achievements: [], combo: gameManager.level.getCombo(), score: gameManager.gameState.score)
                    .shadow(radius: 10)
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                    .transition(.scale)
                    .zIndex(10)
                    .onAppear() {
                        playSound(name: "level-complete", type: "mp3")
                    }
            }
            else if gameManager.isGameOver {
                GameOver()
                    .shadow(radius: 10)
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                    .transition(.scale)
                    .zIndex(10)
                    .onAppear() {
                        playSound(name: "game-over", type: "mp3")
                    }
            }
            VStack(spacing: 5) {
                Spacer()
                TargetBox(gameManager: gameManager)
                SpriteView(scene: gameManager.scene, options: [.allowsTransparency])
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
                    .ignoresSafeArea(.all)
                // Prevent user interaction during swapping
                    .disabled(!gameManager.userInteractionEnabled)
                    .onAppear {
                        highlightSwap = nil
                    }
                    .onChange(of: currentStep) { old, newStep in
                        if newStep == 4 {
                            // Highlight the swap in step 4
                            highlightSwap = gameManager.level.getPossibleSwaps().first
                            if let swap = highlightSwap {
                                gameManager.scene.showSelectionEffect(of: swap.elementA)
                            }
                        } else {
                            // Remove highlight for other steps
                            if highlightSwap != nil {
                                gameManager.scene.hideSelectionEffect()
                            }
                            highlightSwap = nil
                        }
                    }
                
            }
            
            // Overlay for How to Play tutorial
            VStack {
                // Welcome to tutorial text
                if currentStep == 0 {
                    Text("Welcome!")
                        .modifier(TutorialText())

                }
                
                // Show targets instruction
                if currentStep == 1 {
                    Text("These are your targets. Complete them to win!")
                        .modifier(TutorialText())
                    BouncingArrow(rotationDegree: 180,
                                  xPos: UIScreen.main.bounds.width / 2 + UIScreen.main.bounds.width * 0.15, yPos: midY - UIScreen.main.bounds.height * 0.82, direction: "vertical")
                }
                
                // Show moves instruction
                if currentStep == 2 {
                    Text("These are your moves. Use them wisely!")
                        .modifier(TutorialText())
                    BouncingArrow(rotationDegree: 180,
                                  xPos: UIScreen.main.bounds.width * 0.25, yPos: midY - UIScreen.main.bounds.height * 0.82, direction: "vertical")
                }
                
                // Show score instruction
                if currentStep == 3 {
                    Text("Earn your score by making a move!")
                        .modifier(TutorialText())
                    BouncingArrow(rotationDegree: 0,
                                  xPos: UIScreen.main.bounds.width * 0.55, yPos: midY - UIScreen.main.bounds.height * 0.82, direction: "horizontal")
                }
                
                if currentStep == 4 {
                    Text("Swipe bottom up and from left to right. Try to complete the goals!")
                        .modifier(TutorialText())
                }
            }
            
            // Next and back button
            HStack {
                if currentStep > 0 {
                    Button(action: {
                            currentStep -= 1
                    }) {
                        Image(systemName: "arrow.left")
                            .modifier(TitleTextSizeModifier())
                            .foregroundStyle(Color.appText)
                    }
                    .position(x: UIScreen.main.bounds.width * 0.4, y: UIScreen.main.bounds.height * 0.12)
                  
                }
                
                // Display the Back and Next arrows
                if currentStep < 4 {
                    Button(action: {
                            currentStep += 1
                    }) {
                        Image(systemName: "arrow.right")
                            .modifier(TitleTextSizeModifier())
                            .foregroundStyle(Color.appText)
                    }
                    .position(x: UIScreen.main.bounds.width * 0.02, y: UIScreen.main.bounds.height * 0.12)
                }
            }
            .padding(.horizontal, 20)
        }
        .navigationBarBackButtonHidden(true)
        .animation(.easeInOut, value: currentStep)
        .animation(.easeInOut, value: gameManager.isGameOver || gameManager.isComplete)
        
    }
}

struct HowToPlay_Preview: PreviewProvider {
    static var previews: some View {
        HowToPlay()
    }
}
