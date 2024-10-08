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

import SpriteKit
import SwiftUI


class GameScene: SKScene {
    
    var level: Level?
    // Closure that handle swiping
    var swipeHandler: ((Swap) -> Void)?
    // Set tile's size
    var elementWidth: CGFloat = 44.0
    var elementHeight: CGFloat = 46.0
    var tileWidth: CGFloat = 48
    var tileHeight: CGFloat = 50.0
    
    // Set the layers
    let gameLayer = SKNode()
    let elementsLayer = SKNode()
    let tilesLayer = SKNode() // Background square for each element
    
    // Properties for swiping gestures
    private var swipeFromColumn: Int?
    private var swipeFromRow: Int?
    private var selectedSprite = SKShapeNode()
    
    // Sound effect for game play
    let disappearSound = SKAction.playSoundFileNamed("disappear.mp3", waitForCompletion: false)
    let invalidSwapSound = SKAction.playSoundFileNamed("invalid-swap.mp3", waitForCompletion: false)
    let swapSound = SKAction.playSoundFileNamed("swap.mp3", waitForCompletion: false)
    let chooseSound = SKAction.playSoundFileNamed("tap.wav", waitForCompletion: false)
    
    // Constructor
    override init(size: CGSize) {
        super.init(size: size)
        print("\(size)")
        
        // Make sure the the game board adapts with different screen sizes
        elementWidth = size.width / 9
        elementHeight = size.height / 18
        tileWidth = elementWidth + 4
        tileHeight = elementHeight + 4
        
        // Center the game scene
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let layerPosition = CGPoint(x: (-tileWidth * CGFloat(level?.columns ?? 7) / 2),
                                    y: (-tileHeight * CGFloat(level?.rows ?? 7) / 2))
        
        // Load the background image
        let background = SKSpriteNode(imageNamed: "lightBackground")
        background.size = size
        background.zPosition = -100
        background.alpha = 0.2
        
        // Set the background node size to match the scene size
        addChild(gameLayer)
        gameLayer.addChild(background)
        
        // Add the background node to the scene
        tilesLayer.position = layerPosition
        gameLayer.addChild(tilesLayer)
        elementsLayer.position = layerPosition
        gameLayer.addChild(elementsLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Convert column and row number into CGPoint
     func tilePoint(col: Int, row: Int) -> CGPoint {
        return CGPoint(x: (CGFloat(col) * tileWidth + tileWidth / 2),
                       y: (CGFloat(row) * tileHeight + tileHeight / 2))
    }
    
    private func elementPoint(col: Int, row: Int) -> CGPoint {
        return CGPoint(x: (CGFloat(col) * tileWidth + tileWidth / 2),
                       y: (CGFloat(row) * tileHeight + tileHeight / 2))
    }
    
    // Convert a CGPoint relative to elements layer to column and row numbers
    private func convertPoint(_ point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        // Check if the point falls outside the grid
        if point.x >= 0 && point.x < tileWidth * CGFloat(level?.columns ?? 7) && point.y >= 0 && point.y < CGFloat(level?.rows ?? 7) * tileHeight {
            return (true, Int(point.x / tileWidth), Int(point.y / tileHeight))
        }
        return (false, 0, 0)
    }
    
    // MARK: Game board construction
    // Add sprite nodes into the tiles layer
    func addSprites(for elements: Set<Element>) {
        for e in elements {
            let sprite = SKSpriteNode(imageNamed: e.type.spriteName())
            sprite.size = CGSize(width: elementWidth, height: elementHeight)
            sprite.position = elementPoint(col: e.column, row: e.row)
            elementsLayer.addChild(sprite)
            e.sprite = sprite
        }
    }
    
    func removeSprites() {
        self.elementsLayer.removeAllChildren()
    }
    
    // Add background tiles
    func addTiles() {
        guard let level = level else { return }
        for row in 0..<level.rows {
            for col in 0..<level.columns {
                if level.tileAt(column: col, row: row) != nil {
                    let tileNode = SKSpriteNode(imageNamed: "lightTile")
                    tileNode.position = tilePoint(col: col, row: row)
                    tileNode.size = CGSize(width: tileWidth, height: tileHeight)
                    tilesLayer.addChild(tileNode)
                }
            }
        }
    }
    
    // MARK: Handle swiping
    // Detect the first touch of user on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Convert the touch location to the point relative to elements layer
        guard let touch = touches.first else { return }
        let location = touch.location(in: elementsLayer)
        
        // Covert into column and row number
        let (success, column, row) = convertPoint(location)
        if success {
            run(chooseSound)
            // Find the related element
            if let element =  level?.elementAt(atColumn: column, row: row) {
                showSelectionEffect(of: element)
                print("Touch at \(column) \(row)")
                swipeFromColumn = column
                swipeFromRow = row
            }
        }
    }
    
    // Detect the swipe direction
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Convert the location into valid row and column number
        guard let touch = touches.first else { return }
        let location = touch.location(in: elementsLayer)
        let (success, column, row) = convertPoint(location)
        if success {
            var horizontalDiff = 0
            var verticalDiff = 0
            guard let fromColumn = swipeFromColumn, let fromRow = swipeFromRow else { return }
            // Swipe left
            if column < fromColumn {
                horizontalDiff = -1
                print("Swipe left")
            }
            // Swipe right
            else if column > fromColumn {
                horizontalDiff = 1
            }
            // Swipe down
            else if row < fromRow {
                verticalDiff = -1
            }
            // Swipe up
            else if row > fromRow {
                verticalDiff = 1
            }
            if horizontalDiff != 0 || verticalDiff != 0 {
                trySwap(hDiff: horizontalDiff, vDiff: verticalDiff)
                hideSelectionEffect()
                // Ignore the rest of the swipe motion
                swipeFromColumn = nil
            }
            
        }
        
    }
    
