//
//  GameScene.swift
//  WhackAMole
//
//  Created by Valentina Carfagno on 6/9/19.
//  Copyright © 2019 Valentina Carfagno. All rights reserved.
//

import SpriteKit
import Foundation
import os.log
class GameScene: SKScene   {
    
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var statusLabel : SKLabelNode?
    var timerLabel : SKLabelNode?
     var slots = [WhackSlot]()
    var popupTime = 0.85
    var numRounds = 0
    
    var isAlive = true
    var score2 = 0
    
    var countDownTimeVar = 0

    
    
    var gameScore: SKLabelNode!
    
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
    
        resetGamevariables()
        spawnStatusLabel()
        spawnTimerLabel()
        countDownTimer()
        
        
        let background = SKSpriteNode(imageNamed: "whackabackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        
        
        gameScore = SKLabelNode(fontNamed: "ChalkDuster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 50)
        gameScore.horizontalAlignmentMode = .left
        
        gameScore.fontSize = 48
        addChild(gameScore)
        
        for i in 0..<1 {
            createSlot(at: CGPoint(x: 140 + (i * 200), y: 200))}
        for i in 0..<1 {
            createSlot(at: CGPoint(x: 140 + (i * 200), y: 600))}
        
        for i in 0..<1 {
            createSlot(at: CGPoint(x: 750 + (i * 200), y: 200))}
        
        for i in 0..<1 {
            createSlot(at: CGPoint(x: 750 + (i * 200), y: 600))}
        
        DispatchQueue.main.asyncAfter(deadline: .now()  + 1) { [weak self] in
            self?.createEnemy()
        
            
            
            
            
            
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            
            guard let whackSlot = node.parent?.parent as? WhackSlot else {
                continue
                
               
            }
            if !whackSlot.isVisible { continue }
            if whackSlot.isHit { continue }
            whackSlot.hit()
            
            if node.name == "charFriend" {
                //they shouldnt have whacked this mole!!!
             
                whackSlot.charNode.xScale = -0.85
                whackSlot.charNode.yScale = -0.85
                score -= 5
                
             //run(SKAction.playSoundFileNamed(<#T##soundFile: String##String#>, waitForCompletion: false)) usethis for adding sound to the game for later
                
                
            } else if node.name == "charEnemy" {
                //they should have whacked this mole!
                
            
                
                whackSlot.charNode.xScale = -0.85
                whackSlot.charNode.yScale = -0.85
                
              
                score += 1
                // use this action for adding sound for enemy hit   run(SKAction.playSoundFileNamed(<#T##soundFile: String##String#>, waitForCompletion: false))
                
            }
        }
        
  
        
        }
    func createSlot(at position: CGPoint)
    {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
        
    }
    func createEnemy() {
        
        numRounds += 1
        
        if numRounds >= 30 {
            for slot in slots {
                slot.hide()
            }
           
           
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 284)
            
            gameOver.zPosition = 1
            addChild(gameOver)
            resetTheGame()
            waitThenMoveToTitleScreen()
            return
        }
        
        
        
        popupTime *= 0.891
        
        
        slots.shuffle()
        slots[0].show(hideTime: popupTime)
        
        
        if Int.random(in: 0...4) > 1 {slots[0].show(hideTime: popupTime)
         // //  else popupTime == popupTime/2 {
              //    WhackSlot.charNode.xScale = -0.85
           // WhackSlot.charNode.yScale = -0.85            }
        }
          if Int.random(in: 0...4) > 2 {slots[1].show(hideTime: popupTime)}
          if Int.random(in: 0...4) > 3 {slots[2].show(hideTime: popupTime)}
          if Int.random(in: 0...4) > 4 {slots[3].show(hideTime: popupTime)}
        
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.createEnemy()
            
        }   }
    
    
    
    func countDownTimer() {
        let wait = SKAction.wait(forDuration: 1.0)
        let runCountDown = SKAction.run {
            if self.isAlive ==  true {
                self.countDownTimeVar = self.countDownTimeVar - 1
            }
            if self.countDownTimeVar <= COUNTDOWN && self.isAlive == true {
                self.timerLabel?.text = "\(self.countDownTimeVar)"
            }
            if self.countDownTimeVar <= 0 {
                self.timerLabel?.text = "0"
                self.gameOverLogic()
                
            }
        }
        let sequence = SKAction.sequence([wait, runCountDown])
        self.run(SKAction.repeat(sequence, count: countDownTimeVar))
    }
    
    func spawnExplosion(playerTemp: SKSpriteNode) {
        
        let explosion = newExplosion()!
        explosion.zPosition = 1
        explosion.targetNode = self
        explosion.position = CGPoint(x: playerTemp.position.x, y:
            playerTemp.position.y)
        self.addChild(explosion)
        let explosionTimerRemove = SKAction.wait(forDuration: 1.0)
        
        let removeExplosion = SKAction.run {
            
            explosion.removeFromParent()
        }
        self.run(SKAction.sequence([explosionTimerRemove, removeExplosion]))
    }
    func newExplosion() -> SKEmitterNode? {
        return SKEmitterNode(fileNamed: "MyParticle.sks")
    }
    
    
    
    func gameOverLogic() {
        
        statusLabel?.fontColor = notWhiteColor
        statusLabel?.text = "Good Score"
        timerLabel?.text = "Try Again"
         spawnExplosion(playerTemp: SKSpriteNode(imageNamed: "gameOver"))
        if isAlive == false {
            statusLabel?.text = "Game Reset"
            COUNTDOWN = 30
            if score2 == 0 {
                statusLabel?.fontColor = UIColor.red
                statusLabel?.text = "Skunked!"
                timerLabel?.text = "Game Over"
                self.waitThenMoveToTitleScreen()
            }
        }

        
        // for now, there is only one high and you can just replace the score
        
        
        if score2 > highScore {
            highScore = score2
            statusLabel?.fontColor = UIColor.yellow
            statusLabel?.text = " High score! \(highScore)"
            saveScores()
        }
        else if isAlive == true {
            statusLabel?.text = "Awesome!"
        }
        
        // good scores increase the time ( better than half the countdown)
        
        if(isAlive == true && score > COUNTDOWN/2) {
            COUNTDOWN = COUNTDOWN + 5
            timerLabel?.text = "Timer Increased!"
            spawnBonusFireWorks()
        }
        else{
            self.resetTheGame()
        }
    }
    
    @objc func resetTheGame() {
        highScore = 0
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(scores, toFile: SavedGame.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("High score successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save high score...", log: OSLog.default, type: .error)
        }
    }
    func spawnStatusLabel() {
        
        
        statusLabel = SKLabelNode(fontNamed: "Marker Felt")
        statusLabel?.fontColor = notWhiteColor
        statusLabel?.fontSize = 100
        statusLabel?.position = CGPoint(x: self.frame.midX, y: self.frame.maxY + 255.0)
        
        statusLabel?.text = "Start!"
        self.addChild(statusLabel!)
       
    }
    
    
    func spawnTimerLabel() {
        
         self.statusLabel?.removeFromParent()
        timerLabel = SKLabelNode(fontNamed: "Marker Felt")
        timerLabel?.fontColor = notWhiteColor
        timerLabel?.fontSize = 70
        timerLabel?.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 275.0)
        
        timerLabel?.text = "\(COUNTDOWN)"
        self.addChild(timerLabel!)
        
        
    }
    func spawnBonusFireWorks() {
        
        var explosion : SKEmitterNode?
        
        explosion = SKEmitterNode(fileNamed:  "MyParticle.sks")!
        
        explosion?.position = CGPoint(x:  self.frame.midX, y: self.frame.midY)
        explosion?.zPosition = -1
        explosion?.targetNode = self
        
        self.addChild(explosion!)
        
        let explosionTimerRemove = SKAction.wait(forDuration: 1.0)
        let removeExplosion = SKAction.run {
            explosion?.removeFromParent()
            self.resetTheGame()
        }
        self.run(SKAction.sequence([explosionTimerRemove, removeExplosion]))
    }
    
    @objc func waitThenMoveToTitleScreen() {
        
        let wait = SKAction.wait(forDuration: 1.0)
        let tranisition = SKAction.run {
   
            
            self.view?.presentScene(TitleScene(), transition:
                SKTransition.crossFade(withDuration: 1.5))
        }
        let sequence = SKAction.sequence([wait, tranisition])
        self.run(SKAction.repeat(sequence, count: 1))
        }
    
    
    func resetGamevariables() {
        scores = []
        isAlive = true
        
        countDownTimeVar = COUNTDOWN
    }

    func addToScore(){
        let timeInterval = SKAction.wait(forDuration: 1.0)
        let addAndUpdateScore = SKAction.run{
            if self.isAlive == true {
                self.score = self.score + 1
                self.saveScores()
                // raise the floor/player every second too.
           
                
            }
        }
        let sequence = SKAction.sequence([timeInterval, addAndUpdateScore])
        self.run(SKAction.repeatForever(sequence))
    }
    private func saveScores() {
        scores[0].score2 = highScore
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(scores, toFile: SavedGame.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("High Score succesfully saved." , log: OSLog.default, type: .debug)
        }
        else {
            os_log("Failed to save high score", log: OSLog.default, type: .error)
        }
    }
}
