import SwiftUI
import SpriteKit

struct GameView: View {
    @AppStorage("user_theme") private var theme: Theme = .light
    @StateObject private var gameManager: GameManager
    @Environment(\.dismiss) var dismiss

    let midY = UIScreen.main.bounds.height / 2
    
    // Initialization with or without saved game 
    init(savedGame: GameState? = nil, levelNumber: Int) {
        let mode = UserDefaults.standard.string(forKey: "diffMode") ?? "easy"
            
        _gameManager = StateObject(wrappedValue: GameManager(
               viewSize: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height),
               mode: mode,
               levelNumber: levelNumber,
               savedGame: savedGame
           ))
        }
   
    var body: some View {
        ZStack {
            Image(theme == .light ? "lightBackground" : "darkbg")
                .resizable()
                .ignoresSafeArea(.all)
            if gameManager.isComplete {
                LevelComplete()
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
                HStack {
                    ZStack {
                        UnevenRoundedRectangle( topLeadingRadius: 100, bottomLeadingRadius: 0, bottomTrailingRadius: 100, topTrailingRadius: 100, style: .continuous)
                            .frame(minWidth: UIScreen.main.bounds.width * 0.1, maxWidth: UIScreen.main.bounds.width * 0.3, maxHeight: UIScreen.main.bounds.height * 0.1)
                            .foregroundColor(.appPrimary)
                            .shadow(radius: 5, y: 5)
                        Text("Level \(gameManager.level.number)")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.appText)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    .offset(x: -50, y: -20)
                    
                    HStack {
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                            Image(systemName: "gearshape.fill")
                                .foregroundStyle(Color.appSecondary)
                        }
                        .modifier(CircleButtonStyle())
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "pause.fill")
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
            if GameManager.loadSavedGame() == nil {
                gameManager.startGame()
            }
            else {
                gameManager.resumeGame()
            }
        }
        .onDisappear {
            gameManager.saveGame()
        }
    }
}


struct GameView_Preview: PreviewProvider {
    static var previews: some View {
        GameView(levelNumber: 0)
    }
}
