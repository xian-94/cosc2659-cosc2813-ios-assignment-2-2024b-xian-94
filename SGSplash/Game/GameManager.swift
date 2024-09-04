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

import Foundation
import SpriteKit
import AVFoundation

class GameManager: ObservableObject {
    // MARK: Game Manager properties and initialization
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
    @Published var timeRemaining: Int = 0
    var timeLimit: Int?
    var timer: Timer?
    // Handle save and resume game
    @Published var gameState: GameState
    // Handle user preferences
    @Published var mode: String
    @Published var characters: String
    
    
    let scene: GameScene
    var level: Level
    
    init(viewSize: CGSize, mode: String, levelNumber: Int, savedGame: GameState? = nil, characters: String = "food") {
        self.mode = mode
        self.characters = characters
        // Initialization
        if let savedGame = savedGame {
            self.gameState = savedGame
            self.level = Level(levelPack: LevelData.getLevelPack(mode: mode, cSet: characters), levelNumber: savedGame.level, characterSet: characters)
            
        } else {
            self.level = Level(levelPack: LevelData.getLevelPack(mode: mode, cSet: characters), levelNumber: levelNumber, characterSet: characters)
            self.gameState = GameState(level: levelNumber, score: 0, movesLeft: self.level.moves, goals: self.level.goals, timeRemaining: self.level.timeLimit ?? 0)
        }
        
        
        scene = GameScene(size: viewSize)
        scene.level = self.level
        scene.scaleMode = .aspectFill
        scene.backgroundColor = .clear
        scene.swipeHandler = handleSwipe
        scene.addTiles()
        // Intialize based on the saved game
        if savedGame == nil {
            startGame()
        } else {
            resumeGame()
        }
    }
    
    
    // MARK: Timer management
    // Count down the time
    func countdown() {
        if self.timeRemaining > 0 {
            self.timeRemaining -= 1
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
    
    // MARK: Start and resume game logic
    func startGame() {
        self.goals = level.goals
        self.moves = level.moves
        self.score = 0
        if let limit = self.level.timeLimit {
            self.timeLimit = limit
            self.timeRemaining = limit
            startTimer()
        }
        
        level.resetCombo()
        shuffle()
    }
    
    func shuffle() {
        scene.removeSprites()
        let newTiles = level.shuffle()
        scene.addSprites(for: newTiles)
    }
    
    func resumeGame() {
        self.timeRemaining = gameState.timeRemaining
        self.goals = gameState.goals
        self.moves = gameState.movesLeft
        self.score = gameState.score
        // Restart the timer if there's time remaining
        if timeRemaining > 0 {
            startTimer()
        }
        
        level.resetCombo()
        level.detectPossibleSwaps()
        
        userInteractionEnabled = true
        
    }
    
    // MARK: Manage swipe gestures and chains
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
    
    private func updateGoals(with reduction: [String: Int]) {
        for i in 0..<gameState.goals.count {
            if let reductionAmount = reduction[gameState.goals[i].target] {
                gameState.goals[i].quantity = max(0, gameState.goals[i].quantity - reductionAmount)
            }
        }
    }
    
    private func updateScore(for chains: Set<Chain>) {
        for chain in chains {
            gameState.score += chain.score
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
            self.updateGoals(with: reduction)
            self.updateScore(for: chains)
            let columns = self.level.fillHoles()
            self.scene.animateFallingElements(in: columns) {
                let topUpColumns = self.level.topUpElements()
                self.scene.animateNewElements(in: topUpColumns) {
                    self.handleChains()
                }
            }
        }
    }
    
    // MARK: Level accomplishment and game over logic
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
        for i in 0..<gameState.goals.count{
            if gameState.goals[i].quantity < 0 {
                gameState.goals[i].quantity = 0
            }
        }
        gameState.movesLeft -= 1
        if gameState.movesLeft < 0 {
            gameState.movesLeft = 0
        }
        if gameState.movesLeft >= 0 && isAccomplished(goals: gameState.goals){
            isComplete = true
            // Stop timer when complete ahead of time
            timer?.invalidate()
            // Save player
            if self.mode != "tutorial" {
                completeLevel()
            }
        }
        else if gameState.movesLeft <= 0 {
            isGameOver = true
            // Stop the timer when out of moves
            timer?.invalidate()
        }
        else {
            self.userInteractionEnabled = true
        }
        
    }
    
    // MARK: Save and load game state
    func saveGame() {
        if let encoded = try? JSONEncoder().encode(gameState) {
            UserDefaults.standard.set(encoded, forKey: "savedGame")
            print("Game saved")
        }
    }
    
    static func loadSavedGame() -> GameState? {
        if let savedGameState = UserDefaults.standard.data(forKey: "savedGame"),
           let decodedState = try? JSONDecoder().decode(GameState.self, from: savedGameState) {
            return decodedState
        }
        return nil
    }
    
    // Remove game state when starting a new game
    func resetGame() {
        UserDefaults.standard.removeObject(forKey: "savedGame")
        gameState = GameState(level: level.number, score: 0, movesLeft: level.moves, goals: level.goals, timeRemaining: level.timeLimit ?? 0)
    }
    
    // MARK: Handle update achievements based on score and combo
    // Get the list of achievements in a level
    func getAchievements(for player: Player) -> [String] {
        var achievements: [String] = []
        // First step badge for reaching 1000 points
        if gameState.score >= 1000 && !player.achievementBadge.contains("firstStep") {
            achievements.append("firstStep")
        }
        // Strategist badge for reaching 2000 points
        if gameState.score >= 2000 && !player.achievementBadge.contains("strategist") {
            achievements.append("strategist")
        }
        // Conqueror badge for reaching 300
        if gameState.score >= 3000 && !player.achievementBadge.contains("conqueror") {
            achievements.append("conqueror")
        }
        // Combo King for getting more than 5 combos
        if self.level.getCombo() > 5 && !player.achievementBadge.contains("comboKing") {
            achievements.append("comboKing")
        }
        
        return achievements
    }
    
    // Update the achievements in the user defaults
    private func updateAchievements(player: Player) {
        var player = player
        let achievements = getAchievements(for: player)
        for achievement in achievements {
            if !player.achievementBadge.contains(achievement) {
                player.achievementBadge.append(achievement)
            }
        }
        // Save updated player to UserDefaults
        player.saveToUserDefaults()
        savePlayer(player: player)
    }
    
    private func savePlayer(player: Player) {
        var players = UserDefaults.standard.players(forKey: "players") ?? leaderboard
        // Find the current player's position
            if let index = players.firstIndex(where: { $0.username == player.username }) {
                // Save the new player
                players[index] = player
                UserDefaults.standard.setPlayers(players, forKey: "players")
            }
    }
    
    // MARK: Update level score
    private func updateLevelScore(for player: inout Player, level: Int, newScore: Int) {
        // Check if the level already has a score
        if let existingScore = player.scoreByLevel[String(level)] {
            // Update the score only if the new score is higher
            if newScore > existingScore {
                player.scoreByLevel[String(level)] = newScore
            }
        } else {
            // If no score exists for this level, simply add the new score
            player.scoreByLevel[String(level)] = newScore
        }
        
        // Save updated player to UserDefaults
        player.saveToUserDefaults()
        savePlayer(player: player)
    }
    
    // Update player upon completing the level
    func completeLevel() {
        if var currentUser = Player.loadFromUserDefaults() {
            let levelNumber = gameState.level
            let finalScore = gameState.score

            // Update the player's score for this level
            updateLevelScore(for: &currentUser, level: levelNumber + 1, newScore: finalScore)
            
            // Check for and handle new achievements
            updateAchievements(player: currentUser)
        }
    }
    
    
    
}
