//
//  LoadingView.swift
//  whatson
//
//  Created by Alex Curran on 02/07/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    private let loadingLayer = LoadingLayer()

    override var isHidden: Bool {
        didSet {
            if isHidden {
                stopSpinning()
            } else {
                startSpinning()
            }
        }
    }

    convenience init(pathColor: UIColor) {
        self.init(frame: .zero)
        loadingLayer.strokeColor = pathColor.cgColor
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(loadingLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        loadingLayer.frame = bounds
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview != nil {
            startSpinning()
        } else {
            stopSpinning()
        }
    }

    private func stopSpinning() {
        loadingLayer.removeAnimation(forKey: "rotation")
    }

    private func startSpinning() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.repeatCount = .infinity
        animation.fromValue = 0
        animation.toValue = 2 * Double.pi
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        loadingLayer.add(animation, forKey: "rotation")
    }

}

private class LoadingLayer: CAShapeLayer {

    override init() {
        super.init()
    }

    override var bounds: CGRect {
        didSet {
            updatePath()
        }
    }

    override var strokeColor: CGColor? {
        didSet {
            updatePath()
        }
    }

    private func updatePath() {
        let wholePath = UIBezierPath(ovalIn: bounds.insetBy(dx: 20, dy: 20))
        path = wholePath.cgPath
        fillColor = UIColor.clear.cgColor
        lineWidth = 8
        strokeStart = 0.0
        strokeEnd = 0.6
        lineCap = convertToCAShapeLayerLineCap("round")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToCAShapeLayerLineCap(_ input: String) -> CAShapeLayerLineCap {
	return CAShapeLayerLineCap(rawValue: input)
}
