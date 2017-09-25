//
//  DotSequenceView.swift
//  OCE
//
//  Created by Travis Ma on 9/19/17.
//  Copyright © 2017 QIMS. All rights reserved.
//

import UIKit

class DotSequenceView: UIView {
    var line: UIView?
    var circles = [UIView]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }
    
    func drawDotSequence(fillCount: Int, totalCount: Int, fillColor: UIColor?, emptyColor: UIColor?) {
        for circle in circles {
            circle.removeFromSuperview()
        }
        circles = []
        if line == nil {
            line = UIView(frame: CGRect(x: 10, y: self.frame.height / 2 - 1, width: self.frame.width - 20, height: 2))
        }
        if let line = line {
            let colorFill = fillColor ?? .white
            let colorEmpty = emptyColor ?? .lightGray
            line.backgroundColor = colorFill
            self.addSubview(line)
            let padding = (line.frame.width - self.frame.height) / CGFloat(totalCount - 1) - self.frame.height
            var offset: CGFloat = line.frame.minX
            for i in 0 ..< totalCount {
                let circle = UIView(frame: CGRect(x: offset, y: 0, width: self.frame.height, height: self.frame.height))
                circle.layer.cornerRadius = circle.frame.width / 2
                if i < fillCount {
                    circle.backgroundColor = colorFill
                } else {
                    circle.backgroundColor = colorEmpty
                    circle.layer.borderColor = colorFill.cgColor
                    circle.layer.borderWidth = 2
                }
                circle.alpha = 0
                self.addSubview(circle)
                circles.append(circle)
                offset += circle.frame.width + padding
            }
            animateCircles()
        }
    }
    
    func animateCircles() {
        if let lastCircle = circles.last {
            for i in 0 ..< circles.count {
                let circle = circles[i]
                let targetFrame = circle.frame
                circle.frame = lastCircle.frame
                UIView.animate(withDuration: 0.6, delay: Double(i) * 0.4, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    circle.alpha = 1
                    circle.frame = targetFrame
                }, completion: nil)
            }
        }
    }
    
}
