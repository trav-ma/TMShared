//
//  ModalTextEntryViewController.swift
//  RidePaper
//
//  Created by Travis Ma on 10/22/17.
//  Copyright © 2017 Travis Ma. All rights reserved.
//

import UIKit

/* usage
if segue.identifier == "ModalTextEntryViewController" {
    if let vc = segue.destination as? ModalTextEntryViewController {
        vc.color = self.view.tintColor
        vc.titleFont = labelAvatarTitle.font
        vc.titleText = "Description/Location"
        vc.iconDismiss = #imageLiteral(resourceName: "cross-ui")
        vc.iconSave = #imageLiteral(resourceName: "check-ui")
        vc.delegate = self
        if labelDescription.text != kDefaultDescription {
            vc.initialText = labelDescription.text
        }
    }
    return
}
*/

protocol ModalTextEntryViewControllerDelegate {
    func modalTextEntryViewDidChangeText(text: String)
}

class ModalTextEntryViewController: UIViewController {
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnDismiss: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var textViewNote: UITextView!
    var color: UIColor = .white
    var titleText: String?
    var titleFont: UIFont?
    var iconDismiss: UIImage?
    var iconSave: UIImage?
    var initialText : String?
    var delegate: ModalTextEntryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.tintColor = color
        textViewNote.layer.borderColor = view.tintColor.cgColor
        textViewNote.layer.borderWidth = 2
        textViewNote.layer.cornerRadius = 12
        textViewNote.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        labelTitle.text = titleText
        textViewNote.text = initialText
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textViewNote.becomeFirstResponder()
    }
    
    @IBAction func btnSaveTap(_ sender: UIButton) {
        textViewNote.resignFirstResponder()
        self.dismiss(animated: true, completion: {
            self.delegate?.modalTextEntryViewDidChangeText(text: self.textViewNote.text ?? "")
        })
    }
    
    @IBAction func btnDismissTap(_ sender: UIButton) {
        textViewNote.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
}
