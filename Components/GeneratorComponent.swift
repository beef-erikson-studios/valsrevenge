//
//  GeneratorComponent.swift
//  valsrevenge
//
//  Created by Troy Martin on 9/27/24.
//

import SpriteKit
import GameplayKit

class GeneratorComponent: GKComponent {
    
    var isRunning: Bool = false
    
    // MARK: - INSPECTABLE PROPERTIES
    
    @GKInspectable var monsterType: String = GameObject.defaultGeneratorType
    @GKInspectable var maxMonsters: Int = 10
    
    @GKInspectable var waitTime: TimeInterval = 5
    @GKInspectable var monsterHealth: Int = 3
    
    
    // MARK: - OVERRIDES
    
    /// Initializations.
    override func didAddToEntity() {
    }
    
    /// This is needed so things load properly.
    override class var supportsSecureCoding: Bool {
        true
    }
    
    /// Spawns monsters if in PlayingState.
    override func update(deltaTime seconds: TimeInterval) {
        if let scene = componentNode.scene as? GameScene {
            switch scene.mainGameStateMachine.currentState {
            case is PauseState:
                if isRunning == true {
                    stopGenerator()
                }
            case is PlayingState:
                if isRunning == false {
                    startGenerator()
                }
            default:
                break
            }
        }
    }
    
    // MARK: - FUNCTIONS
    
    /// Starts spawning monsters until maxMonsters is hit.
    func startGenerator() {
        isRunning = true
        
        // Waits and spawns monster
        let wait = SKAction.wait(forDuration: waitTime)
        let spawn = SKAction.run { [unowned self] in self.spawnMonsterEntity() }
        let sequence = SKAction.sequence([wait, spawn])
        
        // Max monsters = 0 repeat forever
        let repeatAction: SKAction?
        if maxMonsters == 0 {
            repeatAction = SKAction.repeatForever(sequence)
        } else {
            repeatAction = SKAction.repeat(sequence, count: maxMonsters)
        }
        
        // Runs the repeat action
        componentNode.run(repeatAction!, withKey: "spawnMonster")
    }
    
    /// Stops spawning monsters.
    func stopGenerator() {
        isRunning = false
        componentNode.removeAction(forKey: "spawnMonster")
    }
    
    /// Monster spawner - spawn a monster based on monster type.
    func spawnMonsterEntity() {
        // Create monster entity and add the render component with the appropriate sprite.
        let monsterEntity = MonsterEntity(monsterType: monsterType)
        let renderComponent = RenderComponent(imageNamed: "\(monsterType)_0", scale: 0.65)
        monsterEntity.addComponent(renderComponent)
        
        // Create monster entity node and add to parent as a child
        if let monsterNode = monsterEntity.component(ofType: RenderComponent.self)?.spriteNode {
            monsterNode.position = componentNode.position
            componentNode.parent?.addChild(monsterNode)
            
            // Initial spawn movement, preferance in spawning to the left
            let randomPositions: [CGFloat] = [-50, -50, 50]
            let randomX = randomPositions.randomElement() ?? 0
            monsterNode.run(SKAction.moveBy(x: randomX, y: 0, duration: 1.0))
            
            // Sets and adds healthComponent
            let healthComponent = HealthComponent()
            healthComponent.currentHealth = monsterHealth
            monsterEntity.addComponent(healthComponent)
            
            // Add the agent component
            let agentComponent = AgentComponent()
            monsterEntity.addComponent(agentComponent)
            
            // Add the physics component
            let physicsComponent = PhysicsComponent()
            physicsComponent.bodyCategory = PhysicsCategory.monster.rawValue
            componentNode.entity?.addComponent(physicsComponent)
        }
    }
}
