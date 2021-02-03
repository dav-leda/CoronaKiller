//
//  GameScene.swift
//  CoronaKiller
//
//  Created by Dav Leda on 9/6/20.
//  Copyright © 2020 Dav Leda. All rights reserved.
//


import SpriteKit
import GameplayKit

var puntaje = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
 
    var globulos:SKEmitterNode!
    var explosion:SKEmitterNode!
    let cartelPuntos = SKLabelNode(fontNamed: "ARCADE")
    var puntajeVirus = 0
    let cartelVirus = SKLabelNode(fontNamed: "ARCADE")
    let sonidoDisparo = SKAction.playSoundFileNamed("disparo.mp3", waitForCompletion: false)
    let sonidoExplosion = SKAction.playSoundFileNamed("plop.mp3", waitForCompletion: false)
    let sonidoVirus = SKAction.playSoundFileNamed("golf.mp3", waitForCompletion: false)
    let sonidoGameOver = SKAction.playSoundFileNamed("gameover.mp3", waitForCompletion: false)
    
    enum gameState {
        case preGame
        case inGame
        case afterGame
    }
    
    var currentGameState = gameState.inGame
    
    
    struct physicsCategories {
        static let None:UInt32 = 0
        static let Player:UInt32 = 1
        static let Bullet:UInt32 = 2
        static let Enemy:UInt32 = 4
    }
    
    let player = SKSpriteNode(imageNamed: "imagenAyudin")
    
    func random() -> CGFloat {
        
        let posicionRandomVirus = GKRandomDistribution(lowestValue: 0, highestValue: 750)
        let position = CGFloat(posicionRandomVirus.nextInt())
        return position
        
    }
    
    
    func randomsize() -> CGFloat {
        
        let sizeRandomVirus = GKRandomDistribution(lowestValue: 1, highestValue: 2)
        let sizeVirus = CGFloat(sizeRandomVirus.nextInt())*0.1
        return sizeVirus
        
    }
    
        
    override func didMove(to view: SKView) {
        
        puntaje = 0
        
        self.physicsWorld.contactDelegate = self
        
        self.backgroundColor = UIColor.black
        
        globulos = SKEmitterNode(fileNamed: "Globulos")
        globulos.advanceSimulationTime(3)
        globulos.position = CGPoint(x: self.size.width*0.5, y: self.size.height)
        self.addChild(globulos)
        
        player.setScale(0.5)
        player.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.21)
        player.zPosition = 3
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = physicsCategories.Player
        player.physicsBody!.collisionBitMask = physicsCategories.None
        self.addChild(player)
        
        cartelPuntos.text = "CoronaKiller: 0"
        cartelPuntos.fontSize = 50
        cartelPuntos.fontColor = SKColor.systemYellow
        cartelPuntos.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        cartelPuntos.position = CGPoint(x: self.size.width*0.08, y: self.size.height*0.06)
        cartelPuntos.zPosition = 10
        self.addChild(cartelPuntos)
        
        cartelVirus.text = "CoronaVirus: 0"
        cartelVirus.fontSize = 50
        cartelVirus.fontColor = SKColor.systemGreen
        cartelVirus.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        cartelVirus.position = CGPoint(x: self.size.width*0.08, y: self.size.height*0.03)
        cartelVirus.zPosition = 10
        self.addChild(cartelVirus)
       
        startNewLevel()
        
    }
    
    
    func puntoVirus() {
        
        puntajeVirus += 1
        cartelVirus.text = "CoronaVirus: \(puntajeVirus)"
        self.run(sonidoVirus)
        
        if puntajeVirus == 20 {
            runGameOver()
        }
        
    }
    
    
    
    func addScore() {
        
        puntaje += 1
        cartelPuntos.text = "CoronaKiller: \(puntaje)"
        
    }
    
    
    func runGameOver() {
        
        currentGameState = gameState.afterGame
        
        self.removeAllActions()
        
        self.enumerateChildNodes(withName: "Bullet") {
            bullet, stop in
     
            bullet.removeAllActions()
        }
        
        self.enumerateChildNodes(withName: "Enemy") {
            enemy, stop in
     
            enemy.removeAllActions()
        }
        
        self.run(sonidoGameOver)
        
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 0.2)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeSceneSequence)
        
    }
    
    
    func changeScene() {
        
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.2)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var contactoUno:SKPhysicsBody
        var contactoDos:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            contactoUno = contact.bodyA
            contactoDos = contact.bodyB
        }
        else{
            contactoUno = contact.bodyB
            contactoDos = contact.bodyA
        }
        
        if contactoUno.categoryBitMask == physicsCategories.Player && contactoDos.categoryBitMask == physicsCategories.Enemy {
            
            if contactoDos.node != nil {
                explotaVirus(posicionVirus: contactoDos.node!.position)
            }
            
            contactoDos.node?.removeFromParent()
            
            //borra al virus cuando toca la lavandina
            
        }
        
        if contactoUno.categoryBitMask == physicsCategories.Bullet && contactoDos.categoryBitMask == physicsCategories.Enemy {
            
            addScore()
            
            if contactoDos.node != nil {
            explotaVirus(posicionVirus: contactoDos.node!.position)
            // chequea que al abrir el opcional "node" haya algo adentro, sino crashea
            }
            
            contactoUno.node?.removeFromParent()
            contactoDos.node?.removeFromParent()
        }
    }
    
    
    func explotaVirus(posicionVirus: CGPoint) {
        
        explosion = SKEmitterNode(fileNamed: "Explosion")
        explosion.position = posicionVirus
        explosion.zPosition = 4
        self.addChild(explosion)
        
        let wait = SKAction.wait(forDuration: 2.0)
        let deleteExplosion = SKAction.removeFromParent()
        let explosionSequence = SKAction.sequence([sonidoExplosion, wait, deleteExplosion])
        explosion.run(explosionSequence)
       
    }
    
    
    func startNewLevel() {
        
        let generar = SKAction.run(generarEnemy)
        let waitTogenerar = SKAction.wait(forDuration: 1.0)
        let generarSequence = SKAction.sequence([waitTogenerar, generar])
        let generarForever = SKAction.repeatForever(generarSequence)
        self.run(generarForever)
        
    }
    
    
    
    func fireBullet() {
        
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.name = "Bullet"
        bullet.setScale(1.0)
        let posicion = CGPoint(x: player.position.x, y: player.position.y+60)
        bullet.position = posicion
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: 5.0)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = physicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = physicsCategories.None
        bullet.physicsBody!.contactTestBitMask = physicsCategories.Enemy
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 0.5)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([sonidoDisparo, moveBullet, deleteBullet])
        bullet.run(bulletSequence)
       
    }
    
    
    func generarEnemy() {
        
        let randomXStart = random()
        let randomXEnd = random()
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.02)
        
        let enemy = SKSpriteNode(imageNamed: "imagenVirus")
        enemy.name = "Enemy"
        enemy.setScale(randomsize())
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 30.0)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = physicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = physicsCategories.None
        enemy.physicsBody!.contactTestBitMask = physicsCategories.Bullet
        self.addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 3.0)
        let deleteEnemy = SKAction.removeFromParent()
        let puntoVirusAction = SKAction.run(puntoVirus)
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy, puntoVirusAction])
        
        enemy.run(enemySequence)
         
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy, dx)
        enemy.zRotation = amountToRotate
       
    }
    
    
    
   
    
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
   
    for touch in touches {
    let location = touch.location(in: self)
    player.run(SKAction.moveTo(x: location.x, duration: 0.01))
          
      }
  }
  
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
          
        if currentGameState == gameState.inGame {
        
        fireBullet()
        }
    }
    
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
          for touch in touches {
              let location = touch.location(in: self)
              
              player.run(SKAction.moveTo(x: location.x, duration: 0.01))
              
              
          }
  }
   
}

