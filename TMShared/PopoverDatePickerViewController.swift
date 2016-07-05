//
//  PopoverDatePickerViewController.swift
//  DemoCustomControls
//
//  Created by Travis Ma on 2/9/15.
//  Copyright (c) 2015 IMSHealth. All rights reserved.
//

import UIKit

class PopoverDatePickerViewController: UIViewController {
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    var didSelectDate : ((NSDate) -> Void)!
    var date = NSDate()
    var mode: UIDatePickerMode = .DateAndTime
    var shouldShowApplyButton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = self.view.frame.size
        self.datePicker.datePickerMode = mode
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        datePicker.date = date
    }

    override func viewWillDisappear(animated: Bool) {
        if !shouldShowApplyButton {
            didSelectDate(datePicker.date)
        }
        super.viewWillDisappear(animated)
    }
    
    @IBAction func btnApplyTap(sender: AnyObject) {
        didSelectDate(datePicker.date)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
