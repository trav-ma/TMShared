//
//  PopoverDatePickerDemoViewController.swift
//  TMShared
//
//  Created by Travis Ma on 8/26/19.
//  Copyright © 2019 Travis Ma. All rights reserved.
//

import UIKit

class PopoverDatePickerDemoViewController: UIViewController {
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var btnDateTime: UIButton!
    private var selectedDate = Date()
    private var selectedDateTime = Date()
    private var sourceButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PopoverDatePickerViewControllerDate" {
            sourceButton = btnDate
            if let vc = segue.destination as? PopoverDatePickerViewController, let popoverController = vc.popoverPresentationController {
                vc.date = selectedDate
                vc.delegate = self
                popoverController.delegate = self
                popoverController.sourceRect = btnDate.frame
                popoverController.sourceView = btnDate.superview
            }
            return
        }
        if segue.identifier == "PopoverDatePickerViewControllerDateTime" {
            sourceButton = btnDateTime
            if let vc = segue.destination as? PopoverDatePickerViewController, let popoverController = vc.popoverPresentationController {
                vc.date = selectedDateTime
                vc.delegate = self
                vc.minuteInterval = 5
                popoverController.delegate = self
                popoverController.sourceRect = btnDateTime.frame
                popoverController.sourceView = btnDateTime.superview
            }
            return
        }
    }
}

extension PopoverDatePickerDemoViewController: PopoverDatePickerViewControllerDelegate {
    
    func popoverDatePickerViewDidChange(date: Date) {
        if sourceButton == btnDate {
            selectedDate = date
            btnDate.setTitle("\(date.format("M-d-yyyy"))", for: .normal)
        } else {
            selectedDateTime = date
            btnDateTime.setTitle("\(date.format("M/d h:mm a"))", for: .normal)
        }
    }
    
}

extension PopoverDatePickerDemoViewController: UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

}
