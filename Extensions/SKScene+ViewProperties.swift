//
//  SKScene+ViewProperties.swift
//  valsrevenge
//
//  Created by Troy Martin on 9/4/24.
//

import SpriteKit

extension SKScene {
    
    // MARK: - VIEW EDGE PROPERTIES
    
    // Top
    var viewTop: CGFloat {
        return convertPoint(fromView: CGPoint.zero).y
    }
    
    // Bottom
    var viewBottom: CGFloat {
        guard let view = view else { return 0.0 }
        return convertPoint(fromView: CGPoint(x: 0.0, y: view.bounds.size.height)).y
    }
    
    // Left
    var viewLeft: CGFloat {
        return convertPoint(fromView: CGPoint.zero).x
    }
    
    // Right
    var viewRight: CGFloat {
        guard let view = view else { return 0.0 }
        return convertPoint(fromView: CGPoint(x: view.bounds.size.width, y: 0.0)).x
    }
    
    // Insets
    var insets: UIEdgeInsets {
        return UIApplication.shared.delegate?.window??.safeAreaInsets ?? .zero
    }
}
