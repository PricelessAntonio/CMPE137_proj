//
//  GameViewController.swift
//  PillBoy
//
//  Created by Khoa Bui on 5/10/17.
//  Copyright © 2017 Khoa Bui. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create game scene object
        let scene = GameScene(size: view.bounds.size)
        
        //Run view as SKView to present the scene
        if let skView = view as? SKView {
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.ignoresSiblingOrder = true
            skView.presentScene(scene)
        }
    }
}
