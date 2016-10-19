//
//  GameScene.swift
//  cursorsTesting
//
//  Created by Jared Siskin on 1/17/15.
//  Copyright (c) 2015 Jared Siskin. All rights reserved.
//


import SpriteKit

class GameLogic: SKScene, SKPhysicsContactDelegate {
    
    var circleMarker = SKSpriteNode(imageNamed: "circleMarker")
    
    var player: Player!// = Player(imageNamed: "cursorMaker.PNG")
    //get overwritten later but idk how to declare without initializing something
    
    
    var touchLocation: CGPoint!// = CGPointMake(0, 0)
    //das how you do it
    
    
    
    func SwitchToLevel(level: Int){//loads the scene named "level"+ the number +".sks"
        var levelName = "level" + String(level)
        var scene = GameLogic(fileNamed: levelName)
        let skView = self.view as SKView!
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
    }
    
    
    //var exitToFirstLevel: SKSpiteNode!
    
    
    enum colliderType:UInt32 {
        case Cursor = 1
        case exitBox = 2
        case touchPad = 4
        case world = 8
        case dynamicWall = 16
    }
    
    
    func LoadLevel(){
        
        var dWalls = [DynamicWall]()
        var color = UIColor.blueColor()
        var wallsOfColor = [color:dWalls]
        
        wallsOfColor.removeValueForKey(UIColor.blueColor())
        //add and remove a value because I dont know how to declare empty array again aha
        
        
        self.physicsWorld.contactDelegate = self
        //first finds exit box
        var FoundExitBox: SKSpriteNode!
        var RealExitBox: SKSpriteNode!
        if childNodeWithName("exit") != nil {
            FoundExitBox = childNodeWithName("exit") as! SKSpriteNode
            RealExitBox = SKSpriteNode(color: FoundExitBox.color, size: FoundExitBox.size) //finds the box labeled "exit"
            RealExitBox.zPosition = FoundExitBox.zPosition  //gives it a z value later used to determine what level to transport to
            RealExitBox.position = FoundExitBox.position
            RealExitBox.physicsBody = SKPhysicsBody(rectangleOfSize: FoundExitBox.size)
            RealExitBox.physicsBody?.allowsRotation = false
            RealExitBox.physicsBody?.usesPreciseCollisionDetection = true
            RealExitBox.physicsBody?.dynamic = false
            RealExitBox.physicsBody?.categoryBitMask = colliderType.exitBox.rawValue  //and gives it a collider type
            RealExitBox.physicsBody?.contactTestBitMask = colliderType.Cursor.rawValue
            RealExitBox.physicsBody?.collisionBitMask = colliderType.Cursor.rawValue
            self.addChild(RealExitBox)
            FoundExitBox.removeFromParent()
        }
        
        //then finds all walls
        enumerateChildNodesWithName("DynamicWall", usingBlock: { FoundWall, stop in
            if(FoundWall != nil){
                var tempWall = FoundWall as! SKSpriteNode
                var wall = DynamicWall(newNode: tempWall)
                var wallColor: UIColor = wall.color.colorWithAlphaComponent(1)
                if(wallsOfColor[wallColor] != nil){
                    wallsOfColor[wallColor]?.append(wall)} //if the dictionary has an entry for that color, add to the array in the dictionary
                else{
                    var walls = [DynamicWall]()  //else, create an array and add to dictionary
                    walls.append(wall)
                    wallsOfColor[wallColor]=walls
                }//dictionary wallsOfColor[blue] will give an array of all blue dynamic walls
                dWalls.append(wall)
                wall.position = tempWall.position
                wall.physicsBody = SKPhysicsBody(rectangleOfSize: wall.size)
                wall.physicsBody?.dynamic = false
                wall.physicsBody?.pinned = true
                wall.physicsBody?.categoryBitMask = colliderType.dynamicWall.rawValue
                wall.physicsBody?.contactTestBitMask = colliderType.Cursor.rawValue //then do the collision stuff and stuff
                wall.physicsBody?.collisionBitMask = colliderType.Cursor.rawValue
                tempWall.removeFromParent()
                self.addChild(wall)
            }
            
        })
        
        
        //next to touch sensors
        enumerateChildNodesWithName("TouchSensor", usingBlock: { FoundTouchSensor, stop in
            if(FoundTouchSensor != nil){
                var tempSensor = FoundTouchSensor as! SKSpriteNode
                tempSensor.zPosition = FoundTouchSensor.zPosition
                var RealTouchSensor: TouchSensor = TouchSensor(newNode: tempSensor)
            
                if(wallsOfColor[RealTouchSensor.color.colorWithAlphaComponent(1)] != nil){
                    RealTouchSensor.setDynamicWalls(wallsOfColor[RealTouchSensor.color.colorWithAlphaComponent(1)]!)}
                    //if the dictionary has an array of walls that matches the color of the touch sensor,
                //pass the touch sensor the array of walls
                
                RealTouchSensor.physicsBody = SKPhysicsBody(rectangleOfSize: RealTouchSensor.size)
                RealTouchSensor.physicsBody?.categoryBitMask = colliderType.touchPad.rawValue
                RealTouchSensor.physicsBody?.contactTestBitMask = colliderType.Cursor.rawValue
                RealTouchSensor.physicsBody?.dynamic = false
                RealTouchSensor.physicsBody?.pinned = true
                RealTouchSensor.physicsBody?.collisionBitMask = colliderType.world.rawValue//idk what to do here but this dont work
                var bitMask = RealTouchSensor.physicsBody?.collisionBitMask
                var intMask = Int(bitMask!)
                println("Collision bit mask is "+intMask.description)
                RealTouchSensor.position = FoundTouchSensor.position
            //    RealTouchSensor.color = UIColor.blueColor()//this line just for testing
                self.addChild(RealTouchSensor)
                FoundTouchSensor.removeFromParent()
            }
            
        })
        
        
        /*
        * so here's how it's done when objects have the same collsion bit mask they pass through each other 
        * but keep contact and category normal 
        */
        

        //next do player
        var spawn = childNodeWithName("spawn") as! SKSpriteNode //find the node named spawn
        self.player = Player(imageNamed: "cursorMaker.PNG", cursorSize: spawn.size)//and replace with a functional player
        self.player.zPosition = spawn.zPosition
        self.player.position = spawn.position
        self.player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        self.player.physicsBody?.affectedByGravity = false
        self.player.physicsBody?.allowsRotation = false
        self.player.physicsBody?.mass = 20
        self.player.physicsBody?.usesPreciseCollisionDetection = true
        self.player.physicsBody?.contactTestBitMask = colliderType.touchPad.rawValue | colliderType.exitBox.rawValue | colliderType.world.rawValue | colliderType.dynamicWall.rawValue
        self.player.physicsBody?.categoryBitMask = colliderType.Cursor.rawValue
        self.player.physicsBody?.collisionBitMask = colliderType.world.rawValue  //set to 0 because we fought xcode and xcode won
        self.addChild(player)
        spawn.removeFromParent()
        self.addChild(circleMarker)
        
        
        self.circleMarker.zPosition = -5
        self.circleMarker.anchorPoint = CGPointMake(0.5, 0.5)
        self.circleMarker.setScale(CGFloat(0.3))
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        //self.physicsWorld.gravity = CGVectorMake(0,0);
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var cursor = contact.bodyA
        var object = contact.bodyB
        if(contact.bodyA.categoryBitMask == colliderType.Cursor.rawValue){
            //we good
        }
        else{
            //switch em
            cursor = contact.bodyB
            object = contact.bodyA
        }
        //code makes sure cursor is the cursor physics body and object is whatever it collided with
        
        if(object.categoryBitMask  == colliderType.exitBox.rawValue)//if its an exit node
        {
            
            var SetLevel = 0
            var NewLevel = object.node?.zPosition
            SetLevel = Int(NewLevel!)
            var newLevelInt = Int(SetLevel*(-1))
            //load the level corresponding to its z position
            SwitchToLevel(newLevelInt)
        }
            
            
        else if(object.categoryBitMask == colliderType.touchPad.rawValue)//touchPad
        {
            //if its a touchsensor
            var TouchPad = object.node as! TouchSensor
            TouchPad.CursorOn()
            //tell it a cursor entered it
        }
  
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        var cursor = contact.bodyA
        var object = contact.bodyB
        if(contact.bodyA.categoryBitMask == colliderType.Cursor.rawValue){
            //we good
        }
        else{
            //switch em
            cursor = contact.bodyB
            object = contact.bodyA
        }
        if(object.categoryBitMask == colliderType.touchPad.rawValue)//touchPad
        {
            var TouchPad = object.node as! TouchSensor
            //if you leave a touch sensor, also tell it that
            TouchPad.CursorOff()
        }
        
        
        
    }

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.physicsWorld.contactDelegate = self
        
