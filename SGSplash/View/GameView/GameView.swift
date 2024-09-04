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

import SwiftUI
import SpriteKit

struct GameView: View {
    @AppStorage("user_theme") private var theme: Theme = .light
    @StateObject private var gameManager: GameManager
    @Environment(\.dismiss) var dismiss
    private var currentPlayer: Player?

    let midY = UIScreen.main.bounds.height / 2
    
    // Initialization with or without saved game 
    init(savedGame: GameState? = nil, levelNumber: Int) {
        let mode = UserDefaults.standard.string(forKey: "diffMode") ?? "easy"
        let characters = UserDefaults.standard.string(forKey: "characters") ?? "food"
        currentPlayer = Player.loadFromUserDefaults()
            
        _gameManager = StateObject(wrappedValue: GameManager(
               viewSize: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height),
               mode: mode,
               levelNumber: levelNumber,
               savedGame: savedGame,
               characters: characters
           ))
        }
   
    var body: some View {
        ZStack {
            Image(theme == .light ? "lightBackground" : "darkbg")
                .resizable()
                .ignoresSafeArea(.all)
            
            // Show the level complete box
            if gameManager.isComplete {
                LevelComplete(achievements: gameManager.getAchievements(for: currentPlayer!), combo: gameManager.level.getCombo(), score: gameManager.gameState.score)
                    .shadow(radius: 10)
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                    .transition(.scale)
                    .zIndex(10)
                    .onAppear() {
                        playSound(name: "level-complete", type: "mp3")
                    }
            }
            
            // Show game over box
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
                HStack {
                    ZStack {
                        // Level box
                        UnevenRoundedRectangle( topLeadingRadius: 100, bottomLeadingRadius: 0, bottomTrailingRadius: 100, topTrailingRadius: 100, style: .continuous)
                            .frame(minWidth: UIScreen.main.bounds.width * 0.1, maxWidth: UIScreen.main.bounds.width * 0.3, maxHeight: UIScreen.main.bounds.height * 0.1)
                            .foregroundColor(.appPrimary)
                            .shadow(radius: 5, y: 5)
                        Text("Level \(gameManager.level.number)")
                            .modifier(TitleTextSizeModifier())
                            .foregroundColor(.appText)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    .offset(x: -50, y: -20)
                    
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "arrowshape.backward.fill")
                                .modifier(MediumTextSizeModifier())
                                .foregroundStyle(Color.appSecondary)
                        }
                        .modifier(CircleButtonStyle())
                    }
                    .offset(x: 50, y: -20)
                }
                TargetBox(gameManager: gameManager)
                SpriteView(scene: gameManager.scene, options: [.allowsTransparency])
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
                    .ignoresSafeArea(.all)
                // Prevent user interaction during swapping
                    .disabled(!gameManager.userInteractionEnabled)
                
            }

            
        }
        .navigationBarBackButtonHidden(true)
        .animation(.easeInOut, value: gameManager.isGameOver || gameManager.isComplete)
        .onAppear {
            gameManager.startGame()
        }
        .onDisappear {
            gameManager.saveGame()
        }
    }
}


struct GameView_Preview: PreviewProvider {
    static var previews: some View {
        GameView(levelNumber: 1)
    }
}
