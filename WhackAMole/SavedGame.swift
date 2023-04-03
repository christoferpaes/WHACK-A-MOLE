//
//  SavedGame.swift
//  WhackAMole
//
//  Created by Valentina Carfagno on 6/9/19.
//  Copyright © 2019 Valentina Carfagno. All rights reserved.
//
import Foundation
import UIKit
import os.log


class SavedGame: NSObject, NSCoding {
    
    //Mark Properties
    var name: String
    var score2: Int
    
    
    
    
    
    //Mark Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("savedGame")
    
    
    //Mark Types
    
    struct PropertyKey {
        
        static let name = "name"
        static let score = "score"
    }
    //Mark Initialization
    
    
    init?(name: String, score:Int) {
        
        //The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        
        //Initialize store properties
        
        self.name = name
        self.score2 = score
        
    }
    
    //Mark: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(score2, forKey: PropertyKey.score)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail
        
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String
            else{
                os_log("Unable to decode the name for a saved score." , log: OSLog.default, type: .debug)
                return nil
        }
        let score = aDecoder.decodeInteger(forKey: PropertyKey.score)
        
        //Must call designated initializer
        
        self.init(name: name, score: score)
    }
    
}
