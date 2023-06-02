//
//  SingleReuseIdentifier.swift
//  OCE
//
//  Created by Andrii Kharchyshyn on 4/20/17.
//  Copyright © 2017 QIMS. All rights reserved.
//

import UIKit

protocol StoryboardInstantiable: NSObjectProtocol {
    associatedtype MyType
    static var storyboardName: String { get }
    static func instantiateViewController(_ bundle: Bundle?) -> MyType
}

extension StoryboardInstantiable where Self: UIViewController {
    
    static var storyboardName: String {
        return String(describing: self)
    }
    
    static func instantiateViewController(_ bundle: Bundle? = nil) -> Self {
        let fileName = storyboardName
        assert((bundle ?? Bundle.main).path(forResource: fileName, ofType: "storyboardc") != nil,
               "Can't load storyboard of given name")
        let sb = UIStoryboard(name: fileName, bundle: bundle)
        return sb.instantiateInitialViewController() as! Self // swiftlint:disable:this force_cast
    }
    
    static func instantiateViewController(_ identifier: String, _ bundle: Bundle? = nil) -> Self {
        let fileName = storyboardName
        assert((bundle ?? Bundle.main).path(forResource: fileName, ofType: "storyboardc") != nil,
               "Can't load storyboard of given name")
        let sb = UIStoryboard(name: fileName, bundle: bundle)
        return sb.instantiateViewController(withIdentifier: identifier) as! Self // swiftlint:disable:this force_cast
    }
    
}

extension UIViewController: UIGestureRecognizerDelegate {
    
    @IBAction func btnCloseTap(_ sender: Any) {
        self.view.endEditing(true)
        if let nc = self.navigationController {
            if nc.viewControllers.first == self {
                self.dismiss(animated: true, completion: nil)
            } else {
                nc.popViewController(animated: true)
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func enableSwipeToPop() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func disableSwipeToPop() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer {
            return false
        }
        return true
    }
    
}

//To use this protocol the cell should has the identifier and nib name must have the same name like cell ID 
protocol SingleReuseIdentifier: AnyObject {
	static var identifier: String {get}
	static var nibName: String {get}
	static var nib: UINib {get}
}

extension SingleReuseIdentifier where Self: UICollectionReusableView {
	static var identifier: String {
		return String(describing: type(of: self)).components(separatedBy: ".").first ?? ""
	}
	static var nibName: String {
		return identifier
	}
	static var nib: UINib {
		return UINib(nibName: nibName, bundle: nil)
	}
}

extension SingleReuseIdentifier where Self: UIViewController {
    static var identifier: String {
        return String(describing: type(of: self)).components(separatedBy: ".").first ?? ""
    }
    static var nibName: String {
        return identifier
    }
    static var nib: UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
}

extension SingleReuseIdentifier where Self: UITableViewCell {
    static var identifier: String {
        return String(describing: type(of: self)).components(separatedBy: ".").first ?? ""
    }
    static var nibName: String {
        return identifier
    }
    static var nib: UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
}

extension SingleReuseIdentifier where Self: UITableViewHeaderFooterView {
    static var identifier: String {
        return String(describing: type(of: self)).components(separatedBy: ".").first ?? ""
    }
    static var nibName: String {
        return identifier
    }
    static var nib: UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
}
