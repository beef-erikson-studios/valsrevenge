//
//  GameScene+ViewUpdates.swift
//  valsrevenge
//
//  Created by Troy Martin on 9/4/24.
//

import SpriteKit

extension GameScene: GameViewControllerDelegate {
    
    /// Sets the layout and handles orientation scale size.
    func didChangeLayout() {
        let w = view?.bounds.size.width ?? 1024
        let h = view?.bounds.size.height ?? 1336
        
        // Portrait view - as designed
        if h >= w {
            camera?.setScale(1.0)
        }
        // Landscape view - higher numbers result in "smaller" screens
        else {
            camera?.setScale(1.25)
        }
    }
}
