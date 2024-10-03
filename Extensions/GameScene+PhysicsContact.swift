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
            
            // TODO: ADD CODE TO HANDLE PLATER COLLECTION
            
        
        // MARK: - Player | Door
            
        case PhysicsBody.player.categoryBitmask | PhysicsBody.door.categoryBitmask:
            let playerNode = contact.bodyA.categoryBitMask == PhysicsBody.player.categoryBitmask ?
                contact.bodyA.node : contact.bodyB.node
            
            let doorNode = contact.bodyA.categoryBitMask == PhysicsBody.door.categoryBitmask ?
                contact.bodyA.node : contact.bodyB.node
            
            // TODO: ADD CODE TO HANDLE PLAYER OPENING DOOR

        default:
            break
        }
    }
}
