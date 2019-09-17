//
//  LeftEdgeSlidingPickerDemoViewController.swift
//  TMShared
//
//  Created by Travis Ma on 9/17/19.
//  Copyright © 2019 Travis Ma. All rights reserved.
//

import UIKit

class LeftEdgeSlidingPickerDemoViewController: UIViewController {
    @IBOutlet weak var labelValue: UILabel!
    @IBOutlet weak var slidingPicker: LeftEdgeSlidingPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slidingPicker.delehgate = self
        slidingPicker.setup(sliderColor: .systemBlue,
                            values: ["1","2","3","4",5,6, UIImage(systemName: "trash")!],
                            font: UIFont.boldSystemFont(ofSize: 24),
                            selectedValueColor: .white)
    }
}

extension LeftEdgeSlidingPickerDemoViewController: LeftEdgeSlidingPickerViewDelegate {
    func leftEdgeSlidingPickerDidSelect(index: Int) {
        labelValue.text = "\(index + 1)"
    }
}
