//
//  MessageNode.swift
//  CatNap
//
//  Created by Gregory Soloshchenko on 8/25/17.
//  Copyright © 2017 GSClasses. All rights reserved.
//

import SpriteKit

class MessageNode: SKLabelNode{
    var bounced = 0
    
    convenience init(message: String) {
        self.init(fontNamed: "AvenirNext-Regular")
        text = message
        fontSize = 256.0
        fontColor = SKColor.gray
        zPosition = 100
        
        let front = SKLabelNode(fontNamed: "AvenirNext-Regular")
        front.text = message
        front.fontSize = 256.0
        front.fontColor = SKColor.white
        front.position = CGPoint(x: -2, y: -2)
        addChild(front)
        
        physicsBody = SKPhysicsBody(circleOfRadius: 10)
        physicsBody!.categoryBitMask = PhysicsCategory.Label
        physicsBody!.collisionBitMask = PhysicsCategory.Edge
        physicsBody!.contactTestBitMask = PhysicsCategory.Edge
        physicsBody!.restitution = 0.7
    }
    
    
}
