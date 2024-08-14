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
}
