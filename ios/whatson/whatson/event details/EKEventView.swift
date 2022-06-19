//
//  EKEventView.swift
//  whatson
//
//  Created by Alex Curran on 19/06/2022.
//  Copyright © 2022 Alex Curran. All rights reserved.
//

import EventKitUI
import SwiftUI

struct EKEventView: UIViewControllerRepresentable {
    typealias UIViewControllerType = EKEventViewController
    
    let event: EKEvent
    
    func makeUIViewController(context: Context) -> EKEventViewController {
        EKEventViewController(showing: event, delegate: nil)
    }
    
    func updateUIViewController(_ uiViewController: EKEventViewController, context: Context) {
        
    }
    
    
}
