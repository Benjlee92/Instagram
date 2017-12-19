//
//  SharePhotoController.swift
//  InstagramLBTA
//
//  Created by Ben on 12/13/17.
//  Copyright © 2017 Ben. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SharePhotoController: UIViewController {
    
    let containerView: UIView = {
        let cv = UIView()
        cv.backgroundColor = .white
        return cv
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        return iv
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
    
        return tv
    }()
    
    var selectedImage: UIImage? {
        didSet {
            self.imageView.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        
        setupImageAndTextViews()
    }
    
    fileprivate func setupImageAndTextViews() {
        view.addSubview(containerView)
        
        containerView.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        
        view.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: -8, paddingRight: 0, width: 100 - 16, height: 0)
        
        view.addSubview(textView)
        textView.anchor(top: containerView.topAnchor, left: imageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: -8, paddingRight: 8, width: 0, height: 0)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func handleShare() {
        guard let caption = textView.text, caption.characters.count > 0 else {return}
        
        guard let image = selectedImage else {return}
        guard let uploadData = UIImageJPEGRepresentation(image, 0.5) else {return}
        
        let fileName = NSUUID().uuidString
        Storage.storage().reference().child("posts").child(fileName).putData(uploadData, metadata: nil) { (metadata, err) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload the post image", err)
            }
            guard let imageUrl = metadata?.downloadURL()?.absoluteString else {return}
            print("Successfully uploaded the post image", imageUrl)
            
            self.saveToDatabaseWithImageUrl(imageUrl: imageUrl)
            
        }
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    static let updateFeedNotificationName = NSNotification.Name(rawValue: "UpdateFeed")

    
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
        guard let postImage = selectedImage else {return}
        
        guard let caption = textView.text else {return}
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let userPostRef = Database.database().reference().child("posts").child(uid)
        
        let ref = userPostRef.childByAutoId()
        let values = ["imageUrl": imageUrl, "caption": caption, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "creationDate": Date().timeIntervalSince1970] as [String : Any]
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true

                print("Failed to save post to database", err)
            }
            
            print("Successfully saved post to database")
            self.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
        }
    }
    
}
