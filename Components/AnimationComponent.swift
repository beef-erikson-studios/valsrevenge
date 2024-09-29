//
//  AnimationComponent.swift
//  valsrevenge
//
//  Created by Troy Martin on 9/28/24.
//

import SpriteKit
import GameplayKit


// MARK: - ANIMATION STRUCT

struct Animation {
    
    // Textures array and time per frame
    let textures: [SKTexture]
    var timePerFrame: TimeInterval
    
    // Texture properties
    let repeatTexturesForever: Bool
    let resizeTexture: Bool
    let restoreTexture: Bool
    
    // Sets values (or defaults)
    init(textures: [SKTexture],
         timePerFrame: TimeInterval = TimeInterval(1.0 / 5.0),
         repeatTexturesForever: Bool = true,
         resizeTexture: Bool = true,
         restoreTexture: Bool = true) {
        
        // Set to local properties
        self.textures = textures
        self.timePerFrame = timePerFrame
        self.repeatTexturesForever = repeatTexturesForever
        self.resizeTexture = resizeTexture
        self.restoreTexture = restoreTexture
    }
}


// MARK: - COMPONENT CODE STARTS HERE

class AnimationComponent: GKComponent {
    
    // Inspector properties
    @GKInspectable var animationType: String = GameObject.defaultAnimationType // Skeleton
    
    /// Runs the animation based on animationType.
    override func didAddToEntity() {
        // Grab the animation from animationType
        guard let animation = GameObject.forAnimationType(GameObjectType(rawValue: animationType))
                else { return }
        
        // Set animation variables
        let textures = animation.textures
        let timePerFrame = animation.timePerFrame
        let animationAction = SKAction.animate(with: textures, timePerFrame: timePerFrame)
        
        // Repeat forever or just once
        if animation.repeatTexturesForever == true {
            let repeatAction = SKAction.repeatForever(animationAction)
            componentNode.run(repeatAction)
        } else {
            componentNode.run(animationAction)
        }
    }
    
    // Requred override - may not load properly otherwise. 
    override class var supportsSecureCoding: Bool {
        true
    }
}
