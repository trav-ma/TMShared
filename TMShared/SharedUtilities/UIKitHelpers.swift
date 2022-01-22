//
//  UIKitHelpers.swift
//  TMShared
//
//  Created by Travis Ma on 8/26/19.
//  Copyright © 2019 Travis Ma. All rights reserved.
//

import UIKit

/* gradient usage
fileprivate var gradient: CAGradientLayer?
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if gradient == nil {
        gradient = gradientLayer(frame: self.view.bounds, topLeftColor: colorGrandient.lighter(), bottomRightColor: colorGrandient.darker())
        if let gradient = gradient {
            self.view.layer.insertSublayer(gradient, at: 0)
        }
    }
}
*/
func gradientLayer(frame: CGRect, topLeftColor: UIColor, bottomRightColor: UIColor) -> CAGradientLayer {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = frame
    gradientLayer.startPoint = CGPoint(x: 0, y: 0)
    gradientLayer.endPoint = CGPoint(x: 1, y: 1)
    gradientLayer.colors = [topLeftColor.cgColor, bottomRightColor.cgColor]
    return gradientLayer
}

let highPriotityConstraint = UILayoutPriority(1000)
let lowPriotityConstraint = UILayoutPriority(998)
func highLayoutPriorityForiPhoneMini() -> UILayoutPriority {
    return isiPhoneMini() ? highPriotityConstraint : lowPriotityConstraint
}

func isiPhoneMini() -> Bool {
    return UIScreen.main.bounds.height < 700 //iPhone mini 693
}

func showError(currentViewController: UIViewController, error: Error) {
    print("\(error)")
    DispatchQueue.main.async(execute:{
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        currentViewController.present(alert, animated: true, completion: nil)
    })
}

var appDelegate: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}

func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
}

//usage animateShakes(view: myTextField, shakes: 0, direction: 1)
func animateShakes(view: UIView, shakes: Int, direction: Int) {
    var s = shakes
    var d = direction
    UIView.animate(withDuration: 0.05, animations: {
        view.transform = CGAffineTransform(translationX: CGFloat(5 * direction), y: 0)
        }, completion: {
            finished in
            if shakes >= 8 {
                view.transform = .identity
                return
            }
            s += 1
            d = d * -1
            animateShakes(view: view, shakes: s, direction: d)
    })
}

/// Class ensures that swiping down on a modal while keyboard is present will dismiss the keyboard, not the whole modal (in case of unsaved changes / bottom navigation)
class KeyboardModalNonDismissableViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentationController?.delegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didHide),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
    }
    
    @objc func willShow() {
        isModalInPresentation = true
    }

    @objc func didHide() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isModalInPresentation = false
        }
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        self.view.endEditing(true)
    }
    
}
