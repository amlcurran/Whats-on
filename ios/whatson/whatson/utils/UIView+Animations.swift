//
//  UIView+Animations.swift
//  whatson
//
//  Created by Alex Curran on 02/07/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import UIKit

extension UIView {

    func animateAlpha(to alpha: Float, onEnd: @escaping (UIView) -> Void) {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = CGFloat(alpha)
        }, completion: { _ in onEnd(self) })
    }

}
