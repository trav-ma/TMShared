//
//  SpiralCircleGraphView.swift
//  OCE
//
//  Created by Travis Ma on 8/30/17.
//  Copyright © 2017 QIMS. All rights reserved.
//

import UIKit

class SpiralGraphView: UIView {
    var circles = [CAShapeLayer]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }
    
    func degreesToRadians(_ degrees: CGFloat) -> CGFloat {
        return degrees * CGFloat(Double.pi) / 180.0
    }
    
    //Example percents value [23.4, 35.7, 10.2]
    func drawSpiralGraph(percents: [CGFloat], colors: [UIColor], thickness: CGFloat = 10) {
        for circle in circles {
            circle.removeFromSuperlayer()
        }
        circles = []
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        var degrees = [CGFloat]()
        for percent in percents {
            degrees.append(360.0 * (CGFloat(percent) * 0.01))
        }
        let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawAnimation.fromValue = 0.0
        drawAnimation.toValue = 1.0
        drawAnimation.duration = 1.0
        drawAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        var radius: CGFloat = max(bounds.width, bounds.height)
        for index in 0 ..< degrees.count {
            let degree = degrees[index]
            let circle = CAShapeLayer()
            circle.path = UIBezierPath(arcCenter: center, radius: radius/2 - thickness/2,
                                       startAngle: degreesToRadians(-90),
                                       endAngle: degreesToRadians(degree - 90),
                                       clockwise: true).cgPath
            circle.fillColor = UIColor.clear.cgColor
            circle.lineCap = kCALineCapRound
            if index < colors.count {
                circle.strokeColor = colors[index].cgColor
            } else {
                circle.strokeColor = UIColor.lightGray.cgColor
            }
            circle.lineWidth = thickness
            self.layer.addSublayer(circle)
            circle.add(drawAnimation, forKey: "drawCircleAnimation")
            circles.append(circle)
            radius -= (thickness * 2)
        }
    }

}
