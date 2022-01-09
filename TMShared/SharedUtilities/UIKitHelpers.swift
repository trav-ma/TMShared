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

extension UIScreen {
    func phoneSizeInInches() -> CGFloat {
        switch (self.nativeBounds.size.height) {
        case 960, 480:
            return 3.5  //iPhone 4
        case 1136:
            return 4    //iPhone 5
        case 1334:
            return 4.7  //iPhone 6
        case 2208:
            return 5.5  //iPhone 6 Plus
        case 2436:
            return 5.8  //iPhone X
        case 1792:
            return 5.5  //iPhone XR
        case 2688:
            return 6.5  //iPhone XS Max
        default:
            let scale = self.scale
            let ppi = scale * 163
            let width = self.bounds.size.width * scale
            let height = self.bounds.size.height * scale
            let horizontal = width / ppi, vertical = height / ppi
            let diagonal = sqrt(pow(horizontal, 2) + pow(vertical, 2))
            return diagonal
        }
    }
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