    // Handle swaping
    private func trySwap(hDiff: Int, vDiff: Int) {
        // Calculate the destined column or row
        guard let fromColumn = swipeFromColumn, let fromRow = swipeFromRow, let level = level else { return }
        let toColumn = fromColumn + hDiff
        let toRow = fromRow + vDiff
        
        // Verify that the destined row or column is within the grid
        guard toColumn >= 0 && toColumn < level.columns else { return }
        guard toRow >= 0 && toRow < level.rows else { return }
        
        // Check if the destined position contains element
        if let toElement = level.elementAt(atColumn: toColumn, row: toRow),
           let fromElement = level.elementAt(atColumn: fromColumn, row: fromRow) {
            if let handler = swipeHandler {
                // Create swap object
                let swap = Swap(elementA: fromElement, elementB: toElement)
                handler(swap)
            }
        }
    }
    
    // Gesture ends when user lifts finger from the screen
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Handle the action of just tapping on the screen
        if selectedSprite.parent != nil && swipeFromColumn != nil {
            hideSelectionEffect()
        }
        swipeFromColumn = nil
        swipeFromRow = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    // MARK: Animations during game play
    // Move element A to element B's position
    func moveElement(_ swap: Swap, completion: @escaping () -> Void) {
        let spriteA = swap.elementA.sprite
        let spriteB = swap.elementB.sprite
        
        guard let spriteA = spriteA, let spriteB = spriteB else { return }
        spriteA.zPosition = 100
        spriteB.zPosition = 90
        let duration: TimeInterval = 0.3
        // Move A to B
        let moveA = SKAction.move(to: spriteB.position, duration: duration)
        moveA.timingMode = .easeOut
        
        // Move B to A
        let moveB = SKAction.move(to: spriteA.position, duration: duration)
        moveB.timingMode = .easeOut
        spriteA.run(SKAction.group([moveA, swapSound]))
        spriteB.run(moveB, completion: completion)
        
    }
    
    // Animate the invalid swap
    func moveInvalidSwap(_ swap: Swap, completion: @escaping () -> Void) {
        guard let spriteA = swap.elementA.sprite, let spriteB = swap.elementB.sprite else { return }
        spriteA.zPosition = 100
        spriteB.zPosition = 90
        
        let duration: TimeInterval = 0.2
        let moveA = SKAction.move(to: spriteB.position, duration: duration)
        let moveB = SKAction.move(to: spriteA.position, duration: duration)
        moveA.timingMode = .easeOut
        moveB.timingMode = .easeOut
        spriteA.run(SKAction.sequence([moveA, moveB]), completion: completion)
        spriteB.run(SKAction.sequence([moveB, moveA]))
        
        spriteA.run(invalidSwapSound)
    }
    
    // Highlight the element if it is selected
    func showSelectionEffect(of element: Element) {
        // Remove the previously chosen element
        if selectedSprite.parent != nil {
            selectedSprite.removeFromParent()
        }
        if let sprite = element.sprite {
            // Create a stroke for the selected element
            let stroke = SKShapeNode(rectOf: CGSize(width: elementWidth, height: elementHeight))
            stroke.strokeColor = .yellow
            stroke.lineWidth = 3.0
            stroke.alpha = 1.0
            stroke.zPosition = 100
            
            selectedSprite = stroke
            sprite.addChild(selectedSprite)
        }
    }
    
