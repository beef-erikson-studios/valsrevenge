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
    case key
    case food
    case treasure
}

struct GameObject {
    
    // MARK: - DEFAULT PROPERTIES
    
    // Default generator and animation statics
    static let defaultGeneratorType = GameObjectType.skeleton.rawValue
    static let defaultAnimationType = GameObjectType.skeleton.rawValue
    
    // Sets collectible settings default state.
    static let defaultCollectibleType = GameObjectType.key.rawValue
    
    
    // MARK: - MONSTERS
    
    // Create monster struct instances
    static let skeleton = Skeleton()
    static let goblin = Goblin()
    
    // Create collecible struct instances
    static let key = Key()
    static let food = Food()
    static let treasure = Treasure()
    
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
    
    
    // MARK: - COLLECTIBLES
    
    // Key collectible settings
    struct Key {
        let collectibleSettings = Collectible(
            type: .key,
            collectSoundFile: "key",
            destroySoundFile: "destroyed")
    }
    
    struct Food {
        let collectibleSettings = Collectible(
            type: .food,
            collectSoundFile: "food",
            destroySoundFile: "destroyed",
            canDestroy: true)
    }
    
    struct Treasure {
        let collectibleSettings = Collectible(
            type: .treasure,
            collectSoundFile: "treasure",
            destroySoundFile: "destroyed")
    }
    
    
    // MARK: - ANIMATIONS
    
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
    
    
    // MARK: - COLLECTIBLES
    
    /// Returns collectible settings for each collectible.
    ///
    /// - Parameters:
    ///   - type: GameObjectType to get the settings from (i.e. "key").
    /// - Returns: A collectible's settings.
    static func forCollectibleType(_ type: GameObjectType?) -> Collectible? {
        switch type {
        case .key:
            return GameObject.key.collectibleSettings
        case .food:
            return GameObject.food.collectibleSettings
        case .treasure:
            return GameObject.treasure.collectibleSettings
        default:
            return nil
        }
    }
}
