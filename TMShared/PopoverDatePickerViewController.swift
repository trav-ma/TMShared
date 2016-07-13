//
//  PopoverDatePickerViewController.swift
//  DemoCustomControls
//
//  Created by Travis Ma on 2/9/15.
//  Copyright (c) 2015 IMSHealth. All rights reserved.
//

import UIKit

class PopoverDatePickerViewController: UIViewController {
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    var didSelectDate : ((NSDate?) -> Void)!
    var date = NSDate()
    var mode: UIDatePickerMode = .DateAndTime
    var shouldShowClearButton = false
    var didTapClear = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = self.view.frame.size
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        datePicker.date = date
        self.datePicker.datePickerMode = mode
        if shouldShowClearButton {
            btnClear.hidden = false
            btnClear.layer.borderColor = self.view.tintColor.CGColor
            btnClear.layer.borderWidth = 1
            btnClear.layer.cornerRadius = 8
        } else {
            btnClear.hidden = true
        }
    }

    override func viewWillDisappear(animated: Bool) {
        didSelectDate(didTapClear ? nil : datePicker.date)
        super.viewWillDisappear(animated)
    }
    
    @IBAction func btnClearTap(sender: AnyObject) {
        didTapClear = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
