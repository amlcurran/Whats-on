//
//  View+Snapshot.swift
//  whatson
//
//  Created by Alex Curran on 16/05/2022.
//  Copyright © 2022 Alex Curran. All rights reserved.
//

import SwiftUI

extension View {
    func snapshot(withWidth width: Int? = nil) -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        var targetSize = controller.view.intrinsicContentSize
        if let width = width {
            targetSize.width = CGFloat(width)
        }
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
