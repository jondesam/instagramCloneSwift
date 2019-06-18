//
//  StorageReference.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-06-15.
//  Copyright © 2019 Apex. All rights reserved.
//

import Foundation
import FirebaseStorage

struct StorageReference {
    static let storageRef = Storage.storage().reference(forURL: "gs://instagramcloneswift.appspot.com")
  
}
