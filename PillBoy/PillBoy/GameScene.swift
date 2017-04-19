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
    
    var playerNode: SKSpriteNode?
    let joystickStickColorBtn = SKLabelNode(text: "Sticks Random Color"), joystickSubstrateColorBtn = SKLabelNode(text: "Substrates Random Color")
    
    let moveAnalogStick = AnalogJoystick(diameter: 110)
    
    override func didMove(to view: SKView) {
        //Scene setup
        backgroundColor = UIColor.white
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
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
        
        let selfHeight = frame.height
        let btnsOffset: CGFloat = 10
        let joystickSizeLabel = SKLabelNode(text: "Joysticks Size:")
        joystickSizeLabel.fontSize = 20
        joystickSizeLabel.fontColor = UIColor.black
        joystickSizeLabel.horizontalAlignmentMode = .left
        joystickSizeLabel.verticalAlignmentMode = .top
        joystickSizeLabel.position = CGPoint(x: btnsOffset, y: selfHeight - btnsOffset)
        addChild(joystickSizeLabel)
        
        joystickStickColorBtn.fontColor = UIColor.black
        joystickStickColorBtn.fontSize = 20
        joystickStickColorBtn.verticalAlignmentMode = .top
        joystickStickColorBtn.horizontalAlignmentMode = .left
        joystickStickColorBtn.position = CGPoint(x: btnsOffset, y: selfHeight - 40)
        addChild(joystickStickColorBtn)
        
        joystickSubstrateColorBtn.fontColor = UIColor.black
        joystickSubstrateColorBtn.fontSize = 20
        joystickSubstrateColorBtn.verticalAlignmentMode = .top
        joystickSubstrateColorBtn.horizontalAlignmentMode = .left
        joystickSubstrateColorBtn.position = CGPoint(x: btnsOffset, y: selfHeight - 65)
        addChild(joystickSubstrateColorBtn)
        
        view.isMultipleTouchEnabled = true
    }
    
    func addPlayer(_ position: CGPoint) {
        
        guard let playerImage = UIImage(named: "apple") else { return }
        
        let texture = SKTexture(image: playerImage)
        let player = SKSpriteNode(texture: texture)
        player.physicsBody = SKPhysicsBody(texture: texture, size: player.size)
        player.physicsBody!.affectedByGravity = false
        
        insertChild(player, at: 0)
        player.position = position
        playerNode = player
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       //Called when a touch begins
        
        if let touch = touches.first {
            
            let node = atPoint(touch.location(in: self))
            
            switch node {
                
            case joystickStickColorBtn:
                setRandomStickColor()
            case joystickSubstrateColorBtn:
                setRandomSubstrateColor()
            default:
                addPlayer(touch.location(in: self))
            }
        }
    }
    
    func setRandomStickColor() {
        
        let randomColor = UIColor.random()
        moveAnalogStick.stick.color = randomColor
    }
    
    func setRandomSubstrateColor() {
        
        let randomColor = UIColor.random()
        moveAnalogStick.substrate.color = randomColor
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}

extension UIColor {
    
    static func random() -> UIColor {
        
        return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
    }
}
