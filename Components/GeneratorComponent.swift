//
//  GeneratorComponent.swift
//  valsrevenge
//
//  Created by Troy Martin on 9/27/24.
//

import SpriteKit
import GameplayKit

class GeneratorComponent: GKComponent {
    
    // MARK: - INSPECTABLE PROPERTIES
    
    @GKInspectable var monsterType: String = "skeleton"
    @GKInspectable var maxMonsters: Int = 10
    
    @GKInspectable var waitTime: TimeInterval = 5
    @GKInspectable var monsterHealth: Int = 3
    
    
    // MARK: - OVERRIDES
    
    // Spawns a monster while maxMonsters isn't hit
    override func didAddToEntity() {
        
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
    
    override class var supportsSecureCoding: Bool {
        true
    }
    
    
    // MARK: - FUNCTIONS
    
    // Monster Spawner
    func spawnMonsterEntity() {
        
        // Create monster entity and add the render component with the appropriate sprite.
        let monsterEntity = MonsterEntity(monsterType: monsterType)
        let renderComponent = RenderComponent(imageNamed: "\(monsterType)_0", scale: 0.65)
        monsterEntity.addComponent(renderComponent)
        
        // Create monster entity node and add to parent as a child
        if let monsterNode = monsterEntity.component(ofType: RenderComponent.self)?.spriteNode {
            monsterNode.position = componentNode.position
            componentNode.parent?.addChild(monsterNode)
            
            // Move monster to the right 100px
            monsterNode.run(SKAction.moveBy(x: 100, y: 0, duration: 1.0))
            
            // Sets and adds healthComponent
            let healthComponent = HealthComponent()
            healthComponent.currentHealth = monsterHealth
            monsterEntity.addComponent(healthComponent)
        }
    }
}
