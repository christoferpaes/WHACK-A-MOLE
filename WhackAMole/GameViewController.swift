//
//  GameViewController.swift
//  WhackAMole
//
//  Created by Christofer Patrick Paes on 6/9/19.
//  Copyright © 2019 Christofer Patrick Paes. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

var sizeOfView : CGSize!
var notWhiteColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
var notBlackColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)


class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sizeOfView = view.frame.size
        gameAchievements()
        
        if let view = self.view as! SKView? {
        if let scene = TitleScene(fileNamed: "TitleScene") {
            
            // Get the SKScene from the loaded GKScene
          
                
           
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
            
           
            
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(scene)
            }
                    view.ignoresSiblingOrder = true
                    
        
                }
     
        
        
        
        }
        
    }
    
    

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //Mark: Private Functions
    
    private func gameAchievements() {
        //Load any saved score, otherwise load sample score.
        
        if let savedScores = loadScores() {
            scores += savedScores
        }
        else{
            //load the sample data.
            loadSampleScores()
        }
    }
    
    private func loadSampleScores() {
        guard let saved1 = SavedGame(name: "Whack A Mole", score: 0)else{
            fatalError("Unable to instatiate saved")
        }
        scores += [saved1]
    }
    private func loadScores() -> [SavedGame]?
    {
        return NSKeyedUnarchiver.unarchiveObject(withFile: SavedGame.ArchiveURL.path) as? [SavedGame]
    }
}
