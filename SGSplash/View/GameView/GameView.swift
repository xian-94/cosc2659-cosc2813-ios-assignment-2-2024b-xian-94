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
//            if GameManager.loadSavedGame() == nil {
                gameManager.startGame()
//            }
//            else {
//                gameManager.resumeGame()
//            }
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
