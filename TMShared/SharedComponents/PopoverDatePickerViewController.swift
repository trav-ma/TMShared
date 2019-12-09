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
    var date = Date()
    var delegate: PopoverDatePickerViewControllerDelegate?
    var minuteInterval = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: 280, height: 200)
        if minuteInterval > 0 {
            datePicker.date = date.rounded(toNearestMinutes: minuteInterval)
            datePicker.datePickerMode = .dateAndTime
            datePicker.minuteInterval = minuteInterval
        } else {
            datePicker.date = date
            datePicker.datePickerMode = .date
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.popoverDatePickerViewDidChange(date: datePicker.date)
        super.viewDidDisappear(animated)
    }

}
