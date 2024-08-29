import Foundation
import SpriteKit
import AVFoundation

class GameManager: ObservableObject {
    
    // Manage user interaction
    @Published var userInteractionEnabled = true
    // Manange level goals
    @Published var goals: [Goal] = []
    @Published var moves: Int = 0
    @Published var score: Int = 0
    // Manage winning or losing
    @Published var isGameOver: Bool = false
    @Published var isComplete: Bool = false
    // Manage countdown timer
    @Published var timeRemaning: Int = 0
    var timer: Timer?
    
    let scene: GameScene
    var level: Level
    
    init(viewSize: CGSize, mode: String, levelNumber: Int) {
        // Initialization
        self.level = Level(levelPack: easyLevels, levelNumber: levelNumber)
        
        // Set the level with chosen mode
            switch mode {
            case "easy":
                self.level = Level(levelPack: easyLevels, levelNumber: levelNumber)
            case "medium":
                self.level = Level(levelPack: medLevels, levelNumber: levelNumber)
            case "hard":
                self.level = Level(levelPack: hardLevels, levelNumber: levelNumber)
            default:
                break
            }
        scene = GameScene(size: viewSize)
        scene.level = self.level
        scene.scaleMode = .aspectFill
        scene.backgroundColor = .clear
        scene.swipeHandler = handleSwipe
        scene.addTiles()
        startGame()
    }
    
    // Count down the time
    func countdown() {
        if timeRemaning > 0 {
            timeRemaning -= 1
        }
        else {
            // Game over when the timer stops
            timer?.invalidate()
            isGameOver = true
            
        }
    }
    
    // Start the countdown
    func startTimer() {
        timer?.invalidate() // Stop any existing timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
            [weak self] _ in
            self?.countdown()
        }
    }
    
    func startGame() {
        self.goals = level.goals
        self.moves = level.moves
        self.score = 0
        if let limit = level.timeLimit {
            self.timeRemaning = limit
        }
        startTimer()
        
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
            // Quantity = 0 if it is < 0
            for i in 0..<self.goals.count {
                if reduction.keys.contains(self.goals[i].target) {
                    // Make sure that the quantity is not negative
                    if self.goals[i].quantity - reduction[self.goals[i].target]! <= 0 {
                        self.goals[i].quantity = 0
                    } else {
                        self.goals[i].quantity -= reduction[self.goals[i].target]!
                    }
                }
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
    
    // Check if all the targets are accomplished
    private func isAccomplished(goals: [Goal]) -> Bool {
        var count = 0
        for goal in goals {
            if goal.quantity == 0 {
                count += 1
            }
        }
        // Return true if the quantity count = the number of goals
        if count == goals.count {
            return true
        }
        return false
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
        // Ensure the quantity is not negative
        for i in 0..<goals.count{
            if goals[i].quantity < 0 {
                goals[i].quantity = 0
            }
        }
        self.moves -= 1
        if self.moves < 0 {
            self.moves = 0
        }
        if self.moves >= 0 && isAccomplished(goals: goals){
            isComplete = true
            // Stop timer when complete ahead of time
            timer?.invalidate()
        }
        else if self.moves <= 0 {
            isGameOver = true
            // Stop the timer when out of moves
            timer?.invalidate()
        }
        else {
            self.userInteractionEnabled = true
        }
        
    }
    
    
    
}
