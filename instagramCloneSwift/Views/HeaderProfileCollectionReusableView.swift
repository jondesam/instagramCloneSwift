//
//  HeaderProfileCollectionReusableView.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-05-25.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit

class HeaderProfileCollectionReusableView: UICollectionReusableView {
   func  updateView() {
    Api.UserAPI.REF_CURRENT_USER?.observeSingleEvent(of: .value, with: { (snapshot) in
        print("snapshot")
        print(snapshot)
    })
    }
}
