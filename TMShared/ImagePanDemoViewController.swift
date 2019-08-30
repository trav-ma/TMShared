//
//  ImagePanDemoViewController.swift
//  TMShared
//
//  Created by Travis Ma on 8/26/19.
//  Copyright © 2019 Travis Ma. All rights reserved.
//

import UIKit

class ImagePanDemoViewController: UIViewController {
    var imagePanViewController = ImagePanViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePanViewController.setup(viewController: self, image: UIImage(named: "tempPic")!)
    }
}
