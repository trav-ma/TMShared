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
    private var buttonTitle = ""
    
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
        buttonTitle = self.title(for: .normal) ?? ""
        self.setTitle("", for: .normal)
        activity.startAnimating()
    }
    
    func stopWaiting() {
        self.isEnabled = true
        self.setTitle(buttonTitle, for: .normal)
        activity.stopAnimating()
    }

}
