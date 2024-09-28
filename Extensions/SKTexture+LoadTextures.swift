//
//  SKTexture+LoadTextures.swift
//  valsrevenge
//
//  Created by Troy Martin on 9/28/24.
//

import SpriteKit

extension SKTexture {
    
    // Builds an array of textures that will be used for animation.
    static func loadTextures(atlas: String, prefix: String, startsAt: Int, stopsAt: Int) -> [SKTexture] {
        
        // Creates a texture array and atles to store animation textures
        var textureArray = [SKTexture]()
        let textureAtlas = SKTextureAtlas(named: atlas)
        
        // Loops through start and stop points, applying textures based on prefix and index.
        for i in startsAt...stopsAt {
            let textureName = "\(prefix)\(i)"
            let texture = textureAtlas.textureNamed(textureName)
            textureArray.append(texture)
        }
        
        // Return the [SKTexture]
        return textureArray
    }
}
