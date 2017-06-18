//
//  ImagePanViewController.swift
//  SwiftImagePan
//
//  Created by Travis Ma on 7/9/15.
//  Copyright (c) 2015 Travis Ma. All rights reserved.
//

import UIKit
import CoreMotion

class ImagePanScrollBarView: UIView {
    
    var scrollBarLayer = CAShapeLayer()
    
    func setEdgeInsets(edgeInsets: UIEdgeInsets) {
        let scrollBarPath = UIBezierPath()
        scrollBarPath.move(to: CGPoint(x: edgeInsets.left, y: self.bounds.height - edgeInsets.bottom))
        scrollBarPath.addLine(to: CGPoint(x: self.bounds.width - edgeInsets.right, y: self.bounds.height - edgeInsets.bottom))
        let scrollBarBackgroundLayer = CAShapeLayer()
        scrollBarBackgroundLayer.path = scrollBarPath.cgPath
        scrollBarBackgroundLayer.lineWidth = 1
        scrollBarBackgroundLayer.strokeColor = UIColor.white.withAlphaComponent(0.1).cgColor
        scrollBarBackgroundLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(scrollBarBackgroundLayer)
        scrollBarLayer.path = scrollBarPath.cgPath
        scrollBarLayer.lineWidth = 1
        scrollBarLayer.strokeColor = UIColor.white.cgColor
        scrollBarLayer.fillColor = UIColor.clear.cgColor
        scrollBarLayer.actions = [
            "strokeStart": NSNull(),
            "strokeEnd": NSNull()
        ]
        self.layer.addSublayer(scrollBarLayer)
    }
    
    func updateWithScrollAmount(scrollAmount: CGFloat, scrollableWidth: CGFloat, scrollableArea: CGFloat) {
        scrollBarLayer.strokeStart = scrollAmount * scrollableArea
        scrollBarLayer.strokeEnd = (scrollAmount * scrollableArea) + scrollableWidth
    }
    
}

class ImagePanViewController: UIViewController {

