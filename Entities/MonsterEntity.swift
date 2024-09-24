//
//  MonsterEntity.swift
//  valsrevenge
//
//  Created by Troy Martin on 9/24/24.
//

import SpriteKit
import GameplayKit

class MonsterEntity: GKEntity {
    
    init(monsterType: String) {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
