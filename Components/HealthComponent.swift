//
//  HealthComponent.swift
//  valsrevenge
//
//  Created by Troy Martin on 9/24/24.
//

import SpriteKit
import GameplayKit

class HealthComponent : GKComponent {
    
    // MARK: - INSPECTOR PROPERTIES
    
    @GKInspectable var currentHealth: Int = 3
    @GKInspectable var maxHealth: Int = 3
    
    
    // MARK: - PRIVATES
    
    private let healthFull = SKTexture(imageNamed: "health_full")
    private let healthEmpty = SKTexture(imageNamed: "health_empty")
    
    private var hitAction = SKAction()
    private var dieAction = SKAction()
    
    
    // MARK: - HEALTH METER FUNCTIONS
    
    /// Adds health meter above the entity. Also handles hit / death actions.
    override func didAddToEntity() {
        // Place health above head and sets health to 0
        if let healthMeter = SKReferenceNode(fileNamed: "HealthMeter") {
            healthMeter.position = CGPoint(x: 0, y: 100)
            componentNode.addChild(healthMeter)
            updateHealth(0, forNode: componentNode)
            
            // Player hit / death
            if let _ = componentNode as? Player {
                hitAction = SKAction.playSoundFileNamed("player_hit", waitForCompletion: false)
                
                let playSound = SKAction.playSoundFileNamed("player_die", waitForCompletion: false)
                dieAction = SKAction.run {
                    self.componentNode.run(playSound, completion: {
                        // TODO: Add code to restart the game - for now, reset health.
                        self.currentHealth = self.maxHealth
                    })
                }
            // Monster hit / death
            } else {
                hitAction = SKAction.playSoundFileNamed("monster_hit", waitForCompletion: false)
                
                let playSound = SKAction.playSoundFileNamed("monster_die", waitForCompletion: false)
                
                dieAction = SKAction.run {
                    self.componentNode.run(playSound, completion: {
                        self.componentNode.removeFromParent()
                    })
                }
            }
        }
    }
    
    /// Updates the health meter.
    func updateHealth(_ value: Int, forNode node: SKNode?) {
        currentHealth += value
        
        // Lock health to maxHealth
        if currentHealth > maxHealth {
            currentHealth = maxHealth
        }
        
        // Run hit or die actions
        if value < 0 {
            if currentHealth == 0 {
                componentNode.run(dieAction)
            } else {
                componentNode.run(hitAction)
            }
        }
        
        // Sets health
        if let _ = node as? Player {
            for barNum in 1...maxHealth {
                setupBar(at: barNum, tint: .cyan)
            }
        } else {
            for barNum in 1...maxHealth {
                setupBar(at: barNum)
            }
        }
    }
    
    /// Setup the health meter. Includes tint, full health, and empty health.
    func setupBar(at num: Int, tint: SKColor? = nil) {
        // Sets health
        guard let health = componentNode.childNode(withName: ".//health_\(num)") as? SKSpriteNode else { return }
        
        // Full health
        if currentHealth >= num {
            health.texture = healthFull
            // Sets tint
            if let tint = tint {

                health.color = tint
                health.colorBlendFactor = 1.0
            }
        // Empty health
        } else {
            health.texture = healthEmpty
            health.colorBlendFactor = 0.0
        }
    }

    // True to avoid loading issues due to using archived scene files
    override class var supportsSecureCoding: Bool {
        true
    }
    
    // Do things on removal
    //override func willRemoveFromEntity() {
    // }
    
    // Frame updates
    // override func update(deltaTime seconds: TimeInterval) {
    // }
}
