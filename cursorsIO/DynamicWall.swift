//
//  DynamicWall.swift
//  cursorsIO
//
//  Created by Michael Janvier on 1/20/15.
//  Copyright (c) 2015 Jared Siskin. All rights reserved.
//

import Foundation
import SpriteKit

class DynamicWall : SKSpriteNode{
    
    var counter: UInt32!
    
    init(newNode: SKSpriteNode){
       
            super.init(texture: newNode.texture, color: newNode.color, size: newNode.size)
       
        self.name = "DynamicWall"
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func hide(){
        hidden=true;
       self.physicsBody?.collisionBitMask = GameLogic.colliderType.world.rawValue
    }
    func show(){
        hidden=false;
        self.physicsBody?.collisionBitMask = GameLogic.colliderType.Cursor.rawValue
    }
    //changes it to match the cursor if showing and to hide just makes it world which means pass through
}