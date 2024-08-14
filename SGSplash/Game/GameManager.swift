import Foundation
import SpriteKit
import AVFoundation

class GameManager: ObservableObject {
    
    @Published var score = 0
    @Published var movesLeft = 0
    // Manage user interaction 
    @Published var userInteractionEnabled = true
    
    let scene: GameScene
    private var level: Level
    
    init(viewSize: CGSize) {
        level = Level(level: 1)
        scene = GameScene(size: viewSize)
        scene.level = level
        scene.scaleMode = .aspectFill
        scene.swipeHandler = handleSwipe
        scene.addTiles()
        startGame()
        
        
     
        
    }
    
    func startGame() {
        shuffle()
    }
    
    func shuffle() {
        let newTiles = level.shuffle()
        scene.addSprites(for: newTiles)
    }
    
    // Perform swiping gesture
    func handleSwipe(_ swap: Swap) {
        self.userInteractionEnabled = false
        level.doSwap(swap)
        scene.moveElement(swap) {
            self.userInteractionEnabled = true
        }
    }
}
