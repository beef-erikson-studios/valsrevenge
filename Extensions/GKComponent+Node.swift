//
//  GKComponent+Node.swift
//  valsrevenge
//
//  Created by Troy Martin on 9/27/24.
//

import SpriteKit
import GameplayKit


extension GKComponent {
    
    /// Helper extension - returns node regardless of code or scene editor.
    var componentNode: SKNode {
        if let node = entity?.component(ofType: GKSKNodeComponent.self)?.node {
            return node
        } else if let node = entity?.component(ofType: RenderComponent.self)?.spriteNode {
            return node
        }
        
        return SKNode()
    }
}
