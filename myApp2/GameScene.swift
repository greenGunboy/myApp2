//
//  GameScene.swift
//  myApp2
//
//  Created by Tsubasa Takahashi on 2016/03/16.
//  Copyright (c) 2016年 Tsubasa Takahashi. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var myTexture = SKTexture(imageNamed: "maru.png")
    var user = SKSpriteNode(imageNamed: "")
    var startBtn = SKSpriteNode(imageNamed: "maru.png")
    let redCategory: UInt32 = 0x1 << 0
    let greenCategory: UInt32 = 0x1 << 1
    
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -3.0)
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        user.physicsBody!.categoryBitMask = redCategory
        user.physicsBody!.contactTestBitMask = greenCategory
        
//        var a:SKSpriteNode = SKSpriteNode(color: SKColor.blackColor(), size: CGSizeMake(15, 80))
//        a.size = CGSizeMake(150, 150)
//        a.position = CGPoint(x: 500, y: 300)
//        a.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 185, height: 205))
        
        startBtn.size = CGSizeMake(100, 100)
        startBtn.position = CGPoint(x: self.frame.width / 2, y: 1200)
        
        user.size = CGSizeMake(120, 120)
        
        self.addChild(user)
        self.addChild(startBtn)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            
            let location = touch.locationInNode(self)
            let toucheNode = self.nodeAtPoint(location)
            
            if toucheNode == startBtn {
                for var i = 0; i < 100; i++ {
                    var sprite = SKSpriteNode(texture: myTexture)
                    sprite.position = startBtn.position
                    sprite.size = CGSizeMake(20, 20)
                    sprite.physicsBody = SKPhysicsBody(circleOfRadius: 10)
                    sprite.physicsBody?.friction = 0.0
                    sprite.physicsBody!.restitution = 0.2
                    sprite.physicsBody!.velocity = CGVectorMake(500, 400)
                    self.addChild(sprite)
                }
            }
        }
    }
    
//    衝突時の処理
    func didBeginContact(contact: SKPhysicsContact) {
        
        var firstBody, secondBody: SKPhysicsBody
        
        // firstを赤、secondを緑とする。
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 赤と緑が接したときの処理。
        if firstBody.categoryBitMask && user != 0 && secondBody.categoryBitMask & myTexture != 0 {
                secondBody.node!.removeFromParent()
        }

    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            
            let location = touch.locationInNode(self)
            user.position = location
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        
    }
    
}
