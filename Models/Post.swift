//
//  Post.swift
//  InstagramLBTA
//
//  Created by Ben on 12/13/17.
//  Copyright © 2017 Ben. All rights reserved.
//

import Foundation

struct Post {
    let imageUrl: String
    
    init(dictionary: [String: Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
    
}
