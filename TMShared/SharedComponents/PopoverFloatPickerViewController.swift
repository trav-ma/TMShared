//
//  PopoverFloatPickerViewController.swift
//  Body Stack
//
//  Created by Travis Ma on 12/10/17.
//  Copyright © 2017 Travis Ma. All rights reserved.
//

import UIKit

protocol PopoverFloatPickerViewControllerDelegate {
    func popoverFloatPickerViewDidChange(value: Float)
}

class PopoverFloatPickerViewController: UIViewController {
    @IBOutlet weak var picker: UIPickerView!
    var value: Float = 0.0
    var maxWhole: Int = 400
    var maxDecimal: Int = 10
    var delegate: PopoverFloatPickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: 280, height: 200)
        let decimals = Int(value.truncatingRemainder(dividingBy: 1) * 10)
        let whole = floor(value)
        picker.selectRow(Int(whole), inComponent: 0, animated: true)
        picker.selectRow(Int(decimals), inComponent: 1, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let value = "\(picker.selectedRow(inComponent: 0)).\(picker.selectedRow(inComponent: 1))"
        delegate?.popoverFloatPickerViewDidChange(value: Float(value)!)
        super.viewWillDisappear(animated)
    }

}

extension PopoverFloatPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return maxWhole
        } else {
            return maxDecimal
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return component == 0 ? 60 : 60
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
}