        LoadLevel();
        
        
        
    }
    
  //  override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
  //  }
    
    
    
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
    
    func CollidableObject(name: String?) -> Bool{
        if name != nil{
        if name == "wall" || name == "DynamicWall"
        {return true}
        else{
            return false}
        }
        else {return false}
    }
    
    let COLLISION_ACCURACY = 4
    func distanceToLeftWall(check: SKSpriteNode, newx: Int) -> CGFloat{
        var distance = newx
        for var y = (Int(check.position.y) - (Int(check.size.height)/2)) + 3; y<=Int(check.position.y)+(Int(check.size.height)/2) - 3;y=y+Int(check.size.height)/COLLISION_ACCURACY{
            for var distanceCheck = 0; distanceCheck>=0+newx; --distanceCheck
            {
                var xCheck = Int(check.position.x) - Int(check.size.width/2)+distanceCheck
                var x = CGFloat(xCheck)
                var point=(CGPointMake(x, CGFloat(y)))
                var node = self.nodeAtPoint(point)
                if CollidableObject(node.name) {
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
        for var y = (Int(check.position.y) - (Int(check.size.height)/2)) + 3; y<=Int(check.position.y)+(Int(check.size.height)/2) - 3;y=y+Int(check.size.height)/COLLISION_ACCURACY{
            for var distanceCheck = 0; distanceCheck<=0+newx; ++distanceCheck
            {
                var xCheck = Int(check.position.x) + Int(check.size.width/2)+distanceCheck
                var x = CGFloat(xCheck)
                var point=(CGPointMake(x, CGFloat(y)))
                var node = self.nodeAtPoint(point)
                if CollidableObject(node.name) {
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
        for var x = (Int(check.position.x) - (Int(check.size.width)/2)) + 3; x<=Int(check.position.x)+(Int(check.size.width)/2) - 3;x=x+Int(check.size.width)/COLLISION_ACCURACY{
            for var distanceCheck = 0; distanceCheck<=0+newy; ++distanceCheck
            {
                var yCheck = Int(check.position.y) + Int(check.size.height/2)+distanceCheck
                var y = CGFloat(yCheck)
                var point=(CGPointMake(CGFloat(x), y))
                var node = self.nodeAtPoint(point)
                if CollidableObject(node.name) {
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
        for var x = (Int(check.position.x) - (Int(check.size.width)/2)) + 3; x<=Int(check.position.x)+(Int(check.size.width)/2) - 3;x=x+Int(check.size.width)/COLLISION_ACCURACY{
            for var distanceCheck = 0; distanceCheck>=0+newy; --distanceCheck
            {
                var yCheck = Int(check.position.y) - Int(check.size.height/2)+distanceCheck
                var y = CGFloat(yCheck)
                var point=(CGPointMake(CGFloat(x), y))
                var node = self.nodeAtPoint(point)
                if CollidableObject(node.name) {
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
