//
//  CircleGraphDemoViewController.swift
//  TMShared
//
//  Created by Travis Ma on 8/26/19.
//  Copyright © 2019 Travis Ma. All rights reserved.
//

import UIKit

class CircleGraphDemoViewController: UIViewController {
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var labelValue: UILabel!
    @IBOutlet weak var circleGraphView: CircleGraphView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func animate() {
        circleGraphView.drawCircleGraph(percents: [23, 34], colors: [#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)], thickness: CGFloat(slider.value))
        labelValue.text = "\(Int(slider.value))"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate()
    }

    @IBAction func sliderChanged(_ sender: Any) {
        animate()
    }
}
