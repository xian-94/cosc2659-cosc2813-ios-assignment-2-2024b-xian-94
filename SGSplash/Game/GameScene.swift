import SpriteKit

let numColumns = 9
let numRows = 9

class GameScene: SKScene {
    
    var level: Level?
    // Closure that handle swiping
    var swipeHandler: ((Swap) -> Void)?
    // Set tile's size
    let elementWidth: CGFloat = 32.0
    let elementHeight: CGFloat = 32.0
    let tileSize: CGFloat = 42
    
    // Set the layers
    let gameLayer = SKNode()
    let elementsLayer = SKNode()
    let tilesLayer = SKNode() // Background square for each element
    
    // Properties for swiping gestures
    private var swipeFromColumn: Int?
    private var swipeFromRow: Int?
    private var selectedSprite = SKShapeNode()
    
    
    // Constructor
    override init(size: CGSize) {
        super.init(size: size)
        // Center the game scene
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(gameLayer)
        
        let layerPosition = CGPoint(x: (-tileSize * CGFloat(numColumns) / 2),
                                    y: (-tileSize * CGFloat(numRows) / 2))
        
        tilesLayer.position = layerPosition
        gameLayer.addChild(tilesLayer)
        elementsLayer.position = layerPosition
        gameLayer.addChild(elementsLayer)
        
        
        backgroundColor = .white // Set background color for visibility
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Convert column and row number into CGPoint
    private func tilePoint(col: Int, row: Int) -> CGPoint {
        return CGPoint(x: (CGFloat(col) * tileSize + tileSize / 2),
                       y: (CGFloat(row) * tileSize + tileSize / 2))
    }
    
    private func elementPoint(col: Int, row: Int) -> CGPoint {
        return CGPoint(x: (CGFloat(col) * tileSize + tileSize / 2),
                       y: (CGFloat(row) * tileSize + tileSize / 2))
    }
    
    // Convert a CGPoint relative to elements layer to column and row numbers
    private func convertPoint(_ point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        // Check if the point falls outside the grid
        if point.x >= 0 && point.x < tileSize * CGFloat(numColumns) && point.y >= 0 && point.y < CGFloat(numRows) * tileSize {
            return (true, Int(point.x / tileSize), Int(point.y / tileSize))
        }
        return (false, 0, 0)
    }
    
    /* Game board construction methods */
    
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
    
    
    // Add background tiles
    func addTiles() {
        guard let level = level else { return }
        for row in 0..<numRows {
            for col in 0..<numColumns {
                if level.tileAt(column: col, row: row) != nil {
                    let tileNode = SKShapeNode(rectOf: CGSize(width: tileSize, height: tileSize))
                    tileNode.position = tilePoint(col: col, row: row)
                    tileNode.fillColor = .lightGray
                    tileNode.alpha = 1.0
                    tilesLayer.addChild(tileNode)
                }
            }
        }
    }
    
    /* Swiping gestures methods */
    
    // Detect the first touch of user on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Convert the touch location to the point relative to elements layer
        guard let touch = touches.first else { return }
        let location = touch.location(in: elementsLayer)
        
        // Covert into column and row number
        let (success, column, row) = convertPoint(location)
        if success {
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
        guard let fromColumn = swipeFromColumn, let fromRow = swipeFromRow else { return }
        let toColumn = fromColumn + hDiff
        let toRow = fromRow + vDiff
        
        // Verify that the destined row or column is within the grid
        guard toColumn >= 0 && toColumn < numColumns else { return }
        guard toRow >= 0 && toRow < numRows else { return }
        
        // Check if the destined position contains element
        if let toElement = level?.elementAt(atColumn: toColumn, row: toRow),
           let fromElement = level?.elementAt(atColumn: fromColumn, row: fromRow) {
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
        spriteA.run(moveA)
        spriteB.run(moveB, completion: completion)
        
        //        run(swapSound) TODO: Add Sound later
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
        
        // TODO: Add sound later 
//        run(invalidSwapSound)
    }
    
    // Highlight the element if it is selected
    // TODO: Styling the effect later
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
}
