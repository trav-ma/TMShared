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
    var value: Float = 150.0
    var delegate: PopoverFloatPickerViewControllerDelegate?
    var borderColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: 280, height: 200)
        if let borderColor = borderColor {
            self.view.layer.borderColor = borderColor.cgColor
            self.view.layer.borderWidth = 2
            self.view.layer.cornerRadius = 12
        }
        let decimals = ceil(value.truncatingRemainder(dividingBy: 1) * 10)
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
            return 400
        } else {
            return 10
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
}

/*
if segue.identifier == "PopoverFloatPickerViewController" {
    if let vc = segue.destination as? PopoverFloatPickerViewController, let popoverController = vc.popoverPresentationController {
        vc.value = selectedWeight
        vc.delegate = self
        popoverController.delegate = self
        popoverController.backgroundColor = UIColor.white
        popoverController.sourceRect = btnWeight.frame
        popoverController.sourceView = btnWeight.superview
    }
    return
}

extension PhotoViewController: PopoverFloatPickerViewControllerDelegate {
    
    func popoverFloatPickerViewDidChange(value: Float) {
        selectedWeight = value
        btnWeight.setTitle("\(selectedWeight)", for: .normal)
    }
    
}

extension PhotoViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}
*/
