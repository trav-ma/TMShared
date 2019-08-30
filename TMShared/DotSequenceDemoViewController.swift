//
//  DotSequenceDemoViewController.swift
//  TMShared
//
//  Created by Travis Ma on 8/26/19.
//  Copyright © 2019 Travis Ma. All rights reserved.
//

import UIKit

class DotSequenceDemoViewController: UIViewController {
    @IBOutlet weak var dotSequenceView: DotSequenceView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dotSequenceView.drawDotSequence(fillCount: 4, totalCount: 5, fillColor: UIColor.systemBlue, emptyColor: UIColor.systemGray)
    }

}
