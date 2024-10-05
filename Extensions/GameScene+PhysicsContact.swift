//
//  GameScene+PhysicsContact.swift
//  valsrevenge
//
//  Created by Troy Martin on 10/3/24.
//

import SpriteKit

extension GameScene: SKPhysicsContactDelegate {
    
    /// Override to handle collisions.
    ///
    /// - Parameters:
    ///   - contact: The physics contact between bodyA and bodyB.
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask
        | contact.bodyB.categoryBitMask
        
        switch collision {
        
        // MARK: - Player | Collectible
            
        case PhysicsBody.player.categoryBitmask | PhysicsBody.collectible.categoryBitmask:
            let playerNode = contact.bodyA.categoryBitMask == PhysicsBody.player.categoryBitmask ?
                contact.bodyA.node : contact.bodyB.node
            
            let collectibleNode = contact.bodyA.categoryBitMask == PhysicsBody.collectible.categoryBitmask ?
                contact.bodyA.node : contact.bodyB.node
            
            // Collect item
            if let player = playerNode as? Player, let collectible = collectibleNode {
                player.collectItem(collectible)
            }
        
        // MARK: - Player | Door
            
        case PhysicsBody.player.categoryBitmask | PhysicsBody.door.categoryBitmask:
            let playerNode = contact.bodyA.categoryBitMask == PhysicsBody.player.categoryBitmask ?
                contact.bodyA.node : contact.bodyB.node
            
            let doorNode = contact.bodyA.categoryBitMask == PhysicsBody.door.categoryBitmask ?
                contact.bodyA.node : contact.bodyB.node
            
            // Removes door and subtracts from key count
            if let player = playerNode as? Player, let door = doorNode {
                player.useKeyToOpenDoor(door)
            }
        
        default:
            break
        }
    }
}
