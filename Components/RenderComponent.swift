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
    
    /// Sets the spriteNode.
    ///
    /// - Parameters:
    ///   - node: SKSpriteNode that is to be rendered.
    init(node: SKSpriteNode) {
        super.init()
        spriteNode = node
    }
    
    /// Sets spriteNode image and scale.
    ///
    /// - Parameters:
    ///  - imageNamed: String of the image that you want rendered (i.e. "skeleton").
    ///  - scale: Float for setting the scale of the image.
    init(imageNamed: String, scale: CGFloat) {
        super.init()
        
        spriteNode = SKSpriteNode(imageNamed: imageNamed)
        spriteNode?.setScale(scale)
    }
    
    /// Required init that sets the coder.
    ///
    /// - Parameters:
    ///  - coder: This is automatically passed in, no need to worry about this.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    // MARK: - Overrides

    /// Stores sprite node entity.
    override func didAddToEntity() {
        spriteNode?.entity = entity
    }
    
    // Corrects possible loading problems
    override class var supportsSecureCoding: Bool {
        true
    }
}
