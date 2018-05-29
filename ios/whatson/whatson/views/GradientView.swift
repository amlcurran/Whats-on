//
//  GradientView.swift
//  whatson
//
//  Created by Alex Curran on 08/06/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import UIKit

class GradientView: UIView {

    let gradient = CAGradientLayer()

    var locations: [NSNumber] {
        get {
            return gradient.locations.or([])
        }
        set {
            gradient.locations = newValue
        }
    }

    var colors: [UIColor] {
        get {
            //swiftlint:disable force_cast
            return gradient.colors.or([]).compactMap { UIColor(cgColor: ($0 as! CGColor)) }
        }
        set {
            gradient.colors = newValue.map { $0.cgColor }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(gradient)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradient.frame = bounds
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
    }

}
