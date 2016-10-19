//
//  MenuScene.swift
//  cursorsIO
//
//  Created by Michael Janvier on 1/19/15.
//  Copyright (c) 2015 Jared Siskin. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene, SKPhysicsContactDelegate{
    
    var circleMarker = SKSpriteNode(imageNamed: "circleMarker")
    
    var exitToFirstLevel: ExitScene!
    var exitToOptions: ExitScene!// = childNodeWithName("OptionMenuExit") as SKSpiteNode
    var player: Player!// = Player(imageNamed: "cursorMaker.PNG")
    //get overwritten later but idk how to declare without initializing something
    
    
    var touchLocation: CGPoint!// = CGPointMake(0, 0)
    //das how you do it
    
    let COLLISION_ACCURACY=4
    
    
    enum colliderType:UInt32 {
        case Cursor = 1
        case exitOptionMenu = 2
        case exitStartFirstLevel = 3
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.physicsWorld.contactDelegate = self
        
        var startFirstLevelBox = childNodeWithName("StartFirstLevelExit") as! SKSpriteNode
        var optionsMenuBox = childNodeWithName("OptionMenuExit") as! SKSpriteNode
        var spawn = childNodeWithName("spawn") as! SKSpriteNode
        
        self.exitToFirstLevel = ExitScene(exitBoxSize: startFirstLevelBox.size, exitColor: startFirstLevelBox.color)
        self.exitToOptions = ExitScene(exitBoxSize: optionsMenuBox.size, exitColor: optionsMenuBox.color)
        self.player = Player(imageNamed: "cursorMaker.PNG", cursorSize: spawn.size)
         
        self.exitToFirstLevel.zPosition = startFirstLevelBox.zPosition
        self.exitToFirstLevel.position = startFirstLevelBox.position
        self.exitToFirstLevel.physicsBody = SKPhysicsBody(rectangleOfSize: startFirstLevelBox.size)
        self.exitToFirstLevel.physicsBody?.allowsRotation = false
        self.exitToFirstLevel.physicsBody?.usesPreciseCollisionDetection = true
        self.exitToFirstLevel.physicsBody?.dynamic = false
        self.exitToFirstLevel.physicsBody?.categoryBitMask = colliderType.exitStartFirstLevel.rawValue
        self.exitToFirstLevel.physicsBody?.contactTestBitMask = colliderType.Cursor.rawValue
        self.exitToFirstLevel.physicsBody?.collisionBitMask = colliderType.Cursor.rawValue
        
        self.exitToOptions.zPosition = optionsMenuBox.zPosition
        self.exitToOptions.position = optionsMenuBox.position
        self.exitToOptions.physicsBody = SKPhysicsBody(rectangleOfSize: optionsMenuBox.size)
        self.exitToOptions.physicsBody?.allowsRotation = false
        self.exitToOptions.physicsBody?.usesPreciseCollisionDetection = true
        self.exitToOptions.physicsBody?.dynamic = false
        self.exitToOptions.physicsBody?.categoryBitMask = colliderType.exitOptionMenu.rawValue
        self.exitToOptions.physicsBody?.contactTestBitMask = colliderType.Cursor.rawValue
        self.exitToOptions.physicsBody?.collisionBitMask = colliderType.Cursor.rawValue
        
        self.player.zPosition = spawn.zPosition
        self.player.position = spawn.position
        self.player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        self.player.physicsBody?.affectedByGravity = false
        self.player.physicsBody?.allowsRotation = false
        self.player.physicsBody?.mass = 20
        self.player.physicsBody?.usesPreciseCollisionDetection = true
        self.player.physicsBody?.categoryBitMask = colliderType.Cursor.rawValue
        self.player.physicsBody?.contactTestBitMask = colliderType.exitOptionMenu.rawValue | colliderType.exitStartFirstLevel.rawValue
        self.player.physicsBody?.collisionBitMask = colliderType.exitOptionMenu.rawValue | colliderType.exitStartFirstLevel.rawValue
        
        
        
        self.addChild(player)
        spawn.removeFromParent()
        self.addChild(circleMarker)
        self.addChild(exitToFirstLevel)
        startFirstLevelBox.removeFromParent()
        self.addChild(exitToOptions)
        optionsMenuBox.removeFromParent()
        self.circleMarker.zPosition = -5
        self.circleMarker.anchorPoint = CGPointMake(0.5, 0.5)
        self.circleMarker.setScale(CGFloat(0.3))
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        //self.physicsWorld.gravity = CGVectorMake(0,0);
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        if(contact.bodyA.categoryBitMask  == colliderType.exitStartFirstLevel.rawValue || contact.bodyB.categoryBitMask  == colliderType.exitStartFirstLevel.rawValue)
        {
            var scene = GameLogic(fileNamed: "GameScene")
            let skView = self.view as SKView!
            skView.ignoresSiblingOrder = true
            skView.presentScene(scene)
        }
        
        if(contact.bodyA.categoryBitMask  == colliderType.exitOptionMenu.rawValue || contact.bodyB.categoryBitMask  == colliderType.exitOptionMenu.rawValue)
        {
            var scene = OptionsMenuScene(fileNamed: "OptionsMenuScene")
            let skView = self.view as SKView!
            skView.ignoresSiblingOrder = true
            skView.presentScene(scene)
        }
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
        for var y = (Int(check.position.y) - (Int(check.size.height)/2)) + 3; y<=Int(check.position.y)+(Int(check.size.height)/2) - 3;y=y+(Int(check.size.height)-6/COLLISION_ACCURACY){
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
        for var y = (Int(check.position.y) - (Int(check.size.height)/2)) + 3; y<=Int(check.position.y)+(Int(check.size.height)/2) - 3;y=y+(Int(check.size.height)-6/COLLISION_ACCURACY){
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
        for var x = (Int(check.position.x) - (Int(check.size.width)/2)) + 3; x<=Int(check.position.x)+(Int(check.size.width)/2) - 3;x=x+(Int(check.size.width)-6/COLLISION_ACCURACY){
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
        for var x = (Int(check.position.x) - (Int(check.size.width)/2)) + 3; x<=Int(check.position.x)+(Int(check.size.width)/2) - 3;x=x+(Int(check.size.width)-6/COLLISION_ACCURACY){
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
