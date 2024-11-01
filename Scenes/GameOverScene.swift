//
//  GameOverScene.swift
//  valsrevenge
//
//  Created by Tammy Coron on 7/4/20.
//  Copyright © 2020 Just Write Code LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOverScene: SKScene {
  
    private var newGameButton: SKSpriteNode!
    private var loadGameButton: SKSpriteNode!
  
    /// Override to initialize the new game button and load game buttons.
    override func didMove(to view: SKView) {
        newGameButton = childNode(withName: "newGameButton") as? SKSpriteNode
        loadGameButton = childNode(withName: "loadGameButton") as? SKSpriteNode
    }
  
    // MARK: - TOUCH HANDLERS

    /* ############################################################ */
    /*                 TOUCH HANDLERS STARTS HERE                   */
    /* ############################################################ */

    
    /// Starts either new game or load game depending on which were touched.
    ///
    /// - Parameters:
    ///   - pos: position of touch to test on.
    func touchDown(atPoint pos : CGPoint) {
        let nodeAtPoint = atPoint(pos)
        if newGameButton.contains(nodeAtPoint) {
            startNewGame()
        } else if loadGameButton.contains(nodeAtPoint) {
            resumeSavedGame()
        }
    }
  
    /// Loops through touches to trigger events.
    ///
    /// - Parameters:
    ///   - touches: Set of UITouch events.
    ///   - event: Event to trigger.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {self.touchDown(atPoint: t.location(in: self))}
    }
}
