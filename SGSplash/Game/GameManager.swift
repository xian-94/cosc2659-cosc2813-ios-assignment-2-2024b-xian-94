import Foundation
import SpriteKit
import AVFoundation

class GameManager: ObservableObject {
    
    @Published var score = 0
    @Published var movesLeft = 0
    
    let scene: GameScene
    var level: Level!
    
    init(viewSize: CGSize) {
        scene = GameScene(size: viewSize)
        scene.scaleMode = .aspectFill
        scene.level = level
        level = Level()
//        scene.addTiles()
     
        
    }
    
    func startGame() {
        shuffle()
    }
    
    func shuffle() {
        let newTiles = level.shuffle()
        scene.addSprites(for: newTiles)
    }
}
