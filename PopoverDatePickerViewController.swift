//
//  DatePickerViewController.swift
//  MedTaxes
//
//  Created by Travis Ma on 8/22/16.
//  Copyright © 2016 Travis Ma. All rights reserved.
//

import UIKit

protocol PopoverDatePickerViewControllerDelegate {
    func popoverDatePickerViewDidChange(date: Date)
}

class PopoverDatePickerViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    var date: Date?
    var delegate: PopoverDatePickerViewControllerDelegate?
    var borderColor: UIColor?
    var minuteInterval = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: 280, height: 200)
        datePicker.date = date ?? Date()
        if let borderColor = borderColor {
            self.view.layer.borderColor = borderColor.cgColor
            self.view.layer.borderWidth = 2
            self.view.layer.cornerRadius = 12
        }
        if minuteInterval > 0 {
            datePicker.datePickerMode = .dateAndTime
            datePicker.minuteInterval = minuteInterval
        } else {
            datePicker.datePickerMode = .date
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.popoverDatePickerViewDidChange(date: datePicker.date)
        super.viewWillDisappear(animated)
    }

}

/*
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "PopoverDatePickerViewController" {
        if let vc = segue.destination as? PopoverDatePickerViewController, let popoverController = vc.popoverPresentationController {
            vc.date = selectedDate
            vc.delegate = self
            popoverController.delegate = self
            popoverController.backgroundColor = UIColor.white
            popoverController.sourceRect = btnDate.frame
            popoverController.sourceView = btnDate.superview
        }
        return
    }
    
}

extension MyViewController: PopoverDatePickerViewControllerDelegate {
    
    func popoverDatePickerViewDidChange(date: Date) {
        selectedDate = date
        btnDate.setTitle(formatDate(selectedDate, format: "MM/dd/yyyy"), for: .normal)
    }
    
}

extension MyViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}
*/
