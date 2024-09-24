//
//  HealthComponent.swift
//  valsrevenge
//
//  Created by Troy Martin on 9/24/24.
//

import SpriteKit
import GameplayKit

class HealthComponent : GKComponent {
    
    // MARK: - Inspector Variables
    
    @GKInspectable var currentHealth: Int = 3
    @GKInspectable var maxHealth: Int = 3
    
    
    // MARK: - Private Variables
    
    private let healthFull = SKTexture(imageNamed: "health_full")
    private let healthEmpty = SKTexture(imageNamed: "health_empty")
    
    
    // MARK: - Health Meter Functions
    
    // Adds health meter above the entity
    override func didAddToEntity() {
        
        // Grab the node
        guard let node = entity?.component(ofType: GKSKNodeComponent.self)?.node
                else { return }
        
        // Place health above head and sets health to 0
        if let healthMeter = SKReferenceNode(fileNamed: "HealthMeter") {
            healthMeter.position = CGPoint(x: 0, y: 100)
            node.addChild(healthMeter)
            updateHealth(0, forNode: node)
        }
    }
    
    // Updates the health meter
    func updateHealth(_ value: Int, forNode node: SKNode?) {
        currentHealth += value
        
        // Lock health to maxHealth
        if currentHealth > maxHealth {
            currentHealth = maxHealth
        }
        
        // Sets health
        for barNum in 1...maxHealth {
            (node as? Player) != nil ?
            setupBar(at: barNum, tint: .cyan) :
            setupBar(at: barNum)
        }
    }
    
    // Setup health meter
    func setupBar(at num: Int, tint: SKColor? = nil) {
        // Grab the node
        guard let node = entity?.component(ofType: GKSKNodeComponent.self)?.node
                else { return }
        
        // Sets health
        if let health = node.childNode(withName: ".//health_\(num)") as? SKSpriteNode {
            if currentHealth >= num {
                health.texture = healthFull
                // Sets tint
                if let tint = tint {
                    health.color = tint
                    health.colorBlendFactor = 1.0
                }
            } else {
                health.texture = healthEmpty
                health.colorBlendFactor = 0.0
            }
        }
    }
    
    override func willRemoveFromEntity() {
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {

    }
    
    // True to avoid loading issues due to using archived scene files
    override class var supportsSecureCoding: Bool {
        true
    }
}
