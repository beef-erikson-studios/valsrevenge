//
//  MonsterEntity.swift
//  valsrevenge
//
//  Created by Troy Martin on 9/24/24.
//

import SpriteKit
import GameplayKit

// inits for MonsterEntity.
class MonsterEntity: GKEntity {
    
    /// Initialize monster type.
    ///
    /// - Parameters:
    ///   - monsterType: String of the monster to initialize (i.e. "skeleton").
    init(monsterType: String) {
        super.init()
    }
    
    /// Required init to work properly.
    ///
    /// - Parameters:
    ///   - coder: No need to worry about this, it's automatically provided.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
