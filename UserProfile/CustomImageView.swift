//
//  CustomImageView.swift
//  InstagramLBTA
//
//  Created by Ben on 12/13/17.
//  Copyright © 2017 Ben. All rights reserved.
//

import Foundation
import UIKit
class CustomImageView: UIImageView {
    
    var lastUrlUsedToLoadImage: String?
    
    func loadImage(urlString: String)  {
        
        lastUrlUsedToLoadImage = urlString

        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to fetch post image", err)
            }
            
            
            //prevents flickering of images
            if url.absoluteString != self.lastUrlUsedToLoadImage {
                return
            }
            guard let imageData = data else {return}
            let photoImage = UIImage(data: imageData)
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
            
            }.resume()
    }
}
