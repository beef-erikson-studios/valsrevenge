//
//  Player.swift
//  valsrevenge
//
//  Created by Troy Martin on 9/1/24.
//

import SpriteKit


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
    
    // MARK: - Private Variables
    
    private let runSpeed: Int = 100
    private let attackSpeed: Int = 300
    private let attackLength: Float = 0.25
    
    private var currentDirection = Direction.stop
    
    
    // MARK: - Movement

    func move(_ direction: Direction) {
        
        switch direction {
        
        case .up:
            self.physicsBody?.velocity = CGVector(dx: 0, dy: runSpeed)
            // self.physicsBody?.applyImpulse(dx: 0, dy: 100)
            // self.physicsBody?.applyForce(dx: 0, dy: 100)
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
    
    // Stop movement
    func stop() {
        self.physicsBody?.velocity = CGVector.zero
    }
    
    
    // MARK: - Attacks
    
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
