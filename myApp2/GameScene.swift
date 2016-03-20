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
//        重力の指定
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -1.2)
        self.physicsWorld.contactDelegate = self
//        適応範囲の指定
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(x: 0, y: -800, width: size.width, height: size.height * 2))
//        物体シミュレーションに適応する大きさの指定
        user.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(125, 125))
//        重力を適応させない
        user.physicsBody!.affectedByGravity = false
//        動く物体かどうか。 false = 動かない
        user.physicsBody!.dynamic = false
//        カテゴリの設定
        user.physicsBody!.categoryBitMask = redCategory
        user.physicsBody!.contactTestBitMask = greenCategory
//        constraints(制約)適応範囲の指定
        let ConstraintYRange = SKRange(lowerLimit: self.frame.minY, upperLimit: self.frame.maxY / 3 - 50)
        let yconst = SKConstraint.positionY(ConstraintYRange)
        user.constraints = [yconst]
        
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
//            タッチされた場にあるNodeの検知
            let toucheNode = self.nodeAtPoint(location)
            
            if toucheNode == startBtn {
                for var i = 0; i < 101; i++ {
                    var sprite = SKSpriteNode(texture: myTexture)
                    sprite.position = startBtn.position
                    sprite.size = CGSizeMake(20, 20)
//                    sprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 21, height: 21))
                    sprite.physicsBody = SKPhysicsBody(circleOfRadius: 10)
//                    sprite.physicsBody = SKPhysicsBody(circleOfRadius: 10, center: location)
//                    摩擦力の指定
                    sprite.physicsBody?.friction = 0.0
//                    反発力の指定
                    sprite.physicsBody!.restitution = 0.2
//                    押し出す力の方向を指定
                    sprite.physicsBody!.velocity = CGVector(dx: 0, dy: 400)
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
            var particle = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode
            particle.position = contact.contactPoint
            particle.numParticlesToEmit = 100 // 何個、粒を出すか。
            particle.particleBirthRate = 200 // 一秒間に何個、粒を出すか。
            particle.particleSpeed = 80 // 粒の速度
            particle.xAcceleration = 0
            particle.yAcceleration = 0 // 加速度
            self.addChild(particle)
            secondBody.node!.removeFromParent()
            contactCount++
        }
        contactCountLabel?.text = "\(contactCount) / 1000"
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            
            let location = touch.locationInNode(self)
            let t = CGPoint(x: self.frame.minY, y: self.frame.maxY / 3 - 50)
//            タップされた場が指定範囲内だった場合
            if t {
                print("tap")
                user.position = location
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        
    }
    
}
