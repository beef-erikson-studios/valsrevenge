//
//  GameScene.swift
//  valsrevenge
//
//  Created by Troy Martin on 9/1/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // MARK: - PROPERTIES
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    let agentComponentSystem = GKComponentSystem(componentClass: GKAgent2D.self)
    
    let mainGameStateMachine = GKStateMachine(states: [PauseState(), PlayingState()])
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    private var player: Player?
    
    let margin: CGFloat = 20.0
    
    
    // MARK: CONTROLLER PROPERTIES
    
    private var leftTouch: UITouch?
    private var rightTouch: UITouch?
    
    lazy var controllerMovement: Controller? = {
        guard let player = player else { return nil }
        
        let stickImage = SKSpriteNode(imageNamed: "player-val-head_0")
        stickImage.setScale(0.75)
        
        let controller = Controller(stickImage: stickImage, attachedNode: player,
                                    nodeSpeed: player.movementSpeed, isMovement: true,
                                    range: 55.0, color: .darkGray)
        controller.setScale(0.65)
        controller.zPosition += 1
        
        controller.anchorLeft()
        controller.hideLargeArrows()
        controller.hideSmallArrows()
        
        return controller
    }()
    
    lazy var controllerAttack: Controller? = {
        guard let player = player else { return nil }
        
        let stickImage = SKSpriteNode(imageNamed: "controller_attack")
        
        let controller = Controller(stickImage: stickImage, attachedNode: player,
                                    nodeSpeed: player.projectileSpeed, isMovement: false,
                                    range: 55.0, color: .gray)
        controller.setScale(0.65)
        controller.zPosition += 1
        
        controller.anchorRight()
        controller.hideLargeArrows()
        controller.hideSmallArrows()
        
        return controller
    }()
    
    
    // MARK: - OVERRIDES
    
    /// On scene load, resets lastUpdateTime and loads gamedata.json. This saves new levels so player can retry a level on death.
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        
        GameData.shared.saveDataWithFileName("gamedata.json")
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
    

    // MARK: - SETUP FUNCTIONS
    
    /// Updates the control widgets to stay in the bottom right / bottom left.
    func updateControllerLocation() {
        controllerMovement?.position = CGPoint(x: viewLeft + margin + insets.left,
                                               y: viewBottom + margin + insets.bottom)
        
        controllerAttack?.position = CGPoint(x: viewRight - margin - insets.right,
                                             y: viewBottom + margin + insets.bottom)
    }
    
    /// Sets the camera up and contrains it to the player.
    func setupCamera() {
        guard let player = player else { return }
        let distance = SKRange(constantValue: 0)
        let playerConstraint = SKConstraint.distance(distance, to: player)
        camera?.constraints = [playerConstraint]
    }
    
    /// Sets up the player agent and HUD.
    func setupPlayer() {
        player = childNode(withName: "player") as? Player
    
        if let player = player {
            player.setupHUD(scene: self)
            agentComponentSystem.addComponent(player.agent)
        }
        
        if let controllerMovement = controllerMovement {
            addChild(controllerMovement)
        }
        
        if let controllerAttack = controllerAttack {
            addChild(controllerAttack)
        }
        
        // Positional audio - listener on player, position on exit
        setupMusic()
    }

    /// Sets up positional audio listener to the player node, position on exit.
    func setupMusic() {
        let musicNode = SKAudioNode(fileNamed: "music")
        musicNode.isPositional = false
        
        // Music gets louder as player approaches exit
        if let exit = childNode(withName: "exit") {
            musicNode.position = exit.position
            musicNode.isPositional = true
            listener = player
        }
        
        addChild(musicNode)
    }
    
    // MARK: - TOUCH CONTROLS
    
    /// On touch down - handles controls (movement / shooting).
    func touchDown(atPoint pos : CGPoint, touch: UITouch) {
        mainGameStateMachine.enter(PlayingState.self)
        
        let nodeAtPoint = atPoint(pos)
        
        if let controllerMovement = controllerMovement {
            if controllerMovement.contains(nodeAtPoint) {
                leftTouch = touch
                controllerMovement.beginTracking()
            }
        }
        
        if let controllerAttack = controllerAttack {
            if controllerAttack.contains(nodeAtPoint) {
                rightTouch = touch
                controllerAttack.beginTracking()
            }
        }
    }
    
    /// On touch moved, either attack or move depending on element touched.
    func touchMoved(toPoint pos : CGPoint, touch: UITouch) {
        switch touch {
        case leftTouch:
            if let controllerMovement = controllerMovement {
                controllerMovement.moveJoystick(pos: pos)
            }
        case rightTouch:
            if let controllerAttack = controllerAttack {
                controllerAttack.moveJoystick(pos: pos)
            }
        default:
            break
        }
    }
    
    /// On touch up, either stop movement or attacking depending on element up.
    func touchUp(atPoint pos : CGPoint, touch: UITouch) {
        switch touch {
        case leftTouch:
            if let controllerMovement = controllerMovement {
                controllerMovement.endTracking()
                leftTouch = touch
            }
        case rightTouch:
            if let controllerAttack = controllerAttack {
                controllerAttack.endTracking()
                rightTouch = touch
            }
        default:
            break
        }
    }
    
    /// On touch begin, pulse label with a fadeInOut.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self), touch: t) }
    }
    
    /// Move the touch.
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self), touch: t) }
    }
    
    /// End the touch.
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self), touch: t) }
    }
    
    /// Cancel the touch (end it).
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self), touch: t) }
    }
    
    
    // MARK: - HUD
    
    /// Keeps the HUD pinned to the top left of the screen.
    func updateHUDLocation() {
        player?.hud.position = CGPoint(x: viewRight - margin - insets.right,
                                       y: viewTop - margin - insets.top)
    }
    
    /// Updates controller location and HUD for switching orientations.
    override func didFinishUpdate() {
        updateControllerLocation()
        updateHUDLocation()
    }
}
