//
//  CollectibleComponent.swift
//  valsrevenge
//
//  Created by Troy Martin on 10/1/24.
//

import SpriteKit
import GameplayKit


// MARK: - COLLECTIBLE STRUCT

struct Collectible {
    let type: GameObjectType
    
    let collectSoundFile: String
    let destroySoundFile: String
    
    let canDestroy: Bool
    
    /// Initialziaton - sets parameters to struct's variables.
    ///
    /// - Parameters:
    ///   - type: GameObject to pass in (i.e. Key).
    ///   - collectSoundFile: Name of the sound to play when a collectible is collected.
    ///   - destroySoundFile: Name of the sound to play when a collectible is destroyed.
    ///   - canDestroy: Is the collectible able to be destroyed?
    init(type: GameObjectType, collectSoundFile: String, destroySoundFile: String, canDestroy: Bool = false) {
        self.type = type
        
        self.collectSoundFile = collectSoundFile
        self.destroySoundFile = destroySoundFile
        
        self.canDestroy = canDestroy
    }
}


// MARK: - COLLECTIBLE COMPONENT CLASS

class CollectibleComponent: GKComponent {
    
    @GKInspectable var collectibleType: String = GameObject.defaultCollectibleType
    @GKInspectable var value: Int = 1
    
    private var collectSoundAction = SKAction()
    private var destroySoundAction = SKAction()
    private var canDestroy: Bool = false
    
    
    // MARK: - OVERRIDES
    
    /// Sets collect and destroy sounds as well as the GameObject's canDestroy value.
    override func didAddToEntity() {
        guard let collectible = GameObject.forCollectibleType(GameObjectType(rawValue: collectibleType))
                else { return }
        
        // Pre-load sounds to avoid audio delays
        collectSoundAction = SKAction.playSoundFileNamed(collectible.collectSoundFile,
                                                         waitForCompletion: false)
        destroySoundAction = SKAction.playSoundFileNamed(collectible.destroySoundFile,
                                                         waitForCompletion: false)
        
        canDestroy = collectible.canDestroy
    }
    
    /// Necessary override to load properly. Don't change.
    override class var supportsSecureCoding: Bool {
        true
    }
    
    
    // MARK: - METHODS
    
    /// Item was collected. Plays the appropriate collect sound and removes the entity.
    func collectedItem() {
        componentNode.run(collectSoundAction, completion: {
            self.componentNode.removeFromParent()
        })
    }
    
    /// Item was destroyed. Plays the appropriate destry sound and removes the entity.
    func destroyedItem() {
        componentNode.run(destroySoundAction, completion: {
            self.componentNode.removeFromParent()
        })
    }
}
