//
//  GameObject.swift
//  valsrevenge
//
//  Created by Troy Martin on 9/28/24.
//

import SpriteKit
import GameplayKit


// MARK: - GAME OBJECT ENUMS

enum GameObjectType: String {
    // Monsters
    case skeleton
    case goblin
}


// MARK: - GAME OBJECT STRUCT

struct GameObject {
    // Default generator and animation statics
    static let defaultGeneratorType = GameObjectType.skeleton.rawValue
    static let defaultAnimationType = GameObjectType.skeleton.rawValue
    
    
    // MARK: - MONSTER CREATION
    
    // Create monster struct instances
    static let skeleton = Skeleton()
    static let goblin = Goblin()
    
    // Goblin animation settings
    struct Goblin {
        let animationSettings = Animation(textures: SKTexture.loadTextures(
            atlas: "monster_goblin",
            prefix: "goblin_",
            startsAt: 0, stopsAt: 1))
    }
    
    // Skeleton animation settings
    struct Skeleton {
        let animationSettings = Animation(textures: SKTexture.loadTextures(
            atlas: "monster_skeleton",
            prefix: "skeleton_",
            startsAt: 0, stopsAt: 1),
            timePerFrame: TimeInterval(1.0 / 25.0))
    }
    
    
    // MARK: - STATIC FUNCTIONS
    
    /// Sets the animationSettings for each GameObjectType.
    ///
    /// - Parameters:
    ///   - type: The GameObjectType to set the animation settings for (i.e. "skeleton").
    /// - Returns: Animation for the game object that was passed in or nil if not found.
    static func forAnimationType(_ type: GameObjectType?) -> Animation? {
        switch type {
        case .skeleton:
            return GameObject.skeleton.animationSettings
        case .goblin:
            return GameObject.goblin.animationSettings
        default:
            return nil
        }
    }
}
