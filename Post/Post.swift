//
//  Post.swift
//  Original App ver.2
//
//  Created by 石井　翔 on 2020/09/16.
//  Copyright © 2020 石井　翔. All rights reserved.
//

import Foundation
import UIKit

class Post {
    var user: User
    var objectId: String
    var imageUrl: String
    var text: String
    var createDate: Date
    var bookmark: Bool?
    var placeName: String
    var star: Double = 0.0
    var latitude : Double!
    var longitude : Double!
    
    
    init(user:User ,objectId: String, imageUrl: String, text: String, createDate: Date, placeName: String, star: Double, longitude:Double, latitude:Double) {
        self.objectId = objectId
        self.user = user
        self.imageUrl = imageUrl
        self.text = text
        self.createDate = createDate
        self.placeName = placeName
        self.star = star
        self.latitude = latitude
        self.longitude = longitude
    }
    
    
    
    
    
    
}
