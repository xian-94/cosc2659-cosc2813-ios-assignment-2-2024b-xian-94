import SpriteKit

let numColumns = 9
let numRows = 9

class GameScene: SKScene {
    
    var level: Level?
    // Set tile's size
    let elementWidth: CGFloat = 36.0
    let elementHeight: CGFloat = 36.0
    
    // Set the layers
    let gameLayer = SKNode()
    let elementsLayer = SKNode()
    let tilesLayer = SKNode() // Background square for each element
    let cropLayer = SKCropNode()
    let maskLayer = SKNode()
    
    // Properties for swiping gestures
    private var swipeFromColumn: Int?
    private var swipeFromRow: Int?
    
    
    // Constructor
    override init(size: CGSize) {
        super.init(size: size)
        // Center the game scene
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(gameLayer)
        
        let layerPosition = CGPoint(x: (-elementWidth * CGFloat(numColumns) / 2),
                                    y: (-elementHeight * CGFloat(numRows) / 2))
        
        tilesLayer.position = layerPosition
        maskLayer.position = layerPosition
        cropLayer.maskNode = maskLayer
        gameLayer.addChild(tilesLayer)
        gameLayer.addChild(cropLayer)
        elementsLayer.position = layerPosition
        cropLayer.addChild(elementsLayer)
        
        
        backgroundColor = .white // Set background color for visibility
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Convert column and row number into CGPoint
    private func elementPoint(col: Int, row: Int) -> CGPoint {
        return CGPoint(x: (CGFloat(col) * (elementWidth) + elementWidth / 2),
                       y: (CGFloat(row) * (elementHeight) + elementHeight / 2))
    }
    
    // Convert a CGPoint relative to elements layer to column and row numbers
    private func convertPoint(_ point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        // Check if the point falls outside the grid
        if point.x >= 0 && point.x < elementWidth * CGFloat(numColumns) && point.y >= 0 && point.y < CGFloat(numRows) * elementHeight {
            return (true, Int(point.x / elementWidth), Int(point.y / elementHeight))
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
        // Detect and draw MaskTile on a tile's place
        for r in 0..<numRows {
            for col in 0..<numColumns {
                if level.tileAt(column: col, row: r) != nil {
                    let tileNode = SKSpriteNode(imageNamed: "MaskTile")
                    tileNode.size = CGSize(width: elementWidth, height: elementHeight)
                    tileNode.position = elementPoint(col: col, row: r)
                    maskLayer.addChild(tileNode)
                }
            }
        }
        // Add border tiles
        for r in 0...numRows {
            for col in 0...numColumns {
                // Check the presence of neighboring tiles
                let topLeft = (col > 0) && (r < numRows) && level.tileAt(column: col - 1, row: r) != nil ? 1 : 0
                let bottomLeft = (col > 0) && (r > 0) && level.tileAt(column: col - 1, row: r - 1) != nil ? 1 : 0
                let topRight = (col < numColumns) && (r < numRows) && level.tileAt(column: col, row: r) != nil ? 1: 0
                let bottomRight = (col < numColumns) && (r > 0) && level.tileAt(column: col, row: r - 1) != nil ? 1: 0
                
                // Calculate the bitmask value based on the presence of neighboring tiles
                let value = topLeft | (topRight << 1) | (bottomLeft << 2) | (bottomRight << 3)
                
                
                // Add tile background based on the value
                if value != 0 && value != 6 && value != 9 {
                    let name = String(format: "Tile_%d", value)
                    let tileNode = SKSpriteNode(imageNamed: name)
                    tileNode.size = CGSize(width: elementWidth, height: elementHeight)
                    var point = elementPoint(col: col, row: r)
                    point.x -= elementWidth / 2
                    point.y -= elementHeight / 2
                    tileNode.position = point
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
            if let element = level?.elementAt(atColumn: column, row: row) {
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
            }
            // Ignore the rest of the swipe motion
            swipeFromColumn = nil
        }
        
    }
    
    // Handle swaping
    private func trySwap(hDiff: Int, vDiff: Int) {
        // Calculate the destined column or row
        guard let fromColumn = swipeFromColumn, let fromRow = swipeFromRow else { return }
        let toColumn = fromColumn + vDiff
        let toRow = fromRow + hDiff
        
        // Verify that the destined row or column is within the grid
        guard toColumn >= 0 && toColumn < numColumns else { return }
        guard toRow >= 0 && toRow < numRows else { return }
        
        // Check if the destined position contains element
        if let toElement = level?.elementAt(atColumn: toColumn, row: toRow),
           let fromElement = level?.elementAt(atColumn: toColumn, row: toRow) {
            print("Swaping \(fromElement) to \(toElement)")
        }
    }
    
    // Gesture ends when user lifts finger from the screen
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        swipeFromColumn = nil
        swipeFromRow = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
}
