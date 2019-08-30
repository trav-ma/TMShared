//
//  ModalTextEntryDemoViewController.swift
//  TMShared
//
//  Created by Travis Ma on 8/26/19.
//  Copyright © 2019 Travis Ma. All rights reserved.
//

import UIKit

class ModalTextEntryDemoViewController: UIViewController {
    @IBOutlet weak var labelText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelText.text = ""
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ModalTextEntryViewController" {
            if let vc = segue.destination as? ModalTextEntryViewController {
                vc.colorTint = .systemIndigo
                vc.titleFont = UIFont.italicSystemFont(ofSize: 24)
                vc.titleText = "Write Some Text!"
                vc.iconDismiss = UIImage(systemName: "xmark")
                vc.iconSave = UIImage(systemName: "checkmark")
                vc.delegate = self
                vc.value = labelText.text
            }
            return
        }
    }
}

extension ModalTextEntryDemoViewController: ModalTextEntryViewControllerDelegate {
    func modalTextEntryViewDidChangeText(text: String) {
        labelText.text = text
    }
}
