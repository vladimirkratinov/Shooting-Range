//
//  GameScene.swift
//  Shooting Range
//
//  Created by Vladimir Kratinov on 2022/2/10.
//

import SpriteKit

class GameScene: SKScene {
    var background:         SKSpriteNode!
    var disableTouchNode:   SKSpriteNode!
    var target:             SKSpriteNode!
    var aim:                SKSpriteNode!
    var gun:                SKSpriteNode!
    var reloadButton:       SKSpriteNode!
    var gameOverImage:      SKSpriteNode!
    
    var explosion:          SKEmitterNode!
    
    var reloadLabel:        SKLabelNode!
    var finishTimeLabel:    SKLabelNode!
    var gameScore:          SKLabelNode!
    var ammoLabel:          SKLabelNode!
    var noAmmoLabel:        SKLabelNode!
    
    var reloadTimer:        Timer!
    var gameTimer1:         Timer!
    var gameTimer2:         Timer!
    var bombTimer:          Timer!
    var finishTimer:        Timer!
    
    var isGameOver =        false
    var isHit =             false
    var touchEnabled =      true
    
    var ammo : Int = 8 {
        didSet {
            ammoLabel.text = "Ammo: \(ammo)"
        }
    }
    
    var score: Int = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    var finishTime: Int = 60 {
        didSet {
            finishTimeLabel.text = "Time: \(finishTime)"
        }
    }
    
    override func didMove(to view: SKView) {
        background = SKSpriteNode(imageNamed: "stalker3")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.alpha = 1
        background.zPosition = -1
        background.isUserInteractionEnabled = false
        background.name = "background"
        addChild(background)
        
        gameOverImage = SKSpriteNode(imageNamed: "gameOver2")
        gameOverImage.texture = SKTexture(imageNamed: "gameOver2")
        gameOverImage.position = CGPoint(x: 470, y: 384)
        gameOverImage.zPosition = 999
        gameOverImage.alpha = 0
        addChild(gameOverImage)
        
        disableTouchNode = SKSpriteNode(color:SKColor(red:0.0,green:0.0,blue:0.0,alpha:0.0),size:self.size)
        disableTouchNode.position = CGPoint(x: 512, y: 384)
        disableTouchNode.isUserInteractionEnabled = true
        disableTouchNode.zPosition = -999
        addChild(disableTouchNode)
        
        aim = SKSpriteNode(imageNamed: "aim2")
        aim.zPosition = 1
        aim.alpha = 0
        addChild(aim)
        
        gun = SKSpriteNode(imageNamed: "gun1")
        gun.position = CGPoint(x: 900, y: 100)
        gun.alpha = 1
        gun.zRotation = 0
        gun.zPosition = 1
        gun.xScale = 1
        gun.yScale = 1
        addChild(gun)
        
        reloadButton = SKSpriteNode(imageNamed: "reload3")
        reloadButton.position = CGPoint(x: 80, y: 100)
        reloadButton.zPosition = 1
        reloadButton.alpha = 0
        reloadButton.name = "reload"
        addChild(reloadButton)
        
        finishTimeLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        finishTimeLabel.text = "Time: 60"
        finishTimeLabel.position = CGPoint(x: 1000, y: 730)
        finishTimeLabel.horizontalAlignmentMode = .right
        finishTimeLabel.fontColor = .white
        finishTimeLabel.fontSize = 30
        addChild(finishTimeLabel)
        
        gameScore = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontColor = .white
        gameScore.fontSize = 30
        addChild(gameScore)
        
        ammoLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        ammoLabel.text = "Ammo: 8"
        ammoLabel.position = CGPoint(x: 470, y: 8)
        ammoLabel.horizontalAlignmentMode = .center
        ammoLabel.fontColor = .white
        ammoLabel.fontSize = 30
        addChild(ammoLabel)
        
        noAmmoLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        noAmmoLabel.text = "No Ammo!"
        noAmmoLabel.position = CGPoint(x: 500, y: 350)
        noAmmoLabel.horizontalAlignmentMode = .center
        noAmmoLabel.fontColor = .white
        noAmmoLabel.fontSize = 48
        noAmmoLabel.alpha = 0
        addChild(noAmmoLabel)
        
        physicsWorld.gravity = .zero
        
        finishTimer = Timer.scheduledTimer(
                                            timeInterval: 1,
                                            target: self,
                                            selector: #selector(countFinishTime),
                                            userInfo: nil,
                                            repeats: true)
        
        gameTimer1 = Timer.scheduledTimer(
                                            timeInterval: TimeInterval(Int.random(in: 2...4)),
                                            target: self,
                                            selector: #selector(createTarget1),
                                            userInfo: nil,
                                            repeats: true)

        gameTimer2 = Timer.scheduledTimer(
                                            timeInterval: TimeInterval(Int.random(in: 4...8)),
                                            target: self,
                                            selector: #selector(createTarget2),
                                            userInfo: nil,
                                            repeats: true)

        bombTimer = Timer.scheduledTimer(
                                            timeInterval: TimeInterval(Int.random(in: 8...10)),
                                            target: self,
                                            selector: #selector(createBomb),
                                            userInfo: nil,
                                            repeats: true)
    }
    
