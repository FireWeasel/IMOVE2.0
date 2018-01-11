//
//  Guide.swift
//  IMOVE3
//
//  Created by Fhict on 11/01/2018.
//  Copyright © 2018 fontys. All rights reserved.
//

import Foundation


class Guide :NSObject{
    
    var name:String
    var info: String
    var picture:String
    
    init(name:String, info:String, picture:String) {
        self.name = name
        self.info = info
        self.picture = picture
    }
    
    
}
