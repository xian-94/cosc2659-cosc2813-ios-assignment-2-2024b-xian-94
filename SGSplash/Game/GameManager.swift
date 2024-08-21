import Foundation
import SpriteKit
import AVFoundation

class GameManager: ObservableObject {
    
    // Manage user interaction
    @Published var userInteractionEnabled = true
    // Manange level goals
    @Published var target: ElementType = .unknown
    @Published var quantity: Int = 0
    @Published var moves: Int = 0
    
    let scene: GameScene
    var level: Level
    
    init(viewSize: CGSize) {
        level = Level(level: levels[0])
        scene = GameScene(size: viewSize)
        scene.level = level
        scene.scaleMode = .aspectFill
        scene.backgroundColor = .clear
        scene.swipeHandler = handleSwipe
        scene.addTiles()
        startGame()
    }
    
    
    func startGame() {
        self.target = level.target
        self.moves = level.moves
        self.quantity = level.quantity
        shuffle()
    }
    
    func shuffle() {
        let newTiles = level.shuffle()
        scene.addSprites(for: newTiles)
    }
    
    // Perform swiping gesture
    func handleSwipe(_ swap: Swap) {
        self.userInteractionEnabled = false
        if level.isPossibleSwap(swap) {
            level.doSwap(swap)
            scene.moveElement(swap, completion: handleChains)
        }
        else {
            scene.moveInvalidSwap(swap) {
                self.userInteractionEnabled = true
            }
        }
    }
    
    // Handle removing chains
    func handleChains() {
        let chains = level.findAllChains()
        // Player takes control if there are no more matches
        if chains.count == 0 {
            nextTurn()
            return
        }
        scene.animateRemoveChains(for: chains) {
            // Update the target quantity 
            let reduction = self.level.updateQuantity(for: chains)
            self.quantity -= reduction
            let columns = self.level.fillHoles()
            self.scene.animateFallingElements(in: columns) {
                let topUpColumns = self.level.topUpElements()
                self.scene.animateNewElements(in: topUpColumns) {
                    self.handleChains()
                }
            }
        }
    }
    
    // Update the list of possible swaps before granting player control
    func nextTurn() {
        level.detectPossibleSwaps()
        self.userInteractionEnabled = true
        self.moves -= 1
    }
    
    
    
}
