//
//  MainMenuScene.swift
//  CoronaKiller
//
//  Created by dav on 9/6/20.
//  Copyright © 2020 David Leda. All rights reserved.
//

import GameplayKit
import SpriteKit
import AVFoundation

class MainMenuScene: SKScene {
    
    var player = AVAudioPlayer()
    
    
    override func didMove(to view: SKView) {
   
    let path = Bundle.main.path(forResource:"musica-fondo", ofType: "mp3")

    do{
        try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
    } catch {
        print("File is not Loaded")
    }
    let session = AVAudioSession.sharedInstance()
    do{
        try session.setCategory(AVAudioSession.Category.playback)
    }
    catch{
    }

    player.numberOfLoops = -1
    player.volume = 0.4
    player.play()
    
    }
    
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    let transition = SKTransition.fade(withDuration: 0.1)
    let gameScene = GameScene(size: self.size)
    self.view?.presentScene(gameScene, transition: transition)
        
    }
        
    }
    


