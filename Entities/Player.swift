//
//  Player.swift
//  valsrevenge
//
//  Created by Troy Martin on 9/1/24.
//

import SpriteKit
import GameplayKit


// MARK: - Directions

enum Direction: String {
    case stop
    case left
    case right
    case up
    case down
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

class Player: SKSpriteNode {
    
    // MARK: - VARIABLES
    
    private var runSpeed: Int = 100
    private var attackSpeed: Int = 300
    private var attackLength: Float = 0.25
    
    private var currentDirection = Direction.stop
    
    var stateMachine = GKStateMachine(states: [PlayerHasKeyState(), PlayerHasNoKeyState()])
    
    // Keys
    private var keys: Int = 0 {
        didSet {
            print("Keys: \(keys)")
            if keys < 1 {
                stateMachine.enter(PlayerHasNoKeyState.self)
            } else {
                stateMachine.enter(PlayerHasKeyState.self)
            }
        }
    }
    
    // Treasure
    private var treasure: Int = 0 {
        didSet {
            print("Treasure: \(treasure)")
        }
    }
    
    // MARK: - OVERRIDES
    
    /// Initialize player with PlayerHasNoKeyState.
    ///
    /// - Parameters:
    ///   - coder: Passed in automatically on init.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        stateMachine.enter(PlayerHasNoKeyState.self)
    }
    
    
    // MARK: COLLECTIONS
    
    /// Handles what to do once the item has been collected.
    ///
    /// - Parameters:
    ///   - collectibleNode: The CollectibleComponent node.
    func collectItem(_ collectibleNode: SKNode) {
        guard let collectible = collectibleNode.entity?.component(ofType: CollectibleComponent.self)
                else { return }
        
        switch GameObjectType(rawValue: collectible.collectibleType) {
        
        // Add items here
            // TODO: REMOVE ALL PRINTS AFTER TESTING
        case .key:
            print("collected key")
            keys += collectible.value
        case .food:
            print("collected foodge")
            if let healthComponent = entity?.component(ofType: HealthComponent.self) {
                healthComponent.updateHealth(collectible.value, forNode: self)
            }
        case .treasure:
            print("bling bling motha fucka!")
            treasure += collectible.value
        
        default:
            break
        }
    }
    
    /// Opens a door if the player has a key.
    ///
    /// - Parameters:
    ///   - doorNode: Node of the door to open.
    func useKeyToOpenDoor(_ doorNode: SKNode) {
        // TODO: - REMOVE PRINT AFTER TESTED TO WORK
        print("use key to open door")
        
        switch stateMachine.currentState {
        
        // Subtracts a key, remove door, and plays door sound
        case is PlayerHasKeyState:
            keys -= 1
            
            doorNode.removeFromParent()
            run(SKAction.playSoundFileNamed("door_open", waitForCompletion: true))
            
        // Key isn't present
        case is PlayerHasNoKeyState:
            // TODO: PUT THIS AS A MESSAGE IN THE GAME
            print("You cannot do this.")
        default:
            break
        }
    }
    
    
    // MARK: - MOVEMENT

    /// Moves the player in a specified direction.
    ///
    /// - Parameters:
    ///   - direction: Move the character in a direction from the Direction enum (i.e. "left").
    func move(_ direction: Direction) {
        switch direction {
        case .up:
            self.physicsBody?.velocity = CGVector(dx: 0, dy: runSpeed)
            // self.physicsBody?.applyImpulse(dx: 0, dy: 100)  // Impulse movement
            // self.physicsBody?.applyForce(dx: 0, dy: 100)    // Force movement
        case .down:
            self.physicsBody?.velocity = CGVector(dx: 0, dy: -runSpeed)
        case .left:
            self.physicsBody?.velocity = CGVector(dx: -runSpeed, dy: 0)
        case.right:
            self.physicsBody?.velocity = CGVector(dx: runSpeed, dy: 0)
        case .topLeft:
            self.physicsBody?.velocity = CGVector(dx: -runSpeed, dy: runSpeed)
        case .topRight:
            self.physicsBody?.velocity = CGVector(dx: runSpeed, dy: runSpeed)
        case .bottomLeft:
            self.physicsBody?.velocity = CGVector(dx: -runSpeed, dy: -runSpeed)
        case .bottomRight:
            self.physicsBody?.velocity = CGVector(dx: runSpeed, dy: -runSpeed)
        case.stop:
            stop()
        }
        
        if direction != .stop { currentDirection = direction }
    }
    
    /// Stops player movement.
    func stop() {
        self.physicsBody?.velocity = CGVector.zero
    }
    
    
    // MARK: - ATTACKS
    
    /// Player attacks with a knife in the currently-facing direction.
    func attack() {
        // Adds knife projectile at center of player
        let projectile = SKSpriteNode(imageNamed: "knife")
        projectile.position = CGPoint(x: 0, y: 0)
        addChild(projectile)
        
        var throwDirection = CGVector.zero
        
        // Sets throw direction and rotation of knife based on player direction
        switch currentDirection {
        case .left:
            throwDirection = CGVector(dx: -attackSpeed, dy: 0)
            projectile.zRotation = CGFloat.pi / 2
        case .right, .stop:
            throwDirection = CGVector(dx: attackSpeed, dy: 0)
            projectile.zRotation = -CGFloat.pi / 2
        case .up:
            throwDirection = CGVector(dx: 0, dy: attackSpeed)
            projectile.zRotation = 0
        case .down:
            throwDirection = CGVector(dx: 0, dy: -attackSpeed)
            projectile.zRotation = -CGFloat.pi
        case .topLeft:
            throwDirection = CGVector(dx: -attackSpeed, dy: attackSpeed)
            projectile.zRotation = CGFloat.pi / 4
        case .topRight:
            throwDirection = CGVector(dx: attackSpeed, dy: attackSpeed)
            projectile.zRotation = -CGFloat.pi / 4
        case .bottomLeft:
            throwDirection = CGVector(dx: -attackSpeed, dy: -attackSpeed)
            projectile.zRotation = 3 * CGFloat.pi / 4
        case .bottomRight:
            throwDirection = CGVector(dx: attackSpeed, dy: -attackSpeed)
            projectile.zRotation = 3 * -CGFloat.pi / 4
        }
        
        // Run action
        let throwProjectile = SKAction.move(by: throwDirection, duration: 0.25)
        projectile.run(throwProjectile, completion: { projectile.removeFromParent() })
    }
}
