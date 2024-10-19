//
//  SKNode+AgentDelegate.swift
//  valsrevenge
//
//  Created by Troy Martin on 10/19/24.
//

import SpriteKit
import GameplayKit

extension SKNode: @retroactive GKAgentDelegate {
    
    /// Update the agent position to match node position.
    public func agentWillUpdate(_ agent: GKAgent) {
        guard let agent2d = agent as? GKAgent2D else { return }
        agent2d.position = vector_float2(Float(position.x), Float(position.y))
    }
    
    /// Update the node position to match agent position.
    public func agentDidUpdate(_ agent: GKAgent) {
        guard let agent2d = agent as? GKAgent2D else { return }
        position = CGPoint(x: CGFloat(agent2d.position.x),
                           y: CGFloat(agent2d.position.y))
    }
}
