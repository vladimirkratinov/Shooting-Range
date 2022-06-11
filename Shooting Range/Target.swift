//
//  Target.swift
//  Shooting Range
//
//  Created by Vladimir Kratinov on 2022/2/10.
//

import UIKit
import SpriteKit

class Target: SKNode {
    var targetNode: SKSpriteNode!
    
    var isVisible = false
    var isHit = false
    
    func configure(at position: CGPoint) {
        self.position = position
        
        targetNode = SKSpriteNode(imageNamed: "target")
        targetNode.position = CGPoint(x: 0, y: 0)
        targetNode.name = "target"
        targetNode.texture = SKTexture(imageNamed: "target")
        addChild(targetNode)
    }
    
    func show(hideTime: Double) {
        if isVisible { return }
        
        targetNode.run(SKAction.moveBy(x: 100, y: 0, duration: 1))
        isVisible = true
        isHit = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) {
            [weak self] in
            self?.hide()
        }
    }
    
    func hide() {
        if !isVisible { return }
    
        targetNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }
    
    func hit() {
        isHit = true
        
//        if let smokeParticles = SKEmitterNode(fileNamed: "smokeParticle") {
//            smokeParticles.position = charNode.position
//            addChild(smokeParticles)
//        }
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run { [weak self] in self?.isVisible = false }
        let sequence = SKAction.sequence([delay, hide, notVisible])
        targetNode.run(sequence)
    }

}
