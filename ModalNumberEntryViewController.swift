//
//  ModalNumberEntryViewController.swift
//  RidePaper
//
//  Created by Travis Ma on 10/29/17.
//  Copyright © 2017 Travis Ma. All rights reserved.
//

import UIKit

protocol ModalNumberEntryViewControllerDelegate {
    func modalNumberEntryViewDidChange(value: Double)
}

extension String {
    func leftPadding(toLength: Int, withPad: String = " ") -> String {
        guard toLength > self.count else { return self }
        let padding = String(repeating: withPad, count: toLength - self.count)
        return padding + self
    }
}

class ModalNumberEntryViewController: UIViewController {
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnDismiss: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    @IBOutlet weak var btn9: UIButton!
    @IBOutlet weak var btn0: UIButton!
    @IBOutlet weak var btnBackspace: UIButton!
    var color: UIColor = .white
    var titleText: String?
    var titleFont: UIFont?
    var iconDismiss: UIImage?
    var iconSave: UIImage?
    var iconBackspace: UIImage?
    var value: Double = 0
    var precision: Int = 0
    var delegate: ModalNumberEntryViewControllerDelegate?
    var buttons = [UIButton]()
    var numberFormatter = NumberFormatter()
    var symbol = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.tintColor = color
        numberFormatter.numberStyle = .currency
        numberFormatter.minimumFractionDigits = precision
        numberFormatter.maximumFractionDigits = precision
        numberFormatter.currencySymbol = symbol
        labelTitle.text = titleText
        labelAmount.text = numberFormatter.string(from: NSNumber(value: value))
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
        if let iconBackspace = iconBackspace {
            btnBackspace.setImage(iconBackspace, for: .normal)
            btnBackspace.setTitle("", for: .normal)
        }
        buttons = [
            btn0,
            btn1,
            btn2,
            btn3,
            btn4,
            btn5,
            btn6,
            btn7,
            btn8,
            btn9
        ]
        for btn in buttons {
            btn.layer.borderColor = view.tintColor.cgColor
            btn.layer.cornerRadius = btn.frame.width / 2
            btn.layer.borderWidth = 1
        }
    }
    
    func stringValue() -> String {
        return String(format: "%.\(precision)f", value).replacingOccurrences(of: ".", with: "")
    }
    
    func updateAmount(val: String) {
        var string = val
        if precision > 0 { //reinsert decimal
            string = string.leftPadding(toLength: precision + 1, withPad: "0")
            string.insert(".", at: string.index(string.endIndex, offsetBy: -precision))
        }
        value = Double(string) ?? 0
        labelAmount.text = numberFormatter.string(from: NSNumber(value: value))
    }
        
    @IBAction func btnBackspaceTap(_ sender: Any) {
        var string = String(self.stringValue().dropLast())
        if string.count == 0 {
            string = "0"
        }
        updateAmount(val: string)
    }
    
    @IBAction func btnNumberTap(_ sender: UIButton) {
        var string = ""
        if value > 0 {
            string = stringValue()
        }
        string += "\(sender.tag)"
        updateAmount(val: string)
    }
    
    @IBAction func btnSaveTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            self.delegate?.modalNumberEntryViewDidChange(value: self.value)
        })
    }
    
    @IBAction func btnDismissTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
