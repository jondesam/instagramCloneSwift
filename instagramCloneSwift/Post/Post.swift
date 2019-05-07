//
//  File.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-05-07.
//  Copyright © 2019 Apex. All rights reserved.
//

import Foundation
class Post {
    var description :String
    var key :String
    
    init(descriptionText: String, keyString: String) {
        description = descriptionText
        key = keyString
    }
}