    //game over:
    @objc func countFinishTime() {
        if finishTime > 0 {
            finishTime -= 1
        } else {
            isGameOver = true
            gameTimer1.invalidate()
            gameTimer2.invalidate()
            bombTimer.invalidate()
            disableTouchNode.zPosition = 999
            gameOverImage.alpha = 1
            gun.alpha = 0
            finishTimeLabel.alpha = 0
            ammoLabel.alpha = 0
            gameScore.position = CGPoint(x: 400, y: 260)
            gameScore.fontColor = .systemYellow
        }
    }
    
    @objc func createTarget1() {
        let targets = ["plate1", "plate2", "plate3", "plate4"]
        let randomTarget = targets.randomElement()
        let sprite = SKSpriteNode(imageNamed: randomTarget!)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 500...700))
        sprite.name = "target"
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)    //speed of moving: push to left
        sprite.physicsBody?.angularVelocity = 5                     //constant spin
        sprite.physicsBody?.linearDamping = 0                       //controls how fast things slow over time
        sprite.physicsBody?.angularDamping = 0
    }
    
    @objc func createTarget2() {
        let targets = ["plate1", "plate2", "plate3", "plate4"]
        let randomTarget = targets.randomElement()
        let sprite = SKSpriteNode(imageNamed: randomTarget!)
        sprite.position = CGPoint(x: -200, y: Int.random(in: 250...400))
        sprite.name = "target"
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.velocity = CGVector(dx: 600, dy: 0)    //speed of moving: push to left
        sprite.physicsBody?.angularVelocity = 5                     //constant spin
        sprite.physicsBody?.linearDamping = 0                       //controls how fast things slow over time
        sprite.physicsBody?.angularDamping = 0
    }
    
    @objc func createBomb() {
        let sprite = SKSpriteNode(imageNamed: "bomb")
        sprite.position = CGPoint(x: -100, y: Int.random(in: 200...730))
        sprite.name = "bomb"
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.velocity = CGVector(dx: 250, dy: 0)    //speed of moving: push to left
        sprite.physicsBody?.angularVelocity = 5                     //constant spin
        sprite.physicsBody?.linearDamping = 0                       //controls how fast things slow over time
        sprite.physicsBody?.angularDamping = 0
    }
    
    //delete nods:
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.name == "target" || node.name == "bomb" {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    node.removeFromParent()
                }
            }
            
            if node.name == "explosion"{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    node.removeFromParent()
                }
            }
            
            if node.name == "ammoCasing" {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    node.removeFromParent()
                }
            }
        }
    }
    
    //when tapped:
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touchEnabled == true {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            let tappedNodes = nodes(at: location)
    
            //aim position:
            aim.position = location
                
            //check target name:
            for node in tappedNodes {
                
                //target:
                if node.name == "target" {
                    if ammo > 0 {
                        score += 1
                        let targetHit = SKAction.moveBy(x: CGFloat(Int.random(in: -200...200)), y: -1000, duration: 0.5)
                        node.run(targetHit)
                    }
                }
                
                //bomb:
                if node.name == "bomb" {
                    score -= 5
                    
                    let sprite = SKSpriteNode(imageNamed: "bang")
                    sprite.position = node.position
                    sprite.name = "bomb"
                    addChild(sprite)
                    
                    node.removeFromParent()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        sprite.removeFromParent()
                    }
                }
                
                //reload:
                if node.name == "reload" {
                    reloadButtonAnimation()
                    noAmmoLabel.alpha = 0
                }
                
                //background:
                if node.name == "background" {
                    if ammo > 0 {
                        ammo -= 1
                        gunAnimation()
                        aimAnimation()
                        ammoCasingAnimation()
                    } else {
                        noAmmoAnimation()
                        noAmmoLabel.text = "No Ammo!"
                        reloadButton.alpha = 1
                        noAmmoLabel.alpha = 1
                    }
                }
            }
            //turn off User Touch:
            print("touches Disabled")
            touchEnabled = false
            
            //turn on User Touch:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                print("touches Enabled")
                self.touchEnabled = true
            }
        }
    }
    
    func reloadButtonAnimation() {
        reloadTimer = Timer.scheduledTimer(
            timeInterval: 0.6,
            target: self,
            selector: #selector(reload),
            userInfo: nil,
            repeats: true)
    }
    
    @objc func reload() {
        if ammo < 8 {
            ammo += 1
            noAmmoLabel.text = "Recharging..."
            
            //reload animation:
            reloadAnimation()
            
            //turn off user interaction:
            disableTouchNode.zPosition = 999
            
            //button animation:
            let scale = SKAction.scale(by: 1.1, duration: 0.2)
            let scaleBack = SKAction.scale(by: 1, duration: 0.2)
            let delay = SKAction.wait(forDuration: 0.1)
            let sequence = SKAction.sequence([scale, scaleBack, delay])
            reloadButton.run(sequence)
            reloadButton.xScale = 1
            reloadButton.yScale = 1
            
        } else {
            
            noAmmoLabel.text = "Fire!"
            reloadButton.alpha = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.noAmmoLabel.alpha = 0
            }
            
            //destroy timer:
            reloadTimer.invalidate()
            //turn on user interaction:
            disableTouchNode.zPosition = -999
            
            
        }
    }
    
    func reloadAnimation() {
        let scale = SKAction.scale(by: 1.1, duration: 0.15)
//        let delay = SKAction.wait(forDuration: 0.1)
        let moveTo = SKAction.move(by: CGVector(dx: 10, dy: -10), duration: 0.15)
        let moveBack = SKAction.move(by: CGVector(dx: -10, dy: 10), duration: 0.15)
        let sequence = SKAction.sequence([moveTo, scale, moveBack])
        
        gun.run(sequence)
//        gun.zRotation = 0.0
        gun.yScale = 1
        gun.xScale = 1
        gun.position = CGPoint(x: 900, y: 100)
    }
    
    func aimAnimation() {
        let scale = SKAction.scale(by: 1.1, duration: 0.4)
        aim.run(scale)
        aim.yScale = 1
        aim.xScale = 1
        aim.alpha = 1
    }
    
    func gunAnimation() {
        //fire effect:
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = CGPoint(x: 850, y: 330)
        explosion.name = "explosion"
        addChild(explosion)
        
        let scale = SKAction.scale(by: 1.1, duration: 0.15)
        let moveTo = SKAction.move(by: CGVector(dx: 50, dy: -50), duration: 0.15)
        let moveBack = SKAction.move(by: CGVector(dx: -50, dy: 50), duration: 0.15)
        let sequence = SKAction.sequence([moveTo, scale, moveBack])
        
        gun.run(sequence)
        gun.zRotation = 0.0
        gun.yScale = 1
        gun.xScale = 1
        gun.position = CGPoint(x: 900, y: 100)
    }
    
    func noAmmoAnimation() {
        let scale = SKAction.scale(by: 1.1, duration: 0.15)
        let delay = SKAction.wait(forDuration: 0.1)
        let moveTo = SKAction.move(by: CGVector(dx: 10, dy: -10), duration: 0.15)
        let moveBack = SKAction.move(by: CGVector(dx: -10, dy: 10), duration: 0.15)
        let rotate = SKAction.rotate(byAngle: 0.3, duration: 0.1)
        let rotateBack = SKAction.rotate(byAngle: -0.3, duration: 0.1)
        let sequence = SKAction.sequence([rotate, moveTo, scale, moveBack, rotateBack, delay])
        
        gun.run(sequence)
        gun.zRotation = 0.0
        gun.yScale = 1
        gun.xScale = 1
        gun.position = CGPoint(x: 900, y: 100)
    }
    
    func ammoCasingAnimation() {
        let ammoCasing = SKSpriteNode(imageNamed: "ammoCasing")
        ammoCasing.position = CGPoint(x: gun.position.x + 50, y: gun.position.y + 100)
        ammoCasing.name = "ammoCasing"
        ammoCasing.zRotation = 1.5
        addChild(ammoCasing)
        
        let moveTo = SKAction.move(by: CGVector(dx: 500, dy: ammoCasing.position.y - 200), duration: 0.5)
        ammoCasing.run(moveTo)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        aim.alpha = 1
        aim.position = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        aim.alpha = 0
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { }
    }
}
