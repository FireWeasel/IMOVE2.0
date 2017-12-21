//
//  LeaderBoards.swift
//  IMOVE_Test
//
//  Created by Fhict on 14/12/2017.
//  Copyright © 2017 Fhict. All rights reserved.
//

import Foundation


class LeaderBoard: NSObject {
    var name:String!
    var score:Int!
    var profilePicture:String!
    
    init(name: String, score: Int, picture: String) {
        self.name = name
        self.score = score
        self.profilePicture = picture
    }
}
