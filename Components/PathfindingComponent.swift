//
//  PathfindingComponent.swift
//  valsrevenge
//
//  Created by Troy Martin on 10/20/24.
//

import SpriteKit
import GameplayKit

class PathfindingComponent: GKComponent {
    
    // MARK: - PROPERTIES
    
    let agent = GKAgent2D()
    var isRunning = false
    
    
    // MARK: - FUNCTIONS
    
    /// Starts pathfinding.
    func startPathfinding() {
        // Check for navigation graph and key node
        guard let scene = componentNode.scene as? GameScene,
              let sceneGraph = scene.graphs.values.first
        else { return }

        // Start pathfinding
        isRunning = true
        
        // Set up delegate and initial position
        agent.delegate = componentNode
        agent.position = vector_float2(Float(componentNode.position.x), Float(componentNode.position.y))
        
        // Set up the agent properties
        agent.mass = 1
        agent.speed = 50
        agent.maxSpeed = 100
        agent.maxAcceleration = 100
        agent.radius = 60
        
        // Find obstackles (monster generators)
        var obstacles = [GKCircleObstacle]()
        
        // Locate generator nodes
        scene.enumerateChildNodes(withName: "spawn_*") {
            (node, stop) in
            
            // Create compatible obstacle and add to obstacle array
            let circle = GKCircleObstacle(radius: Float(node.frame.size.width/2))
            circle.position = vector_float2(Float(node.position.x),
                                            Float(node.position.y))
            obstacles.append(circle)
        }
        
        // Find the path
        if let nodesOnPath = sceneGraph.nodes as? [GKGraphNode2D] {
            
            /*
            // Show the path (optional)
            for (index, node) in nodesOnPath.enumerated() {
                let shapeNode = SKShapeNode(circleOfRadius: 10)
                shapeNode.fillColor = .green
                shapeNode.position = CGPoint(x: CGFloat(node.position.x),
                                             y: CGFloat(node.position.y))
                // Add node number
                let number = SKLabelNode(text: "\(index)")
                number.position.y = 15
                shapeNode.addChild(number)
                
                addChild(shapeNode)
            }
            // end of (optional)
            */
            
            // Create a path to follow
            let path = GKPath(graphNodes: nodesOnPath, radius: 0)
            path.isCyclical = true
            
            // Set up the goals
            let followPath = GKGoal(toFollow: path, maxPredictionTime: 1.0,
                                    forward: true)
            let avoidObstacles = GKGoal(toAvoid: obstacles, maxPredictionTime: 1.0)
            
            // Add behavior based on goals
            agent.behavior = GKBehavior(goals: [followPath, avoidObstacles])
            
            // Set goal weights
            agent.behavior?.setWeight(0.5, for: followPath)
            agent.behavior?.setWeight(100, for: avoidObstacles)
            
            // Add agent to the component system
            scene.agentComponentSystem.addComponent(agent)
        }
    }
    
    // Stops pathfinding.
    func stopPathfinding() {
        isRunning = false
        agent.delegate = nil  // stops positional updates
    }
    
    
    // MARK: - OVERRIDES
    
    /// Uses update to start and stop pathfinding.
    override func update(deltaTime seconds: TimeInterval) {
        if let scene = componentNode.scene as? GameScene {
            switch scene.mainGameStateMachine.currentState {
            case is PauseState:
                if isRunning == true {
                    stopPathfinding()
                }
            case is PlayingState:
                if isRunning == false {
                    startPathfinding()
                }
            default:
                break
            }
        }
    }
    
    // Needed to load properly due to caching.
    override class var supportsSecureCoding: Bool {
        true
    }
}
