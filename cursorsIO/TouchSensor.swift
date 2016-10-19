//
//  TouchSensor.swift
//  cursorsIO
//
//  Created by Michael Janvier on 1/20/15.
//  Copyright (c) 2015 Jared Siskin. All rights reserved.
//

import Foundation
import SpriteKit

class TouchSensor : SKSpriteNode{
    
    var counterDown = 1
    var requiredCursors = 1
    var displayCursorsNeeded = 1
    
    var dWalls = [DynamicWall]()
    
    init(newNode: SKSpriteNode){
       
        
        requiredCursors = Int(newNode.zPosition*(-1))
        counterDown=requiredCursors
        displayCursorsNeeded = requiredCursors
        super.init(texture: newNode.texture, color: newNode.color, size: newNode.size)
         alpha = newNode.alpha
    }
    
    func setDynamicWalls(setWalls: [DynamicWall]){
        dWalls = setWalls
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func CursorOn(){
        println("cursor entered " + color.description + " touch sensor")
      
        //when you touch it subtract one
        --counterDown
        if(counterDown>0){
            --displayCursorsNeeded
            //subtract one from the number youre displaying also (not yet implemented)
        }
        
        if(counterDown==0){
            
            HideAllWalls()
            //when you hit 0, hide all walls
        }
        
        println(counterDown)
        
    }
    func HideAllWalls(){
        for wall in dWalls{
            wall.hide()
        }
        
    }
    func ShowAllWalls(){
        for wall in dWalls{
            wall.show()
        }
        
    }
    func CursorOff(){
        println("cursor left " + color.description + " touch sensor")
        
        if(counterDown==0){
            //if currently 0 and a cursor leaves, now you gotta show all walls
            ShowAllWalls()
        }
        if(counterDown<requiredCursors)
        {
            //then add one to this stuff yah
            ++counterDown
            displayCursorsNeeded++
        }
        
        println(counterDown)
        
    }
    
}
