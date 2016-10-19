//
//  Player.swift
//  cursorsIO
//
//  Created by Jared Siskin on 1/17/15.
//  Copyright (c) 2015 Jared Siskin. All rights reserved.
//

import Foundation
import SpriteKit

class Player : SKSpriteNode{
    
    init(imageNamed name:String, cursorSize: CGSize){
        let texture = SKTexture(imageNamed: name)
        let percent = cursorSize.height/texture.size().height
        
        super.init(texture: texture, color: nil, size: CGSize(width: texture.size().width*percent, height: texture.size().height*percent))
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}