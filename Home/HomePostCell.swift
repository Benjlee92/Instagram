//
//  HomePostCell.swift
//  InstagramLBTA
//
//  Created by Ben on 12/14/17.
//  Copyright © 2017 Ben. All rights reserved.
//

import Foundation
import UIKit

class HomePostCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            print(post?.imageUrl)
            guard let postImageUrl = post?.imageUrl else {return}
            photoImageView.loadImage(urlString: postImageUrl)
        }
    }
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
