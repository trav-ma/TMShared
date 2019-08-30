//
//  WaitButtonDemoViewController.swift
//  TMShared
//
//  Created by Travis Ma on 8/26/19.
//  Copyright © 2019 Travis Ma. All rights reserved.
//

import UIKit

class WaitButtonDemoViewController: UIViewController {
    @IBOutlet weak var waitTextButton: WaitButton!
    @IBOutlet weak var waitImageButton: WaitButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func waitTextButtonTap(_ sender: Any) {
        waitTextButton.wait()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.waitTextButton.stopWaiting()
        }
    }
    
    @IBAction func waitImageButtonTap(_ sender: Any) {
        waitImageButton.wait()
        waitImageButton.activity.style = .large
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.waitImageButton.stopWaiting()
        }
    }
}
