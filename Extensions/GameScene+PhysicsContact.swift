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
            
        // MARK: - Projectile | Monster
            
        case PhysicsBody.projectile.categoryBitMask | PhysicsBody.monster.categoryBitMask:
            let monsterNode = contact.bodyA.categoryBitMask == PhysicsBody.monster.categoryBitMask
            ? contact.bodyA.node : contact.bodyB.node
            
            if let healthComponent = monsterNode?.entity?.component(ofType: HealthComponent.self) {
                healthComponent.updateHealth(-1, forNode: monsterNode)
            }
            
        // MARK: - Player | Monster
            
        case PhysicsBody.player.categoryBitMask | PhysicsBody.monster.categoryBitMask:
            let playerNode = contact.bodyA.categoryBitMask == PhysicsBody.player.categoryBitMask
            ? contact.bodyA.node : contact.bodyB.node
            
            if let healthComponent = playerNode?.entity?.component(ofType: HealthComponent.self) {
                healthComponent.updateHealth(-1, forNode: playerNode)
            }
            
            
        // MARK: - Projectile | Collectible
            
        case PhysicsBody.projectile.categoryBitMask | PhysicsBody.collectible.categoryBitMask:
            let projectileNode = contact.bodyA.categoryBitMask == PhysicsBody.projectile.categoryBitMask
            ? contact.bodyA.node : contact.bodyB.node
            
            let collectibleNode = contact.bodyA.categoryBitMask == PhysicsBody.collectible.categoryBitMask
            ? contact.bodyA.node : contact.bodyB.node
            
            if let collectibleComponent = collectibleNode?.entity?.component(ofType: CollectibleComponent.self)
            {
                collectibleComponent.destroyedItem()
            }
            
            projectileNode?.removeFromParent()
            
            
        // MARK: - Player | Collectible
            
        case PhysicsBody.player.categoryBitMask | PhysicsBody.collectible.categoryBitMask:
            let playerNode = contact.bodyA.categoryBitMask == PhysicsBody.player.categoryBitMask ?
                contact.bodyA.node : contact.bodyB.node
            
            let collectibleNode = contact.bodyA.categoryBitMask == PhysicsBody.collectible.categoryBitMask ?
                contact.bodyA.node : contact.bodyB.node
            
            // Collect item
            if let player = playerNode as? Player, let collectible = collectibleNode {
                player.collectItem(collectible)
            }
        
        // MARK: - Player | Door
            
        case PhysicsBody.player.categoryBitMask | PhysicsBody.door.categoryBitMask:
            let playerNode = contact.bodyA.categoryBitMask == PhysicsBody.player.categoryBitMask ?
                contact.bodyA.node : contact.bodyB.node
            
            let doorNode = contact.bodyA.categoryBitMask == PhysicsBody.door.categoryBitMask ?
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
