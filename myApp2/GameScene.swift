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
    let path = NSBundle.mainBundle().pathForResource("MyParticle", ofType: "sks")
    var contactCount = 0
    var contactCountLabel: SKLabelNode?
    
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -1.8)
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        user.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(50, 50))
        user.physicsBody!.affectedByGravity = false
        user.physicsBody!.dynamic = false
        user.physicsBody!.categoryBitMask = redCategory
        user.physicsBody!.contactTestBitMask = greenCategory
        
        startBtn.size = CGSizeMake(100, 100)
        startBtn.position = CGPoint(x: self.frame.width / 2, y: 1200)
        
        user.size = CGSizeMake(120, 120)
        user.position = CGPoint(x: self.frame.width / 2, y: 100)
        self.addChild(user)
        self.addChild(startBtn)
        
        let contactCountLabel = SKLabelNode(fontNamed: "Chalkduster")
        contactCountLabel.position = CGPoint(x: size.width * 0.92, y: size.height * 0.92)
        contactCountLabel.fontSize = 40
        contactCountLabel.horizontalAlignmentMode = .Right
        contactCountLabel.fontColor = UIColor.whiteColor()
        contactCountLabel.text = "\(contactCount) / 1000"
        addChild(contactCountLabel)
        self.contactCountLabel = contactCountLabel

        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            
            let location = touch.locationInNode(self)
            let toucheNode = self.nodeAtPoint(location)
            
            if toucheNode == startBtn {
                for var i = 0; i < 101; i++ {
                    var sprite = SKSpriteNode(texture: myTexture)
                    sprite.position = startBtn.position
                    sprite.size = CGSizeMake(20, 20)
                    sprite.physicsBody = SKPhysicsBody(circleOfRadius: 10)
                    sprite.physicsBody?.friction = 0.0
                    sprite.physicsBody!.restitution = 0.2
                    sprite.physicsBody!.velocity = CGVectorMake(100, 400)
                    self.addChild(sprite)
                }
            }
        }
    }
    
//    衝突時の処理
    func didBeginContact(contact: SKPhysicsContact) {
        
        var firstBody, secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask & redCategory != 0 && secondBody.categoryBitMask & greenCategory != 0 {
            secondBody.node!.removeFromParent()
            contactCount++
        }
        
        var particle = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode
        particle.position = contact.contactPoint
        particle.numParticlesToEmit = 100 // 何個、粒を出すか。
        particle.particleBirthRate = 200 // 一秒間に何個、粒を出すか。
        particle.particleSpeed = 80 // 粒の速度
        particle.xAcceleration = 0
        particle.yAcceleration = 0 // 加速度
        self.addChild(particle)
        
        contactCountLabel?.text = "\(contactCount) / 1000"
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
