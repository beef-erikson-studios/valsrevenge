//
//  GameScene.swift
//  valsrevenge
//
//  Created by Troy Martin on 9/1/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // MARK: - Properties
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    let agentComponentSystem = GKComponentSystem(componentClass: GKAgent2D.self)
    
    let mainGameStateMachine = GKStateMachine(states: [PauseState(), PlayingState()])
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    private var player: Player?
    
    let margin: CGFloat = 20.0
    
    
    // MARK: - Overrides
    
    /// On scene load, resets lastUpdateTime.
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
    }
    
    /// Sets up map modes, physics, and player for use.
    override func didMove(to view: SKView) {
        // Set initial state
        mainGameStateMachine.enter(PauseState.self)
        
        // Grass tiles
        let grassMapMode = childNode(withName: "Grass Tile Map") as? SKTileMapNode
        grassMapMode?.setupEdgeLoop()
        
        // Dungeon tiles
        let dungeonMapMode = childNode(withName: "Dungeon Tile Map") as? SKTileMapNode
        dungeonMapMode?.setupMapPhysics()
        
        setupPlayer()
        setupCamera()
        
        // Game scene responsible for handling physics.
        physicsWorld.contactDelegate = self
    }
    
    /// Called every frame before rendering. Updates lastUpdateTime and all entities.
    /// - Parameters:
    ///  - currentTime: Used for updating the current time for spawning purposes.
    override func update(_ currentTime: TimeInterval) {
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        // Update component systems
        agentComponentSystem.update(deltaTime: dt)
        
        self.lastUpdateTime = currentTime
    }
    

    // MARK: - Functions
    
    /// Updates the control widgets to stay in the bottom right / bottom left.
    func updateControllerLocation() {
        // Set controller to bottom left
        let controller = childNode(withName: "//controller")
        controller?.position = CGPoint(x: (viewLeft + margin + insets.left),
                                       y: (viewBottom + margin + insets.bottom))
        
        // Set controller to bottom right
        let attackButton = childNode(withName: "//attackButton")
        attackButton?.position = CGPoint(x: (viewRight - margin - insets.right),
                                         y: (viewBottom + margin + insets.bottom))
    }
    
    /// Sets the camera up and contrains it to the player.
    func setupCamera() {
        guard let player = player else { return }
        let distance = SKRange(constantValue: 0)
        let playerConstraint = SKConstraint.distance(distance, to: player)
        camera?.constraints = [playerConstraint]
    }
    
    /// Sets up the initial move state and adds player agent.
    func setupPlayer() {
        player = childNode(withName: "player") as? Player
    
        if let player = player {
            player.move(.stop)
            agentComponentSystem.addComponent(player.agent)
        }
    }
    
    
    // MARK: - Touch Controls
    
    /// On touch down - handles controls (movement / shooting).
    func touchDown(atPoint pos : CGPoint) {
        mainGameStateMachine.enter(PlayingState.self)
        
        let nodeAtPoint = atPoint(pos)
        if let touchedNode = nodeAtPoint as? SKSpriteNode {
            
            // Movement
            if touchedNode.name?.starts(with: "controller_") == true {
                let direction = touchedNode.name?.replacingOccurrences(of: "controller_", with: "")
                player?.move(Direction(rawValue: direction ?? "stop")!)
            // Attack
            } else if touchedNode.name == "button_attack" {
                player?.attack()
            }
        }
    }
    
    /// On touch moved, move the player if on controller, otherwise stop player.
    func touchMoved(toPoint pos : CGPoint) {
        let nodeAtPoint = atPoint(pos)
        if let touchedNode = nodeAtPoint as? SKSpriteNode {
            if touchedNode.name?.starts(with: "controller_") == true {
                let direction = touchedNode.name?.replacingOccurrences(of: "controller_", with: "")
                player?.move(Direction(rawValue: direction ?? "stop")!)
            }
        }
    }
    
    /// On touch up, stop the player from moving.
    func touchUp(atPoint pos : CGPoint) {
        let nodeAtPoint = atPoint(pos)
        if let touchedNode = nodeAtPoint as? SKSpriteNode {
            if touchedNode.name?.starts(with: "controller_") == true {
                player?.stop()
            }
        }
    }
    
    /// On touch begin, pulse label with a fadeInOut.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    /// Move the touch.
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    /// End the touch.
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    /// Cancel the touch (end it).
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    /// Updates controller location for switching orientations.
    override func didFinishUpdate() {
        updateControllerLocation()
    }
}
