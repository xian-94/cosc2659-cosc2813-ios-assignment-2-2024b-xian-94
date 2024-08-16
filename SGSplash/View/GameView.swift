import SwiftUI
import SpriteKit

struct GameView: View {
    
    @StateObject private var gameManager: GameManager
    
    init() {
        let viewSize = UIScreen.main.bounds.size
        _gameManager = StateObject(wrappedValue: GameManager(viewSize: viewSize))
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: gameManager.scene)
                .edgesIgnoringSafeArea(.all)
            // Prevent user interaction during swapping 
                .disabled(!gameManager.userInteractionEnabled)
            
            VStack {
                Spacer()
                HStack {
                    Text("Score: \(gameManager.score)")
                        .font(.title)
                    Spacer()
                    Text("Moves Left: \(gameManager.movesLeft)")
                        .font(.title)
                }
                .padding()
                
                Button(action: {
                    gameManager.shuffle()
                }) {
                    Text("Shuffle")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
    }
}


struct GameView_Preview: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
