//
//  SpiralGraphDemoViewController.swift
//  TMShared
//
//  Created by Travis Ma on 8/26/19.
//  Copyright © 2019 Travis Ma. All rights reserved.
//

import UIKit

class SpiralGraphDemoViewController: UIViewController {
    @IBOutlet weak var spiralGraphView: SpiralGraphView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spiralGraphView.drawSpiralGraph(percents: [33.2, 67.8, 43.1, 22.4, 88.7], colors: [
            .systemPink, .systemIndigo, .systemRed, .systemBlue, .systemTeal
        ], thickness: 10, delay: 1)
    }
}
