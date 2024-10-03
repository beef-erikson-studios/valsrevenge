//
//  PhysicsCategory.swift
//  valsrevenge
//
//  Created by Troy Martin on 10/1/24.
//

import SpriteKit
import GameplayKit


// MARK: - PHYSIC CATEGORIES

// Entities that will be affected by physics.
enum PhysicsCategory: String {
    case player
    case wall
    case door
    case monster
    case projectile
    case collectible
    case exit
}


// MARK: - PHYSIC SHAPE ENUM

// Shape of the phsyics box.
enum PhysicsShape: String {
    case circle
    case rect
}


// MARK: - PHYSICS BODY STRUCT

// Use of OptionSet and Hashable for better maintainance and clarity. Details the various entities.
struct PhysicsBody: OptionSet, Hashable {
    let rawValue: UInt32
    
    
    // MARK: - COMPONENTS
    
    // Define physics components
    static let player       = PhysicsBody(rawValue: 1 << 0)  // 1
    static let wall         = PhysicsBody(rawValue: 1 << 1)  // 2
    static let door         = PhysicsBody(rawValue: 1 << 2)  // 4
    static let monster      = PhysicsBody(rawValue: 1 << 3)  // 8
    static let projectile   = PhysicsBody(rawValue: 1 << 4)  // 16
    static let collectible  = PhysicsBody(rawValue: 1 << 6)  // 32
    static let exit         = PhysicsBody(rawValue: 1 << 5)  // 64
    
    
    // MARK: - COLLISIONS
    
    // Define colllisions on a per-entity basis
    static var collisions: [PhysicsBody: [PhysicsBody]] = [
        .player:            [.wall, .door],
        .monster:           [.wall, .door]
    ]
    
    
    // MARK: - CONTACT TESTS
    
    // Define entity contact checks
    static var contactTests: [PhysicsBody: [PhysicsBody]] = [
        .player:            [.monster, .collectible, .door, .exit],
        .wall:              [.player],
        .door:              [.player],
        .monster:           [.player, .projectile],
        .projectile:        [.monster, .collectible, .wall],
        .collectible:       [.player, .projectile],
        .exit:              [.player]
    ]
    
    
    // MARK: - BITMASKS
    
    // Sets the category bitmask - each physics body will only have one category.
    var categoryBitmask: UInt32 {
        return rawValue
    }
    
    // Reduces the values into a single value and return the union for collisions.
    var collisionBitmask: UInt32 {
        let bitmask = PhysicsBody
            .contactTests[self]?
            .reduce(PhysicsBody(), {
                result, physicsBody in
                return result.union(physicsBody)
            })
        
        return bitmask?.rawValue ?? 0
    }
    
    // Reduces the values into a single value and return the union for contact tests.
    var contactTestBitmask: UInt32 {
        let bitmask = PhysicsBody
            .contactTests[self]?
            .reduce(PhysicsBody(), {
                result, physicsBody in
                return result.union(physicsBody)
            })
        
        return bitmask?.rawValue ?? 0
    }
    
    
    // MARK: - PHYSICS STRUCT FUNCTIONS
    
    /// Fetches and returns the correct physics body based on category.
    ///
    /// - Parameters:
    ///   - type: Physics catgeory to retrieve the phsyics body for (i.e. "player").
    /// - Returns: Physics body from the provided category.
    static func forType(_ type: PhysicsCategory?) -> PhysicsBody? {
        switch type {
        case .player:
            return self.player
        case .wall:
            return self.wall
        case .door:
            return self.door
        case .monster:
            return self.monster
        case .projectile:
            return self.projectile
        case .collectible:
            return self.collectible
        case .exit:
            return self.exit
        case .none:
            break
        }
        
        return nil
    }
}


// MARK: - PHYSICS COMPONENT

class PhysicsComponent: GKComponent {
    @GKInspectable var bodyCategory: String = PhysicsCategory.wall.rawValue
    @GKInspectable var bodyShape: String = PhysicsShape.circle.rawValue
    
    /// Sets up the physicsBody component node based on the entity's category and sprite size.
    override func didAddToEntity() {
        guard let bodyCategory = PhysicsBody.forType(PhysicsCategory(rawValue: bodyCategory)),
              let sprite = componentNode as? SKSpriteNode else { return }
        
        let size: CGSize = sprite.size
        
        // Sets physics body based on entity's shape
        if bodyShape == PhysicsShape.rect.rawValue {
            componentNode.physicsBody = SKPhysicsBody(rectangleOf: size)
        } else if bodyShape == PhysicsShape.circle.rawValue {
            componentNode.physicsBody = SKPhysicsBody(circleOfRadius: size.height / 2)
        }
        
        // Component configurables
        componentNode.physicsBody?.categoryBitMask = bodyCategory.categoryBitmask
        componentNode.physicsBody?.collisionBitMask = bodyCategory.collisionBitmask
        componentNode.physicsBody?.contactTestBitMask = bodyCategory.contactTestBitmask
        
        componentNode.physicsBody?.affectedByGravity = false
        componentNode.physicsBody?.allowsRotation = false
    }
    
    // Needed so everthing loads properly.
    override class var supportsSecureCoding: Bool {
        true
    }
}
