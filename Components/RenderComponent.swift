//
//  RenderComponent.swift
//  valsrevenge
//
//  Created by Troy Martin on 9/24/24.
//

import SpriteKit
import GameplayKit

class RenderComponent: GKComponent {
    
    // MARK: - Lazy Variables
    
    lazy var spriteNode: SKSpriteNode? = {
        entity?.component(ofType: GKSKNodeComponent.self)?.node as? SKSpriteNode
    }()
    
    
    // MARK: - Initializations
    
    init(node: SKSpriteNode) {
        super.init()
        spriteNode = node
    }
    
    init(imageNamed: String, scale: CGFloat) {
        super.init()
        
        spriteNode = SKSpriteNode(imageNamed: imageNamed)
        spriteNode?.setScale(scale)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    // MARK: - Overrides

    // Stores sprite node entity
    override func didAddToEntity() {
        spriteNode?.entity = entity
    }
    
    // Corrects possible loading problems since 
    override class var supportsSecureCoding: Bool {
        true
    }
}
