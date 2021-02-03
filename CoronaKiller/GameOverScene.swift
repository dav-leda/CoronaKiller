//
//  GameOverScene.swift
//  CoronaKiller
//
//  Created by dav on 9/6/20.
//  Copyright © 2020 David Leda. All rights reserved.
//


import GameplayKit
import SpriteKit

class GameOverScene: SKScene {
    
    
    let startButton = SKSpriteNode(imageNamed: "startbutton")
    
        
    override func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor.black
        
        let gameOver = SKLabelNode(fontNamed: "ARCADE")
        gameOver.text = "GAME OVER"
        gameOver.fontSize = 120
        gameOver.fontColor = SKColor.systemYellow
        gameOver.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.75)
        gameOver.zPosition = 1
        self.addChild(gameOver)
        
        let cartelPuntos = SKLabelNode(fontNamed: "ARCADE")
        cartelPuntos.text = "Puntaje: \(puntaje)"
        cartelPuntos.fontSize = 60
        cartelPuntos.fontColor = SKColor.systemYellow
        cartelPuntos.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        cartelPuntos.zPosition = 1
        self.addChild(cartelPuntos)
       
       
        startButton.size = CGSize(width: 400, height: 80)
        startButton.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.25)
        startButton.zPosition = 2
        startButton.physicsBody = SKPhysicsBody(rectangleOf: startButton.size)
        startButton.physicsBody!.affectedByGravity = false
        self.addChild(startButton)
           
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
           let transition = SKTransition.fade(withDuration: 0.1)
           let gameScene = GameScene(size: self.size)
           self.view?.presentScene(gameScene, transition: transition)
                       
                      }
                      
                  }
        
    
    


