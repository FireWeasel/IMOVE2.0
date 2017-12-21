//
//  Reward.swift
//  IMOVE3
//
//  Created by Fhict on 21/12/2017.
//  Copyright © 2017 fontys. All rights reserved.
//

import Foundation

class Reward:NSObject {
    var name:String!
    var desc:String!
    var points:Int!
    var code:String!
    
    
    init(name: String, code: String, points: Int, desc: String) {
        self.name = name
        self.code = code
        self.points = points
        self.desc = desc
    }
}
