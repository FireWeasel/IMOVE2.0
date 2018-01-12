//
//  File.swift
//  IMOVE3
//
//  Created by Fhict on 02/12/2017.
//  Copyright © 2017 fontys. All rights reserved.
//

import Foundation
import UIKit

class User:NSObject {
    var name:String!
    var totalScore:Int!
    var level:Int!
    var profileImage:String?
    var challenges:Int!
    
    
    init(name: String, profileImage: String, totalScore: Int, level: Int,challenges:Int ) {
        self.name = name
        self.profileImage = profileImage
        self.level = level
        self.totalScore = totalScore
        self.challenges = challenges
    }
    
    init(name: String, profileImage:String, level:Int) {
        self.name = name
        self.profileImage = profileImage
        self.level = level
        self.totalScore = 0
        self.challenges = 0
    }
}
