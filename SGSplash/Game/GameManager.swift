import Foundation
import SpriteKit
import AVFoundation

class GameManager: ObservableObject {
    
    @Published var score = 0
    @Published var movesLeft = 0
    
    let scene: GameScene
    private var level: Level
    
    init(viewSize: CGSize) {
        level = Level(level: 1)
        scene = GameScene(size: viewSize)
        scene.level = level
        scene.scaleMode = .aspectFill
        scene.addTiles()
     
        
    }
    
    func startGame() {
        shuffle()
    }
    
    func shuffle() {
        let newTiles = level.shuffle()
        scene.addSprites(for: newTiles)
    }
}
