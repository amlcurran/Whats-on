//
//  UIActivityView.swift
//  whatson
//
//  Created by Alex Curran on 14/05/2022.
//  Copyright © 2022 Alex Curran. All rights reserved.
//

import SwiftUI

struct UIActivityView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIActivityViewController
    let url: URL
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [url], applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
    
}
