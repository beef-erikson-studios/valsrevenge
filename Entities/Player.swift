//
//  Player.swift
//  valsrevenge
//
//  Created by Troy Martin on 9/1/24.
//

import SpriteKit
import GameplayKit

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
  
    var stateMachine = GKStateMachine(states: [PlayerHasKeyState(),
                                               PlayerHasNoKeyState()])
    private var currentDirection = Direction.stop
  
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
  
    private var treasure: Int = 0 {
        didSet {
            print("Treasure: \(treasure)")
        }
    }
  
    /// Override this method to allow for a class to work in the Scene Editor.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    
        stateMachine.enter(PlayerHasNoKeyState.self)
    }
    
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
  
    /// Moves the player in the specified direction.
    func move(_ direction: Direction) {
        
        // Directions of movement
        switch direction {
        case .up:
            self.physicsBody?.velocity = CGVector(dx: 0, dy: 100)
            //self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
            //self.physicsBody?.applyForce(CGVector(dx: 0, dy: 100))
        case .down:
            self.physicsBody?.velocity = CGVector(dx: 0, dy: -100)
        case .left:
            self.physicsBody?.velocity = CGVector(dx: -100, dy: 0)
        case .right:
            self.physicsBody?.velocity = CGVector(dx: 100, dy: 0)
        case .topLeft:
            self.physicsBody?.velocity = CGVector(dx: -100, dy: 100)
        case .topRight:
            self.physicsBody?.velocity = CGVector(dx: 100, dy: 100)
        case .bottomLeft:
            self.physicsBody?.velocity = CGVector(dx: -100, dy: -100)
        case .bottomRight:
            self.physicsBody?.velocity = CGVector(dx: 100, dy: -100)
        case .stop:
            stop()
        }
    
        if direction != .stop {
            currentDirection = direction
        }
    }
  
    /// Stops the player from moving.
    func stop() {
        self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }
  
    /// Player attacks in the direction they are facing.
    func attack() {
        let projectile = SKSpriteNode(imageNamed: "knife")
        projectile.position = CGPoint(x: 0.0, y: 0.0)
        addChild(projectile)
    
        // Set up physics for projectile
        let physicsBody = SKPhysicsBody(rectangleOf: projectile.size)
    
        physicsBody.affectedByGravity = false
        physicsBody.allowsRotation = true
        physicsBody.isDynamic = true
    
        physicsBody.categoryBitMask = PhysicsBody.projectile.categoryBitMask
        physicsBody.contactTestBitMask = PhysicsBody.projectile.contactTestBitMask
        physicsBody.collisionBitMask = PhysicsBody.projectile.collisionBitMask
    
        projectile.physicsBody = physicsBody
    
        var throwDirection = CGVector(dx: 0, dy: 0)
    
        switch currentDirection {
        case .up:
            throwDirection = CGVector(dx: 0, dy: 300)
            projectile.zRotation = 0
        case .down:
            throwDirection = CGVector(dx: 0, dy: -300)
            projectile.zRotation = -CGFloat.pi
        case .left:
            throwDirection = CGVector(dx: -300, dy: 0)
            projectile.zRotation = CGFloat.pi/2
        case .right, .stop: // default pre-movement (throw right)
            throwDirection = CGVector(dx: 300, dy: 0)
            projectile.zRotation = -CGFloat.pi/2
        case .topLeft:
            throwDirection = CGVector(dx: -300, dy: 300)
            projectile.zRotation = CGFloat.pi/4
        case .topRight:
            throwDirection = CGVector(dx: 300, dy: 300)
            projectile.zRotation = -CGFloat.pi/4
        case .bottomLeft:
            throwDirection = CGVector(dx: -300, dy: -300)
            projectile.zRotation = 3 * CGFloat.pi/4
        case .bottomRight:
            throwDirection = CGVector(dx: 300, dy: -300)
            projectile.zRotation = 3 * -CGFloat.pi/4
        }
    
        let throwProjectile = SKAction.move(by: throwDirection, duration: 0.25)
        projectile.run(throwProjectile,
                   completion: {projectile.removeFromParent()})
  }
}
