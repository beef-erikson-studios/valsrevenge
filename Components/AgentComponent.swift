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
    
    // Grabs player node and returns GKGoal of player's agent
    lazy var interceptGoal: GKGoal = {
        guard let scene = componentNode.scene as? GameScene,
              let player = scene.childNode(withName: "player") as? Player else {
            return GKGoal(toWander: 1.0)
        }
        
        return GKGoal(toInterceptAgent: player.agent, maxPredictionTime: 1.0)
    }()
    
    /// Agent has a wandering goal.
    override func didAddToEntity() {
        guard let scene = componentNode.scene as? GameScene else { return }
        
        // Set up the goals and behaviors
        let wanderGoal = GKGoal(toWander: 1.0)
        agent.behavior = GKBehavior(goals: [wanderGoal, interceptGoal], andWeights: [100, 0])
        
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

    /// Sets agent behavior weights based on if player has key.
    /// - parameters:
    ///   - seconds: delta time.
    override func update(deltaTime seconds: TimeInterval) {
        guard let scene = componentNode.scene as? GameScene,
              let player = scene.childNode(withName: "player") as? Player
        else { return }
        
        switch player.stateMachine.currentState {
        case is PlayerHasKeyState:
            agent.behavior?.setWeight(100, for: interceptGoal)
        default:
            agent.behavior?.setWeight(0, for: interceptGoal)
            break
        }
    }
    
    /// This is needed to load properly due to caching.
    override class var supportsSecureCoding: Bool {
        true
    }
}
