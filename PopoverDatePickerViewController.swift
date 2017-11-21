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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: 280, height: 200)
        if date == nil {
            date = Date()
        }
        datePicker.date = date!
        if let borderColor = borderColor {
            self.view.layer.borderColor = borderColor.cgColor
            self.view.layer.borderWidth = 2
            self.view.layer.cornerRadius = 12
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if date! != datePicker.date {
            delegate?.popoverDatePickerViewDidChange(date: datePicker.date)
        }
        super.viewWillDisappear(animated)
    }

}


/* Usage
 
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "seguePopoverDatePicker" {
        self.view.endEditing(true)
        let vc = segue.destination as! PopoverDatePickerViewController
        vc.date = selectedDate
        vc.delegate = self
        let popoverController = vc.popoverPresentationController!
        popoverController.delegate = self
        popoverController.backgroundColor = UIColor.white
        popoverController.sourceRect = btnDate.frame
        popoverController.sourceView = btnDate.superview
        return
    }
}

extension MyViewController: PopoverDatePickerViewControllerDelegate {
    
    func popoverDatePickerViewDidChange(date: Date) {
        selectedDate = date
        displayDate()
    }
    
}

extension MyViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}

func displayDate() {
    labelDate.text = formatDate(selectedDate, format: "MM/dd/yyyy")
}
 
*/
