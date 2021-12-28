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
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnDismiss: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    var colorTint: UIColor = .white
    var titleText: String?
    var titleFont: UIFont?
    var iconDismiss: UIImage?
    var iconSave: UIImage?
    var displayTimeStyle: DateFormatter.Style = .none
    var date = Date()
    var delegate: PopoverDatePickerViewControllerDelegate?
    var minuteInterval = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.tintColor = colorTint
        if minuteInterval > 0 {
            datePicker.date = date.rounded(toNearestMinutes: minuteInterval)
            datePicker.datePickerMode = .dateAndTime
            datePicker.minuteInterval = minuteInterval
            displayTimeStyle = .short
        } else {
            datePicker.date = date
            datePicker.datePickerMode = .date
        }
        labelTitle.text = titleText
        labelDate.text = datePicker.date.string(dateStyle: .short, timeStyle: displayTimeStyle)
        if let titleFont = titleFont {
            labelTitle.font = titleFont
        }
        if let iconSave = iconSave {
            btnSave.setImage(iconSave, for: .normal)
            btnSave.setTitle("", for: .normal)
        }
        if let iconDismiss = iconDismiss {
            btnDismiss.setImage(iconDismiss, for: .normal)
            btnDismiss.setTitle("", for: .normal)
        }
    }
    
    @IBAction func btnSaveTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            self.delegate?.popoverDatePickerViewDidChange(date: self.datePicker.date)
        })
    }
    
    @IBAction func btnDismissTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func datePickerDidChange(_ sender: Any) {
        date = datePicker.date
        labelDate.text = date.string(dateStyle: .short, timeStyle: displayTimeStyle)
    }
}
