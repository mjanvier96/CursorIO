//
//  ExitScene.swift
//  cursorsIO
//
//  Created by Michael Janvier on 1/19/15.
//  Copyright (c) 2015 Jared Siskin. All rights reserved.
//

import Foundation
import SpriteKit

class ExitScene: SKSpriteNode {

    init(exitBoxSize: CGSize, exitColor: UIColor){
        super.init(texture: nil, color: exitColor, size: exitBoxSize)
        
    }
    
    init(newSpriteNode: SKSpriteNode)
    {
        super.init(texture: newSpriteNode.texture, color: newSpriteNode.color, size: newSpriteNode.size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
