//
//  GameScene.swift
//  PillBoy
//
//  Created by student on 4/7/17.
//  Copyright © 2017 CMPE137. All rights reserved.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene {
    
    var playerNode : SKSpriteNode!
    var playerMovementFrames : [SKTexture]!
    
    let moveAnalogStick = AnalogJoystick(diameter: 110, colors: (UIColor.black, UIColor.gray))
    
    
    override func didMove(to view: SKView) {
        //Scene setup
        backgroundColor = UIColor.white
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        //Define animations
        let playerAtlas = SKTextureAtlas(named: "texture")
        
        //Walk Down
        let pd0 = playerAtlas.textureNamed("spr_p1_down_0.png")
        let pd1 = playerAtlas.textureNamed("spr_p1_down_1.png")
        let pd2 = playerAtlas.textureNamed("spr_p1_down_2.png")
        let pd3 = playerAtlas.textureNamed("spr_p1_down_3.png")
        
        //Hurt
        let ph0 = playerAtlas.textureNamed("spr_p1_hurt_0.png")
        
        //Walk Left
        let pl0 = playerAtlas.textureNamed("spr_p1_left_0.png")
        let pl1 = playerAtlas.textureNamed("spr_p1_left_1.png")
        let pl2 = playerAtlas.textureNamed("spr_p1_left_2.png")
        let pl3 = playerAtlas.textureNamed("spr_p1_left_3.png")
        
        //Walk Right
        let pr0 = playerAtlas.textureNamed("spr_p1_right_0.png")
        let pr1 = playerAtlas.textureNamed("spr_p1_right_1.png")
        let pr2 = playerAtlas.textureNamed("spr_p1_right_2.png")
        let pr3 = playerAtlas.textureNamed("spr_p1_right_3.png")
        
        //Walk Up
        let pu0 = playerAtlas.textureNamed("spr_p1_up_0.png")
        let pu1 = playerAtlas.textureNamed("spr_p1_up_1.png")
        let pu2 = playerAtlas.textureNamed("spr_p1_up_2.png")
        let pu3 = playerAtlas.textureNamed("spr_p1_up_3.png")
        
        let walkDownFrames = [pd0, pd1, pd2, pd3]
        let walkLeftFrames = [pl0, pl1, pl2, pl3]
        let walkRightFrames = [pr0, pr1, pr2, pr3]
        let walkUpFrames = [pu0, pu1, pu2, pu3]
        let hurtFrames = [ph0]
        
        playerMovementFrames = walkDownFrames
        
        
        //initialize player pill
        let firstFrame = playerMovementFrames[0]
        playerNode = SKSpriteNode(texture: firstFrame)
        playerNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        addChild(playerNode)
        
        
        moveAnalogStick.position = CGPoint(x: moveAnalogStick.radius + 15, y: moveAnalogStick.radius + 15)
        addChild(moveAnalogStick)
        
        
        //Handlers begin
        
        moveAnalogStick.startHandler = { [unowned self] in
            
            guard let aN = self.playerNode else { return }
            aN.run(SKAction.sequence([SKAction.scale(to: 0.5, duration: 0.5), SKAction.scale(to: 1, duration: 0.5)]))
        }
        
        moveAnalogStick.trackingHandler = { [unowned self] data in
            
            guard let aN = self.playerNode else { return }
            aN.position = CGPoint(x: aN.position.x + (data.velocity.x * 0.12), y: aN.position.y + (data.velocity.y * 0.12))
        }
        
        moveAnalogStick.stopHandler = { [unowned self] in
            
            guard let aN = self.playerNode else { return }
            aN.run(SKAction.sequence([SKAction.scale(to: 1.5, duration: 0.5), SKAction.scale(to: 1, duration: 0.5)]))
        }
        
        //Handlers end
        
        
        
        view.isMultipleTouchEnabled = true
        playerWalking()
    }
    
    func playerWalking() {
        playerNode.run(SKAction.repeatForever(SKAction.animate(with: playerMovementFrames, timePerFrame: 0.1, resize: false, restore: true)), withKey: "walkingInPlacePlayer")
    }
    
    func playerMoveEnd(){
        playerNode.removeAllActions()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       //Called when a touch begins
        
    }
}


extension UIColor {
    
    static func random() -> UIColor {
        
        return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
    }
}
