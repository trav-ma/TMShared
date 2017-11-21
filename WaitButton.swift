//
//  WaitButton.swift
//  LorisHands
//
//  Created by Travis Ma on 11/18/17.
//  Copyright © 2017 Travis Ma. All rights reserved.
//

import UIKit

class WaitButton: UIButton {
    let activity = UIActivityIndicatorView()
    private var tempTitle = ""
    private var tempImage: UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.hidesWhenStopped = true
        self.addSubview(activity)
        activity.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activity.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    func wait() {
        self.isEnabled = false
        tempTitle = self.title(for: .normal) ?? ""
        tempImage = self.imageView?.image
        self.setTitle("", for: .normal)
        self.setImage(nil, for: .normal)
        activity.startAnimating()
    }
    
    func stopWaiting(newTitle: String? = nil) {
        self.isEnabled = true
        if let newTitle = newTitle {
            self.setTitle(newTitle, for: .normal)
        } else {
            self.setTitle(tempTitle, for: .normal)
        }
        self.imageView?.image = tempImage
        activity.stopAnimating()
    }

}
