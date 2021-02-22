//
//  User.swift
//  Original App ver.2
//
//  Created by 石井　翔 on 2020/09/16.
//  Copyright © 2020 石井　翔. All rights reserved.
//

import Foundation
import UIKit

class User {
    var objectId: String
    var userName: String
    var displayName: String?
    var introduction: String?

    init(objectId: String, userName: String) {
        self.objectId = objectId
        self.userName = userName
    }
    
    
}
