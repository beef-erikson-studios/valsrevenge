//
//  Controller.swift
//  valsrevenge
//
//  Created by Troy Martin on 10/20/24.
//

import SpriteKit

class Controller: SKReferenceNode {
    
    // MARK: - PROPERTIES
    
    private var isMovement: Bool!
    
    private var attachedNode: SKNode!
    private var nodeSpeed: CGFloat!
    
    private var base: SKNode!
    private var joystick: SKSpriteNode!
    private var range: CGFloat!
    
    private var isTracking: Bool = false
    
    
    // MARK: - CONTROLLER INIT
    
    /// Convenience initializer.
    convenience init(stickImage: SKSpriteNode?,
                     attachedNode: SKNode, nodeSpeed: CGFloat = 0.0,
                     isMovement: Bool = true, range: CGFloat = 55.0,
                     color: SKColor = .darkGray) {
        self.init(fileNamed: "Controller")
        
        // Set up the joystick
        joystick = childNode(withName: "//controller_stick") as? SKSpriteNode
        joystick.zPosition += 1
        if let stickImage = stickImage {
            joystick.addChild(stickImage)
        }
        
        // Sets the inner base shape of the joystick
        base = joystick.childNode(withName: "//controller_main")
        
        let innerBase = SKShapeNode(circleOfRadius: range * 2)
        innerBase.strokeColor = .black
        innerBase.fillColor = color
        base.addChild(innerBase)
        
        // Constrain joystick to base
        let rangeX = SKRange(lowerLimit: -range, upperLimit: range)
        let rangeY = SKRange(lowerLimit: -range, upperLimit: range)
        let lockToBase = SKConstraint.positionX(rangeX, y: rangeY)
        joystick.constraints = [lockToBase]
        
        // Set up remaining properties
        self.range = range
        
        self.attachedNode = attachedNode
        self.nodeSpeed = nodeSpeed
        
        self.isMovement = isMovement
    }
    
    /// This is needed to avoid delegate error.
    override init(fileNamed fileName: String?) {
        super.init(fileNamed: fileName)
    }
    
    /// This is required.
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - CONTROLLER ANCHORS
    
    /// Anchors the base position to the bottom right.
    func anchorRight() {
        scene?.anchorPoint = CGPoint(x: 1, y: 0)
        base.position = CGPoint(x: -175.0, y: 175.0)
    }
    
    /// Anchors the base position to the bottom left.
    func anchorLeft() {
        scene?.anchorPoint = CGPoint(x: 0, y: 0)
        base.position = CGPoint(x: 175.0, y: 175.0)
    }
    
    
    // MARK: - HIDE CONTROLS
    
    /// Hides all of the large arrows.
    func hideLargeArrows() {
        if let node = childNode(withName: "//controller_left") as? SKSpriteNode {
            node.isHidden = true
        }
        if let node = childNode(withName: "//controller_right") as? SKSpriteNode {
            node.isHidden = true
        }
        if let node = childNode(withName: "//controller_up") as? SKSpriteNode {
            node.isHidden = true
        }
        if let node = childNode(withName: "//controller_down") as? SKSpriteNode {
            node.isHidden = true
        }
    }
    
    /// Hides all of the small arrows.
    func hideSmallArrows() {
        if let node = childNode(withName: "//controller_topLeft") as? SKSpriteNode {
            node.isHidden = true
        }
        if let node = childNode(withName: "//controller_topRight") as? SKSpriteNode {
            node.isHidden = true
        }
        if let node = childNode(withName: "//controller_bottomLeft") as? SKSpriteNode {
            node.isHidden = true
        }
        if let node = childNode(withName: "//controller_bottomRight") as? SKSpriteNode {
            node.isHidden = true
        }
    }
    
    
    // MARK: - CONTROLLER METHODS
    
    /// Sets isTracking to true.
    func beginTracking() {
        isTracking = true
    }
    
    /// Stops tracking and resets control.
    func endTracking() {
        isTracking = false
        joystick.position = .zero
        moveAttachedNode(direction: .zero)
    }
    
    /// Moves the joystick GUI and calls the appropriate method based on controller type.
    func moveJoystick(pos: CGPoint) {
        // Store the location
        var location = pos
        
        // Verify player is using on-screen controls
        if isTracking == true {
            location = base.convert(pos, from: self.scene!)
        }
        
        // Move the joystick node
        let xAxis = CGFloat(location.x.clamped(to: -range...range))     // version 1
        let yAxis = CGFloat(location.y.clamped(v1: -range, v2: range))  // version 2
        joystick.position = CGPoint(x: location.x, y: location.y)
        
        // Call method based on controller type
        if isMovement {
            moveAttachedNode(direction: CGVector(dx: xAxis, dy: yAxis))
        } else {
            otherAction(direction: CGVector(dx: xAxis, dy: yAxis))
        }
    }
    
    /// Moves the attached player node.
    func moveAttachedNode(direction: CGVector) {
        attachedNode?.physicsBody?.velocity = CGVector(dx: CGFloat(direction.dx * nodeSpeed),
                                                       dy: CGFloat(direction.dy * nodeSpeed))
    }
    
    /// Performs attack as long as player exists.
    func otherAction(direction: CGVector) {
        guard let player = attachedNode as? Player else { return }
        
        player.attack(direction: direction)
    }
}