    // Hide the stroke when the element is deselected
    func hideSelectionEffect() {
        selectedSprite.run(SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.3),
            SKAction.removeFromParent()
        ]))
    }
    
    /* Handle Removing Chains */
    // Implement animation for removing chains
    func animateRemoveChains(for chains: Set<Chain>, completion: @escaping () -> Void) {
        for chain in chains {
            animateScore(for: chain)
            for element in chain.elements {
                if let sprite = element.sprite {
                    // Trigger animation for each sprite
                    if sprite.action(forKey: "removing") == nil {
                        let scaleEffect = SKAction.scale(to: 0.1, duration: 0.3)
                        scaleEffect.timingMode = .easeOut
                        sprite.run(SKAction.group([
                            SKAction.sequence([scaleEffect, SKAction.removeFromParent()]),
                            disappearSound
                        ]), withKey: "removing")
                    }
                }
            }
        }
        // The game will continue after the animation finish
        run(SKAction.wait(forDuration: 0.3), completion: completion)
    }
    
    // Add animation for falling elements
    func animateFallingElements(in columns: [[Element]], completion: @escaping () -> Void) {
        var longestDuration: TimeInterval = 0
        for arr in columns {
            for (i, e) in arr.enumerated() {
                let newPos = elementPoint(col: e.column, row: e.row)
                let delay = 0.05 + 0.15 * TimeInterval(i)
                guard let sprite = e.sprite else {return}
                
                // Calculate the duration of the animation
                let duration = TimeInterval(((sprite.position.y - newPos.y) / elementHeight) * 0.1)
                longestDuration = max(longestDuration, duration + delay)
                
                // Perform the movement
                let move = SKAction.move(to: newPos, duration: duration)
                move.timingMode = .easeOut
                sprite.run(SKAction.sequence([SKAction.wait(forDuration: delay), move]))
            }
        }
        run(SKAction.wait(forDuration: longestDuration), completion: completion)
    }
    
    // Add animation for topping up new elements
    func animateNewElements(in columns: [[Element]], completion: @escaping () -> Void) {
        var longestDuration: TimeInterval = 0
        for arr in columns {
            let startRow = arr[0].row + 1
            for (i, e) in arr.enumerated() {
                let sprite = SKSpriteNode(imageNamed: e.type.spriteName())
                sprite.size = CGSize(width: elementWidth, height: elementHeight)
                sprite.position = elementPoint(col: e.column, row: e.row)
                elementsLayer.addChild(sprite)
                e.sprite = sprite
                
                // Compute the duration
                let delay = 0.1 + 0.2 * TimeInterval(arr.count - i - 1)
                let duration = TimeInterval(startRow - e.row) * 0.1
                longestDuration = max(longestDuration, duration + delay)
                
                // Perform animation
                let newPos = elementPoint(col: e.column, row: e.row)
                let move = SKAction.move(to: newPos, duration: duration)
                move.timingMode = .easeOut
                sprite.alpha = 0
                sprite.run(SKAction.sequence([SKAction.wait(forDuration: delay), SKAction.group([SKAction.fadeIn(withDuration: 0.05), move])]))
            }
        }
        run(SKAction.wait(forDuration: longestDuration), completion: completion)
    }
    
    // Add animation for scoring points
    func animateScore(for chain: Chain) {
        // Calculate the middle point of the chain
        guard let first  = chain.firstElement().sprite, let last = chain.lastElement().sprite else { 
            print("No sprite ")
            return }
        let centerPosition = CGPoint(
            x: (first.position.x + last.position.x)/2,
            y: (first.position.y + last.position.y)/2 - 8)
        
        // Add a label for the score
        let scoreLabel = SKLabelNode(fontNamed: "Helvetica-BoldOblique")
        scoreLabel.fontSize = 20
        scoreLabel.text = String(format: "%d", chain.score)
        scoreLabel.position = centerPosition
        print("Position of score: \(centerPosition)")
        scoreLabel.zPosition = 300
        elementsLayer.addChild(scoreLabel)
        
        // Start the animation
        let moveAction = SKAction.move(by: CGVector(dx: 0, dy: 3), duration: 1)
        moveAction.timingMode = .easeOut
        scoreLabel.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
    }
    
    
    
}
