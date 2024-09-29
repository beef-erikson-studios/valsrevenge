//
//  SKTileMapNode+Physics.swift
//  valsrevenge
//
//  Created by Troy Martin on 9/22/24.
//

import SpriteKit

extension SKTileMapNode {
    
    /// Sets up an edge rectangle and physics to set overall player bounds.
    func setupEdgeLoop() {
        // Sets edge rectangle variables
        let mapPoint = CGPoint(x: -frame.size.width / 2,
                               y: -frame.size.height / 2)
        let mapSize = CGSize(width: frame.size.width,
                             height: frame.size.height)
        let edgeLoopRect = CGRect(origin: mapPoint, size: mapSize)
        
        // Set up physics body
        physicsBody = SKPhysicsBody(edgeLoopFrom: edgeLoopRect)
        
        // Adjust default values
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        physicsBody?.isDynamic = false
        
        physicsBody?.categoryBitMask = 2 // Change to enum if this gets ridiculous
    }
    
    /// Sets up the physcis for the rest of the tiles nodes based on their size.
    func setupMapPhysics() {
        let halfWidth = CGFloat(numberOfColumns) / 2.0 * tileSize.width
        let halfHeight = CGFloat(numberOfRows) / 2.0 * tileSize.height
        
        // Loops through the tilemap
        for col in 0..<numberOfColumns {
            for row in 0..<numberOfRows {
                if let td = tileDefinition(atColumn: col, row: row) {
                    
                    if let bodySizeValue = td.userData?.value(forKey: "bodySize") as? String {
                        // Body size
                        let x = CGFloat(col) * tileSize.width - halfWidth + (tileSize.width / 2)
                        let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height / 2)
                        
                        let bodySize = NSCoder.cgPoint(for: bodySizeValue) // grabs {x, y}
                        let pointSize = CGSize(width: bodySize.x, height: bodySize.y)
                        
                        let tileNode = SKNode()
                        tileNode.position = CGPoint(x: x, y: y)
                        
                        // Body offset
                        if let bodyOffsetValue = td.userData?.value(forKey: "bodyOffset") as? String {
                            let bodyOffset = NSCoder.cgPoint(for: bodyOffsetValue)
                            tileNode.physicsBody = SKPhysicsBody(rectangleOf: pointSize,
                                                                 center: CGPoint(x: bodyOffset.x, y: bodyOffset.y))
                        } else {
                            tileNode.physicsBody = SKPhysicsBody(rectangleOf: pointSize)
                        }
                        
                        // Adjust defualt values
                        tileNode.physicsBody?.affectedByGravity = false
                        tileNode.physicsBody?.allowsRotation = false
                        tileNode.physicsBody?.isDynamic = false
                        
                        addChild(tileNode)
                    }
                }
            }
        }
    }
}
