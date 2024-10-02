//
//  PhysicsCategory.swift
//  valsrevenge
//
//  Created by Troy Martin on 10/1/24.
//

import SpriteKit
import GameplayKit

enum PhysicsCategory: String {
    case player
    case wall
    case door
    case monster
    case projectile
    case collectible
    case exit
}

enum PhysicsShape: String {
    case circle
    case rect
}
