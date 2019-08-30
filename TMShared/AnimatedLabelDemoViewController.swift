//
//  AnimatedLabelDemoViewController.swift
//  TMShared
//
//  Created by Travis Ma on 8/26/19.
//  Copyright © 2019 Travis Ma. All rights reserved.
//

import UIKit

class AnimatedLabelDemoViewController: UIViewController {
    @IBOutlet weak var animatedLabel: AnimatedLabel!
    private var value: Float = 475.64
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func animate() {
        animatedLabel.countFromZero(to: value)
    }
    @IBAction func btnIntTap(_ sender: Any) {
        animatedLabel.decimalPoints = .zero
        animatedLabel.customFormatBlock = nil
        animate()
    }
    
    @IBAction func btnFloatTap(_ sender: Any) {
        animatedLabel.decimalPoints = .two
        animatedLabel.customFormatBlock = nil
        animate()
    }
    
    @IBAction func btnCurrencyTap(_ sender: Any) {
        animatedLabel.customFormatBlock = {
            "$%.02f"
        }
        animate()
    }
}
