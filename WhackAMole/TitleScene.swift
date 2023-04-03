//
//  TitleScene.swift
//  WhackAMole
//
//  Created by Valentina Carfagno on 6/9/19.
//  Copyright © 2019 Valentina Carfagno. All rights reserved.
//

import Foundation
import SpriteKit
import os.log


var highScore : Int = 0
var scores = [SavedGame]()
var COUNTDOWN = 30


class TitleScene : SKScene {
    
    var btnPlay : UIButton!
    var btnReset : UIButton!
    var achievementTitle : UILabel!
    
    var statusLabel = SKLabelNode()
    var gameTitle = SKLabelNode()
    var gameFAQS = SKLabelNode()
    var gameFAQ1 = SKLabelNode()
    
    
    override func didMove(to view: SKView) {
        self.backgroundColor = notBlackColor
        setUpText()
        
    }
    @objc func playTheGame() {
        
        self.view?.presentScene(GameScene(), transition:
            SKTransition.fade(withDuration: 0.05))
        btnPlay.removeFromSuperview()
        
    
        achievementTitle.removeFromSuperview()
     statusLabel.removeFromParent()
    
        gameFAQ1.removeFromParent()
        gameFAQS.removeFromParent()
        
        if let scene = GameScene(fileNamed: "GameScene") {
            let skView = self.view! as SKView
            skView.ignoresSiblingOrder = true
            
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
             btnReset.removeFromSuperview()
        }
    }
    @objc func resetTheGame() {
        
        achievementTitle.text = " "
        scores[0].score2 = highScore
        highScore = 0
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(scores, toFile: SavedGame.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("High Score successfully saved", log: OSLog.default, type: .debug)
        }else{
            os_log("Failed to save high score...", log: OSLog.default, type: .error)
        }
    }
    func setUpText() {
        //Be sure to scale the fonts to lable positions to fit the device view
        sizeOfView = view!.frame.size
        let ScaleYPosition = sizeOfView.height
        let btnSize : CGFloat = view!.frame.size.width/3.8
        
        
  
        
        
        gameFAQS = SKLabelNode(fontNamed: "ChalkDuster")
        gameFAQS.fontColor = notWhiteColor
        gameFAQS.fontSize = ScaleYPosition/72
        gameFAQS.position = CGPoint(x: self.frame.midX, y: self.frame.midY + ScaleYPosition/2.1)
        gameFAQS.text = "--Hit red enemy mole to gain 1 point and if you hit the friend mole - 5 points --"
        
        self.addChild(gameFAQS)
        
        
        
        gameFAQ1 = SKLabelNode(fontNamed: "ChalkDuster")
        gameFAQ1.fontColor = notWhiteColor
        gameFAQ1.fontSize = ScaleYPosition/24
        gameFAQ1.position = CGPoint(x: self.frame.midX, y: self.frame.midY + ScaleYPosition/5.4)
        gameFAQ1.text = "--  Have Fun  --"
        
        self.addChild(gameFAQ1)
    
        //PLAY BUTTON with image
        btnPlay = UIButton(frame: CGRect(x: 0, y: 0, width: btnSize, height: btnSize))
        btnPlay.backgroundColor = notBlackColor
        
        //left of Center
        btnPlay.center = CGPoint(x: sizeOfView.width/2, y: (sizeOfView.height/2))
        btnPlay.setImage(UIImage(named: "playWhackAMole"), for: UIControl.State.normal)
        btnPlay.addTarget(self, action: (#selector(TitleScene.playTheGame)), for: UIControl.Event.touchUpInside)
        self.view?.addSubview(btnPlay)
        
        
        //HIGH SCORE
        
        achievementTitle = UILabel(frame: CGRect(x: self.frame.midX + 0, y: (ScaleYPosition/1.18), width: sizeOfView.width - btnSize, height: 100))
        
        achievementTitle.textColor = notWhiteColor
        achievementTitle.font = UIFont(name: "ChalkDuster", size: ScaleYPosition/20)
        
        achievementTitle.textAlignment = NSTextAlignment.center
        
        if highScore != 0 {
            achievementTitle.text = "High Score : \(highScore)"
        }
        else if highScore == 0 {
             achievementTitle.text = "High Score : \(highScore)"
            
        }
        
        self.view?.addSubview(achievementTitle)
        
        //RESET THE HIGH SCORE
        
        btnReset = UIButton(frame: CGRect(x: 300, y: 0, width: btnSize/1.5, height: btnSize/1.5))
        
        btnReset.backgroundColor = notBlackColor
        btnReset.center = CGPoint(x: achievementTitle.frame.maxX, y: achievementTitle.frame.midY)
        btnReset.setImage(UIImage(named: "resetWhackAMoleButton"), for: UIControl.State.normal)
        
        btnReset.addTarget(self, action: (#selector(TitleScene.resetTheGame)), for: UIControl.Event.touchUpInside)
        self.view?.addSubview(btnReset)
       
}
    
}
