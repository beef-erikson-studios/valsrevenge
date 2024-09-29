//
//  GameViewController.swift
//  valsrevenge
//
//  Created by Troy Martin on 9/1/24.
//

import UIKit
import SpriteKit
import GameplayKit


// MARK: - PROTOCOLS

protocol GameViewControllerDelegate {
    func didChangeLayout()
}

class GameViewController: UIViewController {
    
    // MARK: - OVERRIDES

    /// Override used to set up the View Controller.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. Provides gameplay related content like entities / graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = false
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
    }

    /// Override that handles layout changes
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard
            let skView = self.view as? SKView,
            let gameViewControllerDelegate = skView.scene as? GameViewControllerDelegate
        else { return }
        
        gameViewControllerDelegate.didChangeLayout()
    }

    /// Handles orientation for phones; allows all but upside down on phones, all otherwise.
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    // Hides the status bar.
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
