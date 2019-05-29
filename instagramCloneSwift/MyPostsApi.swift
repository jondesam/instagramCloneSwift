//
//  MyPostsApi.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-05-27.
//  Copyright © 2019 Apex. All rights reserved.
//

import Foundation
import FirebaseDatabase

class MyPostsApi {
    var REF_MYPOSTS = Database.database().reference().child("myPosts")
}
