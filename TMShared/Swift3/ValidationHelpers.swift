
//
//  ValidationHelpers.swift
//  MFOS
//
//  Created by Travis Ma on 11/6/15.
//  Copyright © 2015 Travis Ma. All rights reserved.
//

import UIKit

func hasValue(_ string: String) -> Bool {
    return string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).characters.count > 0
}

//usage animateShakes(myTextField, shakes: 0, direction: 1)
func animateShakes(_ view: UIView, shakes: Int, direction: Int) {
    var s = shakes
    var d = direction
    UIView.animate(withDuration: 0.05, animations: {
        view.transform = CGAffineTransform(translationX: CGFloat(5 * direction), y: 0)
        }, completion: {
            finished in
            if shakes >= 8 {
                view.transform = CGAffineTransform.identity
                return
            }
            s += 1
            d = d * -1
            animateShakes(view, shakes: s, direction: d)
    })
}

func isButtonValid(_ btn: UIButton, successCheck: Bool, resetColor: UIColor) -> Bool {
    if !successCheck {
        if btn.buttonType == .system {
            btn.tintColor = UIColor.red
        } else {
            btn.setTitleColor(UIColor.red, for:UIControlState())
        }
        animateShakes(btn, shakes: 0, direction: 1)
        return false
    } else {
        restoreControl(btn, resetColor: resetColor)
    }
    return true
}

func isLabelValid(_ label: UILabel, successCheck: Bool) -> Bool {
    if !successCheck {
        label.textColor = UIColor.red
        animateShakes(label, shakes: 0, direction: 1)
        return false
    } else {
        restoreControl(label)
    }
    return true
}

func restoreControl(_ label: UILabel) {
    label.textColor = UIColor.black
}

func restoreControl(_ btn: UIButton, resetColor: UIColor) {
    if btn.buttonType == .system {
        btn.tintColor = resetColor
    } else {
        btn.setTitleColor(UIColor.lightGray, for: UIControlState())
    }
}

func restoreControl(_ textField: UITextField) {
    textField.layer.borderColor = nil
    textField.layer.borderWidth = 0
}

func restoreControl(_ textView: UITextView) {
    textView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
    textView.layer.borderWidth = 0.5
}

func isTextFieldValid(_ textField: UITextField) -> Bool {
    if !hasValue(textField.text!) {
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1
        animateShakes(textField, shakes: 0, direction: 1)
        return false
    } else {
        restoreControl(textField)
    }
    return true
}

func isTextViewValid(_ textView: UITextView) -> Bool {
    if !hasValue(textView.text) {
        textView.layer.borderColor = UIColor.red.cgColor
        animateShakes(textView, shakes: 0, direction: 1)
        return false
    } else {
        restoreControl(textView)
    }
    return true
}
