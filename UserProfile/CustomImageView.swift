//
//  CustomImageView.swift
//  InstagramLBTA
//
//  Created by Ben on 12/13/17.
//  Copyright © 2017 Ben. All rights reserved.
//

import Foundation
import UIKit


var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    
    var lastUrlUsedToLoadImage: String?
    
    func loadImage(urlString: String)  {
        
        lastUrlUsedToLoadImage = urlString
        self.image = nil
        
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return 
        }

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
            
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
            
            }.resume()
    }
}
