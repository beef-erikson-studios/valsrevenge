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
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    private var player: Player?
    
    let margin: CGFloat = 20.0
    
    
    // MARK: - Overrides
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
    }
    
    override func didMove(to view: SKView) {
        let grassMapMode = childNode(withName: "Grass Tile Map") as? SKTileMapNode
        grassMapMode?.setupEdgeLoop()
        
        let dungeonMapMode = childNode(withName: "Dungeon Tile Map") as? SKTileMapNode
        dungeonMapMode?.setupMapPhysics()
        
        player = childNode(withName: "player") as? Player
        player?.move(.stop)
        
        setupCamera()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
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
        
        self.lastUpdateTime = currentTime
    }
    

    // MARK: - Functions
    
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
    
    func setupCamera() {
        guard let player = player else { return }
        let distance = SKRange(constantValue: 0)
        let playerConstraint = SKConstraint.distance(distance, to: player)
        camera?.constraints = [playerConstraint]
    }
    
    
    // MARK: - Touch Controls
    
    func touchDown(atPoint pos : CGPoint) {
        let nodeAtPoint = atPoint(pos)
        if let touchedNode = nodeAtPoint as? SKSpriteNode {
            if touchedNode.name?.starts(with: "controller_") == true {
                let direction = touchedNode.name?.replacingOccurrences(of: "controller_", with: "")
                player?.move(Direction(rawValue: direction ?? "stop")!)
            } else if touchedNode.name == "button_attack" {
                player?.attack()
            }
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        let nodeAtPoint = atPoint(pos)
        if let touchedNode = nodeAtPoint as? SKSpriteNode {
            if touchedNode.name?.starts(with: "controller_") == true {
                let direction = touchedNode.name?.replacingOccurrences(of: "controller_", with: "")
                player?.move(Direction(rawValue: direction ?? "stop")!)
            }
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        let nodeAtPoint = atPoint(pos)
        if let touchedNode = nodeAtPoint as? SKSpriteNode {
            if touchedNode.name?.starts(with: "controller_") == true {
                player?.stop()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func didFinishUpdate() {
        // Updates controller location for switching orientations
        updateControllerLocation()
    }
}
