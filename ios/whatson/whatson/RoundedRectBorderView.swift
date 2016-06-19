//
//  RoundedRectBorderView.swift
//  whatson
//
//  Created by Alex on 14/02/2016.
//  Copyright © 2016 Alex Curran. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedRectBorderView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
    didSet {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = cornerRadius > 0
    }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }

}
