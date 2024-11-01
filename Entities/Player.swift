//
//  Player.swift
//  valsrevenge
//
//  Created by Troy Martin on 9/1/24.
//

import SpriteKit
import GameplayKit

class Player: SKSpriteNode {
  
    // MARK: - PROPERTIES
    
    // Key state and agent for enemy tracking
    var stateMachine = GKStateMachine(states: [PlayerHasKeyState(),
                                               PlayerHasNoKeyState()])
    var agent = GKAgent2D()
  
    // Movement and attacking
    var movementSpeed: CGFloat = 5
    
    var maxProjectiles: Int = 1
    var numProjectiles: Int = 0
    
    var projectileSpeed: CGFloat = 25
    var projectileRange: TimeInterval = 1
    
    let attackDelay = SKAction.wait(forDuration: 0.25)
    
    // HUD elements
    var hud = SKNode()
    private let treasureLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
    private let keysLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
    
    // Inventory elements
    private var keys: Int = GameData.shared.keys {
        didSet {
            keysLabel.text = "Keys: \(keys)"
            if keys < 1 {
                stateMachine.enter(PlayerHasNoKeyState.self)
            } else {
                stateMachine.enter(PlayerHasKeyState.self)
            }
        }
    }
  
    private var treasure: Int = GameData.shared.treasure {
        didSet {
            treasureLabel.text = "Treasure: \(treasure)"
        }
    }
  
    
    // MARK: - INITIALIZATIONS
    
    /// Returns the players current key and treasure counts.
    func getStats() -> (keys: Int, treasure: Int) {
        return (self.keys, self.treasure)
    }
    
    /// Sets initial key state and agent delegate.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    
        stateMachine.enter(PlayerHasNoKeyState.self)
        agent.delegate = self
    }
    
    
    // MARK: - HUD
    
    /// Sets up the heads up display for showing the treasure amount and key count.
    ///
    /// - Parameters:
    ///   - scene: The currently active game scene.
    func setupHUD(scene: GameScene) {
        // Set up the treasure label
        treasureLabel.text = "Treasure: \(treasure)"
        treasureLabel.horizontalAlignmentMode = .right
        treasureLabel.verticalAlignmentMode = .center
        treasureLabel.position = CGPoint(x: 0, y: -treasureLabel.frame.height)
        treasureLabel.zPosition += 1
        
        // Set up the keys label
        keysLabel.text = "Keys: \(keys)"
        keysLabel.horizontalAlignmentMode = .right
        keysLabel.verticalAlignmentMode = .center
        keysLabel.position = CGPoint(x: 0, y: treasureLabel.frame.minY - keysLabel.frame.height)
        keysLabel.zPosition += 1
        
        // Add the labels to the HUD
        hud.addChild(treasureLabel)
        hud.addChild(keysLabel)
        
        // Add the HUD to the scene
        scene.addChild(hud)
    }
    
    
    // MARK: - ITEM FUNCTIONS
    
    /// Handles the collection of items and adding to the appropriate values.
    ///
    /// - Parameters:
    ///   - collectibleNode: SKNode of the collectible to collect,
    func collectItem(_ collectibleNode: SKNode) {
        guard let collectible = collectibleNode.entity?.component(ofType: CollectibleComponent.self)
        else { return }
    
        collectible.collectedItem()
    
        switch GameObjectType(rawValue: collectible.collectibleType) {
        case .key:
            print("collected key")
            keys += collectible.value
      
        case .food:
            print("collected food")
            if let healthComponent = entity?.component(ofType: HealthComponent.self) {
                healthComponent.updateHealth(collectible.value, forNode: self)
            }
      
        case .treasure:
            print("collected treasure")
            treasure += collectible.value
      
        default:
            break
        }
    }
  
    /// Subtracts key and opens door, playing the sound as well.
    ///
    /// - Parameters:
    ///   - doorNode: SKNode of the door to open.
    func useKeyToOpenDoor(_ doorNode: SKNode) {
    
        switch stateMachine.currentState {
        case is PlayerHasKeyState:
            keys -= 1
      
            doorNode.removeFromParent()
            run(SKAction.playSoundFileNamed("door_open",
                                      waitForCompletion: true))
        default:
            break
        }
    }
  
    
    // MARK: - ATTACKING
    
    func attack(direction: CGVector) {
        // Make sure player is allowed to fire
        if direction != .zero && numProjectiles < maxProjectiles {
            numProjectiles += 1
            
            // Set up projectile
            let projectile = SKSpriteNode(imageNamed: "knife")
            projectile.position = CGPoint(x: 0.0, y: 0.0)
            projectile.zPosition += 1
            addChild(projectile)
            
            // Set up projectile physics
            let physicsBody = SKPhysicsBody(rectangleOf: projectile.size)
            
            physicsBody.affectedByGravity = false
            physicsBody.allowsRotation = true
            physicsBody.isDynamic = true
            
            physicsBody.categoryBitMask = PhysicsBody.projectile.categoryBitMask
            physicsBody.contactTestBitMask = PhysicsBody.projectile.contactTestBitMask
            physicsBody.collisionBitMask = PhysicsBody.projectile.collisionBitMask
            
            projectile.physicsBody = physicsBody
            
            // Set the throw direction
            let throwDirection = CGVector(dx: direction.dx * projectileSpeed,
                                          dy: direction.dy * projectileSpeed)
            
            // Create and run attack actions
            let wait = SKAction.wait(forDuration: projectileRange)
            let removeFromScene = SKAction.removeFromParent()
            
            let spin = SKAction.applyTorque(0.25, duration: projectileRange)
            let toss = SKAction.move(by: throwDirection, duration: projectileRange)
            
            let actionLifetime = SKAction.sequence([wait, removeFromScene])
            let actionsThrow = SKAction.group([spin, toss])
            
            let actionAttack = SKAction.group([actionLifetime, actionsThrow])
            projectile.run(actionAttack)
            
            // Attack governor
            let reduceCount = SKAction.run({self.numProjectiles -= 1})
            let reduceSequence = SKAction.sequence([attackDelay, reduceCount])
            run(reduceSequence)
        }
    }
}
