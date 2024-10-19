//
//  AgentComponent.swift
//  valsrevenge
//
//  Created by Troy Martin on 10/19/24.
//

import SpriteKit
import GameplayKit

class AgentComponent: GKComponent {
    
    let agent = GKAgent2D()
    
    /// Agent has a wandering goal.
    override func didAddToEntity() {
        guard let scene = componentNode.scene as? GameScene else { return }
        
        // Set up the goals and behaviors
        let wanderGoal = GKGoal(toWander: 1.0)
        agent.behavior = GKBehavior(goal: wanderGoal, weight: 100)
        
        // Set the delegate
        agent.delegate = componentNode
        
        // Constrain the agent's movement
        agent.mass = 1
        agent.maxAcceleration = 125
        agent.maxSpeed = 125
        agent.radius = 60
        agent.speed = 100
        
        // Add the agent component to component system
        scene.agentComponentSystem.addComponent(agent)
    }
    
    /// This is needed to load properly due to caching.
    override class var supportsSecureCoding: Bool {
        true
    }
}
