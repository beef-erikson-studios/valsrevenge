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
        
        // Create the view
        if let view = self.view as! SKView? {
            // Creates title scene and set aspect
            let scene = TitleScene(fileNamed: "TitleScene")
            scene?.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(scene)
            
            // Set view options
            view.ignoresSiblingOrder = false
            view.showsPhysics = false
            view.showsFPS = false
            view.showsNodeCount = false
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
