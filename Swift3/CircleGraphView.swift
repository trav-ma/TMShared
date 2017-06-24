//
//  CircleGraphView.swift
//  ThreeBite
//
//  Created by Travis Ma on 7/26/15.
//  Copyright (c) 2015 Travis Ma. All rights reserved.
//

import UIKit

class CircleGraphView: UIView {
    var circles = [CAShapeLayer]()
    var percent1: CGFloat = 0
    var percent2: CGFloat = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }

    func degreesToRadians(_ degrees: CGFloat) -> CGFloat {
        return degrees * CGFloat(Double.pi) / 180.0
    }

    func drawCircleGraph(percents: [CGFloat], colors: [UIColor], thickness: CGFloat = 3) {
        for circle in circles {
            circle.removeFromSuperlayer()
        }
        circles = []
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = max(bounds.width, bounds.height)
        var total: CGFloat = 0
        var degrees = [CGFloat]()
        for percent in percents {
            total += percent
            degrees.append(360.0 * (CGFloat(percent) * 0.01))
        }
        if total > 100 {
            return
        }
        if total < 100 {
            degrees.append(360.0 * (CGFloat(100 - total) * 0.01))
        }
        let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawAnimation.fromValue = 0.0
        drawAnimation.toValue = 1.0
        drawAnimation.duration = 1.0
        drawAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        var startDegree: CGFloat = 0
        for index in 0 ..< degrees.count {
            let degree = degrees[index]
            let circle = CAShapeLayer()
            circle.path = UIBezierPath(arcCenter: center, radius: radius/2 - thickness/2, startAngle: degreesToRadians(startDegree), endAngle: degreesToRadians(startDegree + degree), clockwise: true).cgPath
            startDegree += degree
            circle.fillColor = UIColor.clear.cgColor
            if index < colors.count {
                circle.strokeColor = colors[index].cgColor
            } else {
                circle.strokeColor = UIColor.lightGray.cgColor
            }
            circle.lineWidth = thickness
            self.layer.addSublayer(circle)
            circle.add(drawAnimation, forKey: "drawCircleAnimation")
            circles.append(circle)
        }
    }

}
