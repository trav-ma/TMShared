
//
//  ValidationHelpers.swift
//  MFOS
//
//  Created by Travis Ma on 11/6/15.
//  Copyright © 2015 Travis Ma. All rights reserved.
//

import UIKit

let colorTint = UIColor(red: 236/255, green: 93/255, blue: 47/255, alpha: 1)

func hasValue(string: String) -> Bool {
    return string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).characters.count > 0
}

//usage animateShakes(myTextField, shakes: 0, direction: 1)
func animateShakes(view: UIView, shakes: Int, direction: Int) {
    var s = shakes
    var d = direction
    UIView.animateWithDuration(0.05, animations: {
        view.transform = CGAffineTransformMakeTranslation(CGFloat(5 * direction), 0)
        }, completion: {
            finished in
            if shakes >= 8 {
                view.transform = CGAffineTransformIdentity
                return
            }
            s += 1
            d = d * -1
            animateShakes(view, shakes: s, direction: d)
    })
}

func isButtonValid(btn: UIButton, successCheck: Bool) -> Bool {
    if !successCheck {
        if btn.buttonType == .System {
            btn.tintColor = UIColor.redColor()
        } else {
            btn.setTitleColor(UIColor.redColor(), forState:.Normal)
        }
        animateShakes(btn, shakes: 0, direction: 1)
        return false
    } else {
        restoreControl(btn)
    }
    return true
}

func isLabelValid(label: UILabel, successCheck: Bool) -> Bool {
    if !successCheck {
        label.textColor = UIColor.redColor()
        animateShakes(label, shakes: 0, direction: 1)
        return false
    } else {
        restoreControl(label)
    }
    return true
}

func restoreControl(label: UILabel) {
    label.textColor = UIColor.blackColor()
}

func restoreControl(btn: UIButton) {
    if btn.buttonType == .System {
        btn.tintColor = colorTint
    } else {
        btn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
    }
}

func restoreControl(textField: UITextField) {
    textField.layer.borderColor = nil
    textField.layer.borderWidth = 0
}

func restoreControl(textView: UITextView) {
    textView.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
    textView.layer.borderWidth = 0.5
}

func isTextFieldValid(textField: UITextField) -> Bool {
    if !hasValue(textField.text!) {
        textField.layer.borderColor = UIColor.redColor().CGColor
        textField.layer.borderWidth = 1
        animateShakes(textField, shakes: 0, direction: 1)
        return false
    } else {
        restoreControl(textField)
    }
    return true
}

func isTextViewValid(textView: UITextView) -> Bool {
    if !hasValue(textView.text) {
        textView.layer.borderColor = UIColor.redColor().CGColor
        animateShakes(textView, shakes: 0, direction: 1)
        return false
    } else {
        restoreControl(textView)
    }
    return true
}