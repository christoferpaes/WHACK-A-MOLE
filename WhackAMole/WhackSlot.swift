//
//  WhackSlot.swift
//  WhackAMole
//
//  Created by Christofer Patrick Paes on 6/9/19.
//  Copyright © 2019 Christofer Patrick Paes. All rights reserved.
//

import UIKit
import SpriteKit


class WhackSlot: SKNode {
    
    
    var charNode: SKSpriteNode!
    
    var isVisible = false
    var isHit = false
    
    
    
    
    func configure(at position: CGPoint) {
        self.position = position
        let sprite = SKSpriteNode(imageNamed: "dirtyHole")
        addChild(sprite)
        
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 25)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        
        charNode = SKSpriteNode (imageNamed: "moleHole")
        charNode.position = CGPoint(x: 0, y: -180)
        charNode.name = "character"
        cropNode.addChild(charNode)
        addChild(cropNode)
    }
    func show(hideTime: Double) {
        if isVisible{return}
        charNode.xScale = 1
        charNode.yScale = 1
        
        charNode.run(SKAction.moveBy(x: 0, y: 0, duration: 0.05))
        isVisible = true
        isHit = false
        
        
        if Int.random(in: 0...2) == 0  {
            charNode.texture = SKTexture(imageNamed: "moleHole")
            charNode.name = "charFriend"
            
           
        } else {
            charNode.texture = SKTexture(imageNamed: "badMole")
            charNode.name = "charEnemy"
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) {
            [weak self] in
            self?.hide()
        }
    }
    
    func hide() {
        if !isVisible {return}
        charNode.run(SKAction.moveBy(x: 0, y: 180, duration: 0.05))
        isVisible = true
        
        
        
    }
    
    func hit() {
        isHit = true
        
        let delay = SKAction.wait(forDuration: 0.25)
        
        let hide = SKAction.moveBy(x: 0, y: -180, duration: 0.05)
        
        let notVisible = SKAction.run { [weak self] in self?.isVisible = false }
        
        
        let sequence = SKAction.sequence([delay, hide, notVisible])
        charNode.run(sequence)
    }
}