    var motionManager = CMMotionManager()
    var displayLink: CADisplayLink?
    var panningScrollView = UIScrollView()
    var panningImageView = UIImageView()
    var scrollBarView = ImagePanScrollBarView()
    var isMotionBasedPanEnabled = true
    let kMovementSmoothing: TimeInterval = 0.3
    let kAnimationDuration: TimeInterval = 0.3
    let kRotationMultiplier: CGFloat = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        panningScrollView.frame = self.view.bounds
        panningScrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        panningScrollView.backgroundColor = UIColor.black
        panningScrollView.delegate = self
        panningScrollView.isScrollEnabled = false
        panningScrollView.alwaysBounceVertical = false
        panningScrollView.maximumZoomScale = 2
        panningScrollView.pinchGestureRecognizer!.addTarget(self, action: #selector(ImagePanViewController.pinchGestureRecognized))
        self.view.addSubview(panningScrollView)
        panningImageView.frame = self.view.bounds
        panningImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        panningImageView.backgroundColor = UIColor.black
        panningImageView.contentMode = .scaleAspectFit
        panningScrollView.addSubview(panningImageView)
        scrollBarView.frame = self.view.bounds
        scrollBarView.setEdgeInsets(edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 100, right: 10))
        scrollBarView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollBarView.isUserInteractionEnabled = false
        self.view.addSubview(scrollBarView)
        displayLink = CADisplayLink(target: self, selector: #selector(ImagePanViewController.displayLinkUpdate))
        displayLink!.add(to: RunLoop.main, forMode: .commonModes)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImagePanViewController.toggleMotionBasedPan))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        motionManager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: {
            motion, error in
            self.calculateRotationBasedOnDeviceMotionRotationRate(motion: motion!)
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        displayLink!.invalidate()
        motionManager.stopDeviceMotionUpdates()
    }
    
    func configure(withImage image: UIImage) {
        panningImageView.image = image
        updateScrollViewZoomToMaximumForImage(image: image)
    }
    
    func calculateRotationBasedOnDeviceMotionRotationRate(motion: CMDeviceMotion) {
        if isMotionBasedPanEnabled {
            let xRotationRate = motion.rotationRate.x
            let yRotationRate = motion.rotationRate.y
            let zRotationRate = motion.rotationRate.z
            if (fabs(yRotationRate) > (fabs(xRotationRate) + fabs(zRotationRate))) {
                let invertedYRotationRate = CGFloat(yRotationRate * -1)
                let zoomScale = maximumZoomScaleForImage(image: panningImageView.image!)
                let interpretedXOffset = panningScrollView.contentOffset.x + (invertedYRotationRate * zoomScale * kRotationMultiplier)
                let contentOffset = clampedContentOffsetForHorizontalOffset(horizontalOffset: interpretedXOffset)
                UIView.animate(withDuration: kMovementSmoothing, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction, .curveEaseOut], animations: {
                    self.panningScrollView.setContentOffset(contentOffset, animated: false)
                }, completion: nil)
            }
        }
    }
    
    func maximumZoomScaleForImage(image: UIImage) -> CGFloat {
        return (panningScrollView.bounds.height / panningScrollView.bounds.width) * (image.size.width / image.size.height)
    }
    
    func clampedContentOffsetForHorizontalOffset(horizontalOffset: CGFloat) -> CGPoint {
        let maximumXOffset = panningScrollView.contentSize.width - panningScrollView.bounds.width
        let minimumXOffset = 0
        let clampedXOffset = fmaxf(Float(minimumXOffset), Float(fmin(horizontalOffset, maximumXOffset)))
        return CGPoint(x: CGFloat(clampedXOffset), y: panningScrollView.contentOffset.y)
    }
    
    func displayLinkUpdate() {
        let panningImageViewPresentationLayer = panningImageView.layer.presentation()!
        let panningScrollViewPresentationLayer = panningScrollView.layer.presentation()!
        let horizontalContentOffset = panningScrollViewPresentationLayer.bounds.origin.x
        let contentWidth = panningImageViewPresentationLayer.frame.width
        let visibleWidth = panningScrollView.bounds.width
        let clampedXOffsetAsPercentage = fmax(0, fmin(1, horizontalContentOffset / (contentWidth - visibleWidth)))
        let scrollBarWidthPercentage = visibleWidth / contentWidth
        let scrollableAreaPercentage = 1.0 - scrollBarWidthPercentage
        scrollBarView.updateWithScrollAmount(scrollAmount: clampedXOffsetAsPercentage, scrollableWidth: scrollBarWidthPercentage, scrollableArea: scrollableAreaPercentage)
    }
    
    func toggleMotionBasedPan() {
        isMotionBasedPanEnabled = !isMotionBasedPanEnabled
        UIView.animate(withDuration: kAnimationDuration, animations: {
            self.updateViewsForMotionBasedPanEnabled(motionBasedPanEnabled: self.isMotionBasedPanEnabled)
        }, completion:nil)
    }
    
    func updateViewsForMotionBasedPanEnabled(motionBasedPanEnabled: Bool) {
        if motionBasedPanEnabled {
            updateScrollViewZoomToMaximumForImage(image: panningImageView.image!)
            panningScrollView.isScrollEnabled = false
        } else {
            panningScrollView.maximumZoomScale = 3
            panningScrollView.zoomScale = 1
            panningScrollView.isScrollEnabled = true
        }
    }
    
    func updateScrollViewZoomToMaximumForImage(image: UIImage) {
        let zoomScale = maximumZoomScaleForImage(image: image)
        panningScrollView.maximumZoomScale = zoomScale
        panningScrollView.zoomScale = zoomScale
    }
    
    func pinchGestureRecognized() {
        isMotionBasedPanEnabled = false
        panningScrollView.isScrollEnabled = true
    }

}

extension ImagePanViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return panningImageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollView.setContentOffset(clampedContentOffsetForHorizontalOffset(horizontalOffset: scrollView.contentOffset.x), animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollView.setContentOffset(clampedContentOffsetForHorizontalOffset(horizontalOffset: scrollView.contentOffset.x), animated: true)
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollView.setContentOffset(clampedContentOffsetForHorizontalOffset(horizontalOffset: scrollView.contentOffset.x), animated:true)
    }
    
}
