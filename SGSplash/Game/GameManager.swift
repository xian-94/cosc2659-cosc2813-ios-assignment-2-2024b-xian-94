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
    @Published var score: Int = 0
    // Manage winning or losing
    @Published var isGameOver: Bool = false
    @Published var isComplete: Bool = false
    
    let scene: GameScene
    var level: Level
    
    init(viewSize: CGSize, levelNumber: Int) {
        level = Level(level: levels[levelNumber])
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
        self.score = 0
        self.quantity = level.quantity
        level.resetCombo()
        shuffle()
    }
    
    func shuffle() {
        scene.removeSprites()
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
            if (self.quantity - reduction == 0) {
                self.quantity = 0
            }
            else {
                self.quantity -= reduction
            }
            // Update the scores
            for chain in chains {
                self.score += chain.score
            }
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
        level.resetCombo()
        level.detectPossibleSwaps()
        // Shuffle if no possible moves found
        if level.getPossibleSwaps().isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.shuffle()
            }
            
        }
        // Make sure quantity and move are not negative
        if self.quantity < 0 {
            self.quantity = 0
        }
        self.moves -= 1
        if self.moves < 0 {
            self.moves = 0
        }
        if self.moves >= 0 && self.quantity == 0 {
            isComplete = true
        }
        else if self.moves <= 0 {
            isGameOver = true
        }
        else {
            self.userInteractionEnabled = true 
        }
        
    }
    
    
    
}
