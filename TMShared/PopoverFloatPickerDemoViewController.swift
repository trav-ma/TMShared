//
//  PopoverFloatPickerDemoViewController.swift
//  TMShared
//
//  Created by Travis Ma on 8/26/19.
//  Copyright © 2019 Travis Ma. All rights reserved.
//

import UIKit

class PopoverFloatPickerDemoViewController: UIViewController {
    @IBOutlet weak var btnFloat: UIButton!
    var selectedWeight: Float = 180.6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnFloat.setTitle("\(selectedWeight)", for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PopoverFloatPickerViewController" {
            if let vc = segue.destination as? PopoverFloatPickerViewController, let popoverController = vc.popoverPresentationController {
                vc.value = selectedWeight
                vc.maxWhole = 200
                vc.maxDecimal = 200
                vc.delegate = self
                popoverController.delegate = self
                popoverController.sourceRect = btnFloat.frame
                popoverController.sourceView = btnFloat.superview
            }
            return
        }
    }
}

extension PopoverFloatPickerDemoViewController: PopoverFloatPickerViewControllerDelegate {
    
    func popoverFloatPickerViewDidChange(value: Float) {
        selectedWeight = value
        btnFloat.setTitle("\(selectedWeight)", for: .normal)
    }
    
}

extension PopoverFloatPickerDemoViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}
