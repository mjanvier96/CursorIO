//
//  GameScene.swift
//  cursorsTesting
//
//  Created by Jared Siskin on 1/17/15.
//  Copyright (c) 2015 Jared Siskin. All rights reserved.
//


import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var circleMarker = SKSpriteNode(imageNamed: "circleMarker")
   
    var player: Player!// = Player(imageNamed: "cursorMaker.PNG")
    //get overwritten later but idk how to declare without initializing something
    
    
    var touchLocation: CGPoint!// = CGPointMake(0, 0)
    //das how you do it
    
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        println("We are here at level 1")
    
        var spawn = childNodeWithName("spawn") as! SKSpriteNode
        player = Player(imageNamed: "cursorMaker.PNG", cursorSize: spawn.size)
        player.zPosition = spawn.zPosition
        player.position = spawn.position
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.mass = 20
        player.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(player)
        spawn.removeFromParent()
        addChild(circleMarker)
        circleMarker.zPosition = -5
        circleMarker.anchorPoint = CGPointMake(0.5, 0.5)
        circleMarker.setScale(CGFloat(0.3))
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        //self.physicsWorld.gravity = CGVectorMake(0,0);
        
        
        
    }
    
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            touchLocation = touch.locationInNode(self)
            //mySprite.position = touch.locationInNode(self)
            
        }
    }
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            
            var offset = CGPoint(x: touch.locationInNode(self).x - touchLocation.x, y: touch.locationInNode(self).y - touchLocation.y)
            
            
            if(offset.x < 0){
               var distLeft = distanceToLeftWall(player, newx: Int(offset.x))
                if offset.x < distLeft
                {
                    offset.x = distLeft
                }
            }else
            if(offset.x > 0){
                var distRight = distanceToRightWall(player, newx: Int(offset.x))
                if offset.x > distRight
                {
                    offset.x = distRight
                }
            }
             player.position = CGPoint(x: player.position.x+offset.x/1, y: player.position.y)
            if(offset.y > 0){
                var distAbove = distanceToAboveWall(player, newy: Int(offset.y))
                if offset.y > distAbove
                {
                    offset.y = distAbove
                }
            }else
            if(offset.y < 0){
                var distAbove = distanceToBelowWall(player, newy: Int(offset.y))
                if offset.y < distAbove
                {
                    offset.y = distAbove
                }
            }
           

                player.position = CGPoint(x: player.position.x, y: player.position.y+offset.y/1)
            
            
            touchLocation=touch.locationInNode(self)
            //mySprite.position = touch.locationInNode(self)
            
        }
    }
    
    func distanceToLeftWall(check: SKSpriteNode, newx: Int) -> CGFloat{
        var distance = newx
        for var y = (Int(check.position.y) - (Int(check.size.height)/2)) + 3; y<=Int(check.position.y)+(Int(check.size.height)/2) - 3;y=y+11{
            for var distanceCheck = 0; distanceCheck>=0+newx; --distanceCheck
            {
                var xCheck = Int(check.position.x) - Int(check.size.width/2)+distanceCheck
                var x = CGFloat(xCheck)
                var point=(CGPointMake(x, CGFloat(y)))
                var node = self.nodeAtPoint(point)
                 if node.name == "wall" {
                    if distanceCheck>distance{
                        distance=distanceCheck
                        distanceCheck=0 + newx - 1
                    }
                }
                }
            }
            
            return CGFloat(distance);
        }
        
    func distanceToRightWall(check: SKSpriteNode, newx: Int) -> CGFloat{
        var distance = newx
        for var y = (Int(check.position.y) - (Int(check.size.height)/2)) + 3; y<=Int(check.position.y)+(Int(check.size.height)/2) - 3;y=y+11{
            for var distanceCheck = 0; distanceCheck<=0+newx; ++distanceCheck
            {
                var xCheck = Int(check.position.x) + Int(check.size.width/2)+distanceCheck
                var x = CGFloat(xCheck)
                var point=(CGPointMake(x, CGFloat(y)))
                var node = self.nodeAtPoint(point)
                if node.name == "wall" {
                    if distanceCheck<distance{
                        distance=distanceCheck
                        distanceCheck=0 + newx + 1
                    }
                }
            }
        }
        
        return CGFloat(distance);
    }
    
    func distanceToAboveWall(check: SKSpriteNode, newy: Int) -> CGFloat{
        var distance = newy
        for var x = (Int(check.position.x) - (Int(check.size.width)/2)) + 3; x<=Int(check.position.x)+(Int(check.size.width)/2) - 3;x=x+11{
            for var distanceCheck = 0; distanceCheck<=0+newy; ++distanceCheck
            {
                var yCheck = Int(check.position.y) + Int(check.size.height/2)+distanceCheck
                var y = CGFloat(yCheck)
                var point=(CGPointMake(CGFloat(x), y))
                var node = self.nodeAtPoint(point)
                if node.name == "wall" {
                    if distanceCheck<distance{
                        distance=distanceCheck
                        distanceCheck=0 + newy + 1
                    }
                }
            }
        }
        
        return CGFloat(distance);
    }
    
    func distanceToBelowWall(check: SKSpriteNode, newy: Int) -> CGFloat{
        var distance = newy
        for var x = (Int(check.position.x) - (Int(check.size.width)/2)) + 3; x<=Int(check.position.x)+(Int(check.size.width)/2) - 3;x=x+11{
            for var distanceCheck = 0; distanceCheck>=0+newy; --distanceCheck
            {
                var yCheck = Int(check.position.y) - Int(check.size.height/2)+distanceCheck
                var y = CGFloat(yCheck)
                var point=(CGPointMake(CGFloat(x), y))
                var node = self.nodeAtPoint(point)
                if node.name == "wall" {
                    if distanceCheck>distance{
                        distance=distanceCheck
                        distanceCheck=0 + newy - 1
                    }
                }
            }
        }
        
        return CGFloat(distance);
    }
    
    

    //var cursorMaker = SKSpriteNode(imageNamed: "Cursor")
    
    override func update(currentTime: CFTimeInterval) {
       circleMarker.position = player.position
       //cursorMaker.position = player.position
    }
}
