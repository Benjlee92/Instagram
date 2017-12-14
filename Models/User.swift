//
//  User.swift
//  InstagramLBTA
//
//  Created by Ben on 12/14/17.
//  Copyright © 2017 Ben. All rights reserved.
//

import Foundation

struct User {
    let uid: String
    let username: String
    let profileImageUrl: String
    init(uid: String, dictionary : [String: Any]) {
        self.username = dictionary["Username"] as? String ?? ""
        self.profileImageUrl = dictionary["ProfileImageUrl"] as? String ?? ""
        self.uid = uid
    }
}
