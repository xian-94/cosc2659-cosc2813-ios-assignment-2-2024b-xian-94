import SpriteKit

let numColumns = 9
let numRows = 9

class GameScene: SKScene {
    
    var level: Level!
    
    // Set tile's size
    let elementWidth: CGFloat = 35.0
    let elementHeight: CGFloat = 35.0
    let tilePadding: CGFloat = 1.0
    
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
        gameLayer.addChild(elementsLayer)
       
        
        backgroundColor = .white // Set background color for visibility
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Convert column and row number into CGPoint
    private func elementPoint(col: Int, row: Int) -> CGPoint {
        return CGPoint(x: (CGFloat(col) * (elementWidth + tilePadding) + elementWidth / 2),
                       y: (CGFloat(row) * (elementHeight + tilePadding) + elementHeight / 2))
    }
    
    // Add sprite nodes into the tiles layer
    func addSprites(for tiles: Set<Element>) {
        for tile in tiles {
            let sprite = SKSpriteNode(imageNamed: tile.type.spriteName())
            sprite.size = CGSize(width: elementWidth, height: elementHeight)
            sprite.position = elementPoint(col: tile.column, row: tile.row)
            elementsLayer.addChild(sprite)
            tile.sprite = sprite
        }
    }
    
    // Add background tiles
    func addTiles() {
        // Detect and draw MaskTile on a tile's place
        for r in 0..<numRows {
            for col in 0..<numColumns {
                if level.getTile(atColumn: col, row: r) != nil {
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
                let topLeft = (col > 0) && (r < numRows) && level.getTile(atColumn: col - 1, row: r) != nil
                let bottomLeft = (col > 0) && (r > 0) && level.getTile(atColumn: col - 1, row: r - 1) != nil
                let topRight = (col < numColumns) && (r < numRows) && level.getTile(atColumn: col, row: r) != nil
                let bottomRight = (col < numColumns) && (r > 0) && level.getTile(atColumn: col, row: r - 1) != nil
                
                // Calculate the bitmask value based on the presence of neighboring tiles
                var value = topLeft.hashValue
                value = value | topRight.hashValue << 1
                value = value | bottomLeft.hashValue << 2
                value = value | bottomRight.hashValue << 3
                
                // Add tile background based on the value
                if value != 0 && value != 6 && value != 9 {
                    let name = String(format: "Tile_%d", value)
                    let tileNode = SKSpriteNode(imageNamed: "Tile_1")
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
