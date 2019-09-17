//
//  SlidingPickerView.swift
//  TMShared
//
//  Created by Travis Ma on 9/17/19.
//  Copyright © 2019 Travis Ma. All rights reserved.
//

import UIKit

protocol LeftEdgeSlidingPickerViewDelegate {
    func leftEdgeSlidingPickerDidSelect(index: Int)
}

class LeftEdgeSlidingPickerView: UIView {
    private var slidingView = UIView()
    private var stackView = UIStackView()
    private var constraintSlidingViewWidth: NSLayoutConstraint?
    private var valueButtons = [UIButton]()
    var currentIndex: Int = 0
    var delehgate: LeftEdgeSlidingPickerViewDelegate?
    private let kSlidingViewOffScreenAmount: CGFloat = 40
    private let kLeftPaddingToFirstButton: CGFloat = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit(frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit(self.frame)
    }
    
    func commonInit(_ frame: CGRect) {
        self.clipsToBounds = true
        self.backgroundColor = .clear
        self.addSubview(slidingView)
        slidingView.layer.cornerRadius = frame.height / 2
        slidingView.translatesAutoresizingMaskIntoConstraints = false
        slidingView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -(kSlidingViewOffScreenAmount)).isActive = true
        slidingView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        slidingView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        constraintSlidingViewWidth = slidingView.widthAnchor.constraint(equalToConstant: kSlidingViewOffScreenAmount + kLeftPaddingToFirstButton)
        constraintSlidingViewWidth?.isActive = true
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
    }
    
    /// Sets up LeftEdgeSlidingPickerView for usage, works best with small values (numbers) at roughly7 max
    /// - Parameter sliderColor: color of the selection slider
    /// - Parameter values: can be either  UIImage anything convertable to String via "\(value)"
    /// - Parameter font: font for the values
    /// - Parameter selectedValueColor: color of the value inside of the selection slider
    func setup(sliderColor: UIColor, values: [Any], font: UIFont? = nil, selectedValueColor: UIColor? = nil) {
        slidingView.backgroundColor = sliderColor
        valueButtons = []
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
        }
        for idx in 0 ..< values.count {
            let btn = UIButton()
            if let img = values[idx] as? UIImage {
                btn.setImage(img, for: .normal)
            } else {
                btn.setTitle("\(values[idx])", for: .normal)
            }
            btn.tintColor = .label
            btn.setTitleColor(.label, for: .normal)
            if let font = font {
                btn.titleLabel?.font = font
            }
            if let selectedValueColor = selectedValueColor {
                btn.setTitleColor(selectedValueColor, for: .selected)
            }
            btn.tag = idx
            btn.addTarget(self, action:#selector(self.buttonClicked(_:)), for: .touchUpInside)
            valueButtons.append(btn)
            stackView.addArrangedSubview(btn)
        }
    }
    
    func updateUI() {
        for btn in valueButtons {
            btn.isSelected = btn.tag <= currentIndex
        }
        let btn = valueButtons[currentIndex]
        constraintSlidingViewWidth?.constant = btn.frame.origin.x + kSlidingViewOffScreenAmount + btn.frame.width + kLeftPaddingToFirstButton
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil )
    }
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        currentIndex = sender.tag
        delehgate?.leftEdgeSlidingPickerDidSelect(index: currentIndex)
        updateUI()
    }
}
