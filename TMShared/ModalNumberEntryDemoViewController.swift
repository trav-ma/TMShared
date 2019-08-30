//
//  ModalNumberEntryDemoViewController.swift
//  TMShared
//
//  Created by Travis Ma on 8/26/19.
//  Copyright © 2019 Travis Ma. All rights reserved.
//

import UIKit

class ModalNumberEntryDemoViewController: UIViewController {
    @IBOutlet weak var btnNumberInt: UIButton!
    @IBOutlet weak var btnNumberCurrency: UIButton!
    private var sourceButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ModalNumberEntryViewControllerInt" {
            sourceButton = btnNumberInt
            if let vc = segue.destination as? ModalNumberEntryViewController {
                vc.colorTint = .systemPink
                vc.titleFont = UIFont.italicSystemFont(ofSize: 24)
                vc.titleText = "Demo Int"
                vc.iconDismiss = UIImage(systemName: "xmark")
                vc.iconSave = UIImage(systemName: "checkmark")
                vc.iconBackspace = UIImage(systemName: "arrowtriangle.left")
                vc.delegate = self
                vc.precision = 0
                vc.isCurrency = false
                vc.showCommas = false
                vc.value = Double(btnNumberInt.title(for: .normal) ?? "0")!
            }
            return
        }
        if segue.identifier == "ModalNumberEntryViewControllerCurrency" {
            sourceButton = btnNumberCurrency
            if let vc = segue.destination as? ModalNumberEntryViewController {
                vc.colorTint = .systemIndigo
                vc.titleFont = UIFont.italicSystemFont(ofSize: 24)
                vc.titleText = "Demo Currency"
                vc.iconDismiss = UIImage(systemName: "xmark")
                vc.iconSave = UIImage(systemName: "checkmark")
                vc.iconBackspace = UIImage(systemName: "arrowtriangle.left")
                vc.delegate = self
                vc.precision = 2
                vc.isCurrency = true
                vc.showCommas = true
                let titleText = (btnNumberCurrency.title(for: .normal) ?? "0").replacingOccurrences(of: "$", with: "")
                vc.value = Double(titleText)!
            }
            return
        }
    }
}

extension ModalNumberEntryDemoViewController: ModalNumberEntryViewControllerDelegate {
    func modalNumberEntryViewDidChange(value: Double) {
        if sourceButton == btnNumberInt {
            btnNumberInt.setTitle("\(Int(value))", for: .normal)
        } else {
            btnNumberCurrency.setTitle("$\(value)", for: .normal)
        }
    }
}
