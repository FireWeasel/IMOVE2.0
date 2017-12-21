//
//  ChallengeAnnotation.swift
//  IMOVE3
//
//  Created by Fhict on 01/12/2017.
//  Copyright © 2017 fontys. All rights reserved.
//

import MapKit

class ChallengeAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var desc: String!
    var name: String!
    var image: String!
    var rating: String!
    var type: Type!
    
    init(coordinate: CLLocationCoordinate2D, image: String, desc:String, name:String, rating:String, type: Type) {
        self.coordinate = coordinate
        self.image = image
        self.desc = desc
        self.name = name
        self.rating = rating
        self.type = type
    }
}

public enum Type:String {
    case group
    case button
    case other
    case map
    case climb
    case plank
    case tricep
}
