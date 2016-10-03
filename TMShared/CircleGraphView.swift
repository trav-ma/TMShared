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

    func degreesToRadians(_ degrees: CGFloat) -> CGFloat {
        return degrees * CGFloat(M_PI) / 180.0
    }
    
    override func draw(_ rect: CGRect) {
        let p1 = 360.0 * (CGFloat(percent1) * 0.01)
        let p2 = 360.0 * (CGFloat(percent2) * 0.01)
        
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = max(bounds.width, bounds.height)
        let arcWidth: CGFloat = 3
        
        let circle1 = CAShapeLayer()
        circle1.path = UIBezierPath(arcCenter: center, radius: radius/2 - arcWidth/2, startAngle: degreesToRadians(0), endAngle: degreesToRadians(p1), clockwise: true).cgPath
        circle1.fillColor = UIColor.clear.cgColor
        circle1.strokeColor = colorTint.cgColor
        circle1.lineWidth = arcWidth
        self.layer.addSublayer(circle1)
        let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawAnimation.fromValue = 0.0
        drawAnimation.toValue = 1.0
        drawAnimation.duration = 1.0
        drawAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        circle1.add(drawAnimation, forKey: "drawCircleAnimation")
        
        let circle2 = CAShapeLayer()
        circle2.path = UIBezierPath(arcCenter: center, radius: radius/2 - arcWidth/2, startAngle: degreesToRadians(p1), endAngle: degreesToRadians(p1 + p2), clockwise: true).cgPath
        circle2.fillColor = UIColor.clear.cgColor
        circle2.strokeColor = colorOrange.cgColor
        circle2.lineWidth = arcWidth
        self.layer.addSublayer(circle2)
        circle2.add(drawAnimation, forKey: "drawCircleAnimation")
        
        let circle3 = CAShapeLayer()
        circle3.path = UIBezierPath(arcCenter: center, radius: radius/2 - arcWidth/2, startAngle: degreesToRadians(p1 + p2), endAngle: degreesToRadians(360), clockwise: true).cgPath
        circle3.fillColor = UIColor.clear.cgColor
        circle3.strokeColor = colorRed.cgColor
        circle3.lineWidth = arcWidth
        self.layer.addSublayer(circle3)
        circle3.add(drawAnimation, forKey: "drawCircleAnimation")
    }

}

//usage
//circleGraphView.percent1 = goodPercent
//circleGraphView.percent2 = badPercent
//circleGraphView.setNeedsDisplay()
