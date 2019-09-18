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
        slidingPicker.delegate = self
        slidingPicker.setup(sliderColor: .systemBlue,
                            values: ["1","2","3","4",5,6, UIImage(systemName: "trash")!],
                            font: UIFont.systemFont(ofSize: 18),
                            selectedValuesColor: .white,
                            selectedIndexFont: UIFont.boldSystemFont(ofSize: 24))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        slidingPicker.currentIndex = 3
        labelValue.text = "4"
    }
}

extension LeftEdgeSlidingPickerDemoViewController: LeftEdgeSlidingPickerViewDelegate {
    func leftEdgeSlidingPicker(_ slidingPicker: LeftEdgeSlidingPickerView, didSelectItemAt index: Int) {
        labelValue.text = "\(index + 1)"
    }
}
