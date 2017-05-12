//
//  GameScene.swift
//  PillBoy
//
//  Created by Khoa Bui on 5/10/17.
//  Copyright © 2017 Khoa Bui. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Declare global variables for global use
    var playerNode: SKSpriteNode!
    var enemyNode: SKSpriteNode!
    var playerMovementFrames: [SKTexture]!
    var enemyMovementFrames: [SKTexture]!
    
    let moveAnalogStick = AnalogJoystick(diameter: 80, colors: (UIColor.black, UIColor.gray)) //Create analog stick control
    
    //Create scene's contents
    override func didMove(to view: SKView) {
        
        //Create background
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        //Create background music
        let music = SKAudioNode(fileNamed: "Latin_Industries.mp3")
        music.autoplayLooped = true
        addChild(music)
        
        //Set frame's physics
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody!.restitution = 1 //Frame bounciness
        physicsBody!.friction = 0
        physicsBody!.linearDamping = 0
        physicsBody!.angularDamping = 0
        physicsBody!.isDynamic = false
        
        //Delegate is called when collision starts or ends
        physicsWorld.contactDelegate = self
        
        //Define animation folder
        let playerAtlas = SKTextureAtlas(named: "texture")
        
        //Select player animations
        let pd0 = playerAtlas.textureNamed("spr_p1_down_0.png")
        let pd1 = playerAtlas.textureNamed("spr_p1_down_1.png")
        let pd2 = playerAtlas.textureNamed("spr_p1_down_2.png")
        let pd3 = playerAtlas.textureNamed("spr_p1_down_3.png")
        
        //Select enemy animations
        let ph0 = playerAtlas.textureNamed("spr_p1_hurt_0.png")
        let ph1 = playerAtlas.textureNamed("spr_p1_down_0.png")
        
        playerMovementFrames = [pd0, pd1, pd2, pd3] //Create player's movement animation
        enemyMovementFrames = [ph0, ph1] //Create enemy's movement animation
        
        //Create player
        let firstFrame = playerMovementFrames[0]
        playerNode = SKSpriteNode(texture: firstFrame)
        playerNode.name = "player"
        playerNode.position = CGPoint(x: frame.width * 0.10, y: frame.height * 0.80)
        playerNode.physicsBody = SKPhysicsBody(texture: firstFrame, size: firstFrame.size())
        playerNode.physicsBody!.affectedByGravity = false
        playerNode.physicsBody!.allowsRotation = false
        playerNode.physicsBody!.friction = 0
        playerNode.physicsBody!.linearDamping = 0
        playerNode.physicsBody!.angularDamping = 0
        addChild(playerNode)
        
        //Create enemy
        let firstEnemyFrame = enemyMovementFrames[0]
        enemyNode = SKSpriteNode(texture: firstEnemyFrame)
        enemyNode.name = "enemy"
        enemyNode.position = CGPoint(x: frame.width * 0.90, y: frame.height * 0.20)
        enemyNode.physicsBody = SKPhysicsBody(texture: firstEnemyFrame, size: firstEnemyFrame.size())
        enemyNode.physicsBody!.affectedByGravity = false
        enemyNode.physicsBody!.allowsRotation = false
        enemyNode.physicsBody!.friction = 0
        enemyNode.physicsBody!.linearDamping = 0
        enemyNode.physicsBody!.angularDamping = 0
        addChild(enemyNode)
        
        //Set up analog stick
        moveAnalogStick.position = CGPoint(x: moveAnalogStick.radius + 15, y: moveAnalogStick.radius + 15)
        addChild(moveAnalogStick)
        
        //Handlers begin
        moveAnalogStick.startHandler = { [unowned self] in
            
            guard let aN = self.playerNode else { return }
            aN.run(SKAction.sequence([SKAction.scale(to: 1, duration: 0.5), SKAction.scale(to: 1, duration: 0.5)]))
        }
        
        moveAnalogStick.trackingHandler = { [unowned self] data in
            
            guard let aN = self.playerNode else { return }
            aN.position = CGPoint(x: aN.position.x + (data.velocity.x * 0.2), y: aN.position.y + (data.velocity.y * 0.3))
        }
        
        moveAnalogStick.stopHandler = { [unowned self] in
            
            guard let aN = self.playerNode else { return }
            aN.run(SKAction.sequence([SKAction.scale(to: 1, duration: 0.5), SKAction.scale(to: 1, duration: 0.5)]))
        }
        //Handlers end
        
        view.isMultipleTouchEnabled = true //Handles multiple touches in a sequence
        
        //Run player and enmy animation
        playerWalking()
        enemyWalking()
        
        //Enemy move and shoot
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(enemyMove), SKAction.wait(forDuration: 1), SKAction.run(enemyShoot), SKAction.wait(forDuration: 2)])))
    }
    
    func enemyMove () {
        enemyNode.run(SKAction.move(to: CGPoint(x: randomX(), y: randomY()), duration: 1))
    }
    
    func enemyShoot () {
        //Create projectile
        let projectile = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), color: UIColor.red, size: CGSize(width: 10, height: 10))
        projectile.name = "projectile"
        
        //Determine slope from enemy to player for projectile's positioning
        let x = (playerNode.position.x - enemyNode.position.x) * 0.02
        let y = (playerNode.position.y - enemyNode.position.y) * 0.02
        let m = y / x
        
        //Set projectile's position based on quadrant
        if (x > 0 && y > 0) {
            projectile.position = CGPoint(x: enemyNode.position.x + sqrt(1600.0 / (1.0 + m * m)), y: enemyNode.position.y + sqrt(1600.0 / (1.0 / (m * m) + 1.0)))
        }
        else if (x > 0 && y < 0) {
            projectile.position = CGPoint(x: enemyNode.position.x + sqrt(1600.0 / (1.0 + m * m)), y: enemyNode.position.y - sqrt(1600.0 / (1.0 / (m * m) + 1.0)))
        }
        else if (x < 0 && y > 0) {
            projectile.position = CGPoint(x: enemyNode.position.x - sqrt(1600.0 / (1.0 + m * m)), y: enemyNode.position.y + sqrt(1600.0 / (1.0 / (m * m) + 1.0)))
        }
        else if (x < 0 && y < 0) {
            projectile.position = CGPoint(x: enemyNode.position.x - sqrt(1600.0 / (1.0 + m * m)), y: enemyNode.position.y - sqrt(1600.0 / (1.0 / (m * m) + 1.0)))
        }
        
        //Set projectile's physics
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width / 2)
        projectile.physicsBody!.contactTestBitMask = projectile.physicsBody!.collisionBitMask //Detect all collisions
        projectile.physicsBody!.affectedByGravity = false
        projectile.physicsBody!.restitution = 1
        projectile.physicsBody!.friction = 0
        projectile.physicsBody!.linearDamping = 0
        projectile.physicsBody!.angularDamping = 0
        
        addChild(projectile)
        
        //Shoot projectile, speed depends on distance between enemy and player
        projectile.physicsBody!.applyForce(CGVector(dx: x, dy: y))
    }
    
    
    //Run player animations
    func playerWalking() {
        playerNode.run(SKAction.repeatForever(SKAction.animate(with: playerMovementFrames, timePerFrame: 0.1, resize: false, restore: true)), withKey: "walkingInPlacePlayer")
    }
    
    //Run enemy animations
    func enemyWalking() {
        enemyNode.run(SKAction.repeatForever(SKAction.animate(with: enemyMovementFrames, timePerFrame: 0.5, resize: false, restore: true)))
    }
    
    //End all movements of player and enemy
    func endMovement() {
        playerNode.removeAllActions()
        enemyNode.removeAllActions()
    }
    
    //Create random X coordinate
    func randomX () -> CGFloat {
        let frameWidth = 667.0
        let pointX = [frameWidth * 0.70, frameWidth * 0.90]
        let randomWidth = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: pointX)
        let x = CGFloat(randomWidth[0] as? Double ?? 0)
        return x
    }
    
    //Create random Y coordinate
    func randomY () -> CGFloat {
        let frameHeight = 375.0
        let pointY = [frameHeight * 0.10, frameHeight * 0.50, frameHeight * 0.90]
        let randomHeight = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: pointY)
        let y = CGFloat(randomHeight[0] as? Double ?? 0)
        return y
    }
    
    //Collision function called automatically
    func didBegin(_ contact: SKPhysicsContact) {
        
        //Projectile collides projectile
        if contact.bodyA.node?.name == "projectile" && contact.bodyB.node?.name == "projectile" {
            
            destroy(collide: contact)
        }
        //Projectile collides player
        else if (contact.bodyA.node?.name == "projectile" && contact.bodyB.node?.name == "player") || (contact.bodyA.node?.name == "player" && contact.bodyB.node?.name == "projectile") {
            
            destroy(collide: contact)
            //Create game over label
            let label = SKLabelNode(text: "Game Over")
            label.position = CGPoint(x: frame.midX, y: frame.midY)
            addChild(label)
        }
        //Projectile collides enemy
        else if (contact.bodyA.node?.name == "projectile" && contact.bodyB.node?.name == "enemy") || (contact.bodyA.node?.name == "enemy" && contact.bodyB.node?.name == "projectile") {
            
            destroy(collide: contact)
            //Create game over label
            let label = SKLabelNode(text: "You Win")
            label.position = CGPoint(x: frame.midX, y: frame.midY)
            addChild(label)
        }
    }
    
    func destroy (collide: SKPhysicsContact) {
        //Remove both objects from scene
        collide.bodyA.node!.removeFromParent()
        collide.bodyB.node!.removeFromParent()
        
        //Create explosion animation
        if let explosion = SKEmitterNode(fileNamed: "Explosion") {
            explosion.position = collide.contactPoint
            addChild(explosion)
        }
    }
    
    //Create projectile when detect touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first { //Detect touches
            
            let location = touch.location(in: self) //Determine touch location on scene
            
            //Create projectile
            let projectile = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), color: UIColor.red, size: CGSize(width: 10, height: 10))
            projectile.name = "projectile"
            
            //Determine slope from player to touches for projectile's positioning
            let x = (location.x - playerNode.position.x) * 0.02
            let y = (location.y - playerNode.position.y) * 0.02
            let m = y / x
            
            //Set projectile's position based on quadrant
            if (x > 0 && y > 0) {
                projectile.position = CGPoint(x: playerNode.position.x + sqrt(1600.0 / (1.0 + m * m)), y: playerNode.position.y + sqrt(1600.0 / (1.0 / (m * m) + 1.0)))
            }
            else if (x > 0 && y < 0) {
                projectile.position = CGPoint(x: playerNode.position.x + sqrt(1600.0 / (1.0 + m * m)), y: playerNode.position.y - sqrt(1600.0 / (1.0 / (m * m) + 1.0)))
            }
            else if (x < 0 && y > 0) {
                projectile.position = CGPoint(x: playerNode.position.x - sqrt(1600.0 / (1.0 + m * m)), y: playerNode.position.y + sqrt(1600.0 / (1.0 / (m * m) + 1.0)))
            }
            else if (x < 0 && y < 0) {
                projectile.position = CGPoint(x: playerNode.position.x - sqrt(1600.0 / (1.0 + m * m)), y: playerNode.position.y - sqrt(1600.0 / (1.0 / (m * m) + 1.0)))
            }
            
            //Set projectile's physics
            projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width / 2)
            projectile.physicsBody!.contactTestBitMask = projectile.physicsBody!.collisionBitMask //Detect all collisions
            projectile.physicsBody!.affectedByGravity = false
            projectile.physicsBody!.restitution = 1
            projectile.physicsBody!.friction = 0
            projectile.physicsBody!.linearDamping = 0
            projectile.physicsBody!.angularDamping = 0
            
            addChild(projectile)
            
            //Shoot projectile, speed depends on distance between player and touches
            projectile.physicsBody!.applyForce(CGVector(dx: x, dy: y))
        }
    }
}
    
        

