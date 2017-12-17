//
//  GameScene.swift
//  CatNap
//
//  Created by Gregory Soloshchenko on 7/17/17.
//  Copyright © 2017 GSClasses. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol EventListenerNode {
    func didMoveToScene()
}

protocol InteractiveNode {
    func interact()
}

struct PhysicsCategory {
    static let None:   UInt32 = 0         // 0
    static let Cat:    UInt32 = 0b1       // 1 = 2 ^ 0
    static let Block:  UInt32 = 0b10      // 2 = 2 ^ 1
    static let Bed:    UInt32 = 0b100     // 4 = 2 ^ 2
    static let Edge:   UInt32 = 0b1000    // 8 = 2 ^ 3
    static let Label:  UInt32 = 0b10000   // 16 = 2 ^ 4
    static let Spring: UInt32 = 0b100000  // 32 = 2 ^ 5
    static let Hook:   UInt32 = 0b1000000 // 64 = 2 ^ 6
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var currentLevel: Int = 0
    
    var playable = true
    var bedNode: BedNode!
    var catNode: CatNode!
    
    var message: MessageNode?
    var hookBaseNode: HookBaseNode?
    var seesawBaseNode: SKSpriteNode?
    var seesawNode: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        let maxAspectRatio = CGFloat(16.0/9.0)
        let maxAspectRatioHeight = size.width/maxAspectRatio
        let playbleMargin: CGFloat = (size.height - maxAspectRatioHeight)/2
        let playbleRect = CGRect(x: 0, y: playbleMargin, width: size.width, height: size.height - playbleMargin*2)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: playbleRect)
        physicsWorld.contactDelegate = self
        physicsBody!.categoryBitMask = PhysicsCategory.Edge
        
        enumerateChildNodes(withName: "//*") { (node, _) in
            guard let eventListenerNode = node as? EventListenerNode else {
                return
            }
            
            eventListenerNode.didMoveToScene()
        }
        
        bedNode = childNode(withName: "bed") as! BedNode
        catNode = childNode(withName: "//cat_body") as! CatNode
        hookBaseNode = childNode(withName: "hookBase") as? HookBaseNode
        seesawBaseNode = childNode(withName: "seesawBase") as? SKSpriteNode
        seesawNode = childNode(withName: "seesaw") as? SKSpriteNode

        
//        SKTAudio.sharedInstance().playBackgroundMusic("backgroundMusic.mp3")
        
//        let rotationConstraint = SKConstraint.zRotation(SKRange(lowerLimit: -π/4, upperLimit: π/4))
//        catNode.parent!.constraints = [rotationConstraint]
        
    
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.Label | PhysicsCategory.Edge {
            messageBounced()
        }
        
        if collision == PhysicsCategory.Cat | PhysicsCategory.Hook && hookBaseNode?.isHooked == false {
            hookBaseNode!.hookCat(catPhysicsBody: catNode.parent!.physicsBody!)
        }

        if !playable {
            return
        }
        
        if collision == PhysicsCategory.Cat | PhysicsCategory.Bed {
            win()
        }else if collision == PhysicsCategory.Cat | PhysicsCategory.Edge {
            lose()
        }
    }
    
    func messageBounced() {
        guard let message = self.message else {
            return
        }
        
        message.bounced += 1
        
        if message.bounced == 4 {
            message.removeFromParent()
            self.message = nil
        }
    }
    
    func inGameMessage(text: String) {
        message = MessageNode(message: text)
        message!.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(message!)
    }
    
    func newGame() {
        view!.presentScene(GameScene.createLevel(number: currentLevel))
    }
    
    func win() {
        if currentLevel < 6 {
            currentLevel += 1
        }
        playable = false
//        SKTAudio.sharedInstance().pauseBackgroundMusic()
        SKTAudio.sharedInstance().playSoundEffect("win.mp3")
        
        inGameMessage(text: "Well done!")
        
        catNode.curlAt(scenePoint: bedNode.position)
        perform(#selector(newGame), with: nil, afterDelay: 3)
    }
    
    func lose() {
//        if currentLevel > 1 {
//            currentLevel -= 1
//        }
        
        playable = false
        
        catNode.wakeUp()
        
//        SKTAudio.sharedInstance().pauseBackgroundMusic()
//        SKTAudio.sharedInstance().playSoundEffect("lose.mp3")
        
        inGameMessage(text: "You lose!")
        
        perform(#selector(newGame), with: nil, afterDelay: 5)
    }
    
    class func createLevel(number level: Int) -> GameScene? {
        let scene = GameScene(fileNamed: "Level\(level)")!
        scene.currentLevel = level
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func didSimulatePhysics() {
        if !playable {
            return
        }
        
        if hookBaseNode?.isHooked == true{
            return
        }

        if fabs(catNode.parent!.zRotation) > CGFloat(25).degreesToRadians() {
            lose()
        }
        
    }
}
