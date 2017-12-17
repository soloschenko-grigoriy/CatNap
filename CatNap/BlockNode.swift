//
//  BlockNode.swift
//  CatNap
//
//  Created by Gregory Soloshchenko on 8/25/17.
//  Copyright © 2017 GSClasses. All rights reserved.
//

import SpriteKit

class BlockNode : SKSpriteNode, EventListenerNode, InteractiveNode{
    func didMoveToScene() {
        isUserInteractionEnabled = true
    }
    
    func interact() {
        isUserInteractionEnabled = false
        
        run(SKAction.sequence([
            SKAction.playSoundFileNamed("pop.mp3", waitForCompletion: false),
            SKAction.scale(by: 0.8, duration: 0.1),
            SKAction.removeFromParent()
        ]))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print("destroy block")
        interact()
    }
}
