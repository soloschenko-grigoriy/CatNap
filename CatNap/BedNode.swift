//
//  BedNode.swift
//  CatNap
//
//  Created by Gregory Soloshchenko on 8/25/17.
//  Copyright © 2017 GSClasses. All rights reserved.
//

import SpriteKit

class BedNode: SKSpriteNode, EventListenerNode{
    func didMoveToScene() {
        let bedBodySize = CGSize(width: 40.0, height: 30.0)
        physicsBody = SKPhysicsBody(rectangleOf: bedBodySize)
        physicsBody!.isDynamic = false
        physicsBody!.categoryBitMask = PhysicsCategory.Bed
        physicsBody!.collisionBitMask = PhysicsCategory.None
    }
}
