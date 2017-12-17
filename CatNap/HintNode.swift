//
//  HintNode.swift
//  CatNap
//
//  Created by Gregory Soloshchenko on 8/28/17.
//  Copyright © 2017 GSClasses. All rights reserved.
//

import SpriteKit

class HintNode: SKSpriteNode, EventListenerNode, InteractiveNode {
    var arrowPath: CGPath = {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0.5, y: 65.69))
        bezierPath.addLine(to: CGPoint(x: 74.99, y: 1.5))
        bezierPath.addLine(to: CGPoint(x: 74.99, y: 38.66))
        bezierPath.addLine(to: CGPoint(x: 257.5, y: 38.66))
        bezierPath.addLine(to: CGPoint(x: 257.5, y: 92.72))
        bezierPath.addLine(to: CGPoint(x: 74.99, y: 92.72))
        bezierPath.addLine(to: CGPoint(x: 74.99, y: 126.5))
        bezierPath.addLine(to: CGPoint(x: 0.5, y: 65.69))
        bezierPath.close()
        return bezierPath.cgPath
    }()
    
    let colors = [SKColor.red, SKColor.yellow, SKColor.orange]
    
    var currentColor = 0
    
    var shape: SKShapeNode!
    
    func didMoveToScene() {
        isUserInteractionEnabled = true
        
        color = SKColor.clear
        
        shape = SKShapeNode(path: arrowPath)
        shape.strokeColor = SKColor.gray
        shape.lineWidth = 4
        shape.glowWidth = 5
        shape.fillColor = SKColor.white
        shape.fillTexture = SKTexture(imageNamed: "wood_tinted")
        shape.alpha = 0.8
        addChild(shape)
        
        let move = SKAction.moveBy(x: -40, y: 0, duration: 1.0)
        let bounce = SKAction.sequence([
            move, move.reversed()
            ])
        let bounceAction = SKAction.repeat(bounce, count: 3)
        
        shape.run(bounceAction, completion: {
            self.removeFromParent()
        })
    }
    
    func interact() {
        currentColor += 1
        if currentColor >= colors.count {
            currentColor = 0
        }

        shape.fillColor = colors[currentColor]
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        interact()
    }
}
