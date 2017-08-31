//
//  SpiralCircleGraphView.swift
//  OCE
//
//  Created by Travis Ma on 8/30/17.
//  Copyright © 2017 QIMS. All rights reserved.
//

import UIKit

class SpiralGraphView: UIView {
    fileprivate var circles = [CAShapeLayer]()
    fileprivate var baseLayer: CAShapeLayer?
    fileprivate var drawAnimation: CABasicAnimation = {
        let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawAnimation.fromValue = 0.0
        drawAnimation.toValue = 1.0
        drawAnimation.duration = 1.0
        drawAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        return drawAnimation
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }
    
    fileprivate func degreesToRadians(_ degrees: CGFloat) -> CGFloat {
        return degrees * CGFloat(Double.pi) / 180.0
    }
    
    fileprivate func drawCircleLayer(degree: CGFloat, radius: CGFloat, color: UIColor, thickness: CGFloat, shouldAnimate: Bool = true) -> CAShapeLayer {
        let circle = CAShapeLayer()
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        circle.path = UIBezierPath(arcCenter: center,
                                   radius: radius,
                                   startAngle: degreesToRadians(-90),
                                   endAngle: degreesToRadians(degree - 90),
                                   clockwise: true).cgPath
        circle.fillColor = UIColor.clear.cgColor
        circle.lineCap = kCALineCapRound
        circle.strokeColor = color.cgColor
        circle.lineWidth = thickness
        self.layer.addSublayer(circle)
        if shouldAnimate {
            circle.add(drawAnimation, forKey: "drawCircleAnimation")
        }
        return circle
    }
    
    //Example percents value [23.4, 35.7, 10.2]
    func drawSpiralGraph(percents: [CGFloat], colors: [UIColor], thickness: CGFloat = 10, delay: TimeInterval = 0.5) {
        for circle in circles {
            circle.removeFromSuperlayer()
        }
        circles = []
        var degrees = [CGFloat]()
        for percent in percents {
            degrees.append(360.0 * (CGFloat(percent) * 0.01))
        }
        var radius: CGFloat = max(bounds.width, bounds.height)
        //draw base layer
        if baseLayer == nil {
            let baseColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
            let baseThickness = thickness * CGFloat(percents.count)
            let baseRadius = (radius / 2) - (baseThickness / 2)
            baseLayer = drawCircleLayer(degree: 360,
                                        radius: baseRadius,
                                        color: baseColor,
                                        thickness: baseThickness,
                                        shouldAnimate: false)
        }
        //draw spirals
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            [unowned self] in
            for index in 0 ..< degrees.count {
                var strokeColor = UIColor.lightGray
                if index < colors.count {
                    strokeColor = colors[index]
                }
                let drawRadius = (radius / 2) - (thickness / 2)
                let circle = self.drawCircleLayer(degree: degrees[index],
                                             radius: drawRadius,
                                             color: strokeColor,
                                             thickness: thickness)
                self.circles.append(circle)
                radius -= (thickness * 2)
            }
        }
    }

}
