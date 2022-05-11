//
//  ContactView.swift
//  whatson
//
//  Created by Alex Curran on 08/05/2022.
//  Copyright © 2022 Alex Curran. All rights reserved.
//

import SwiftUI
import ContactsUI

struct ContactView: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator(viewController: dismiss)
    }
    
    typealias UIViewControllerType = CNContactViewController
    
    let contact: CNContact
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> CNContactViewController {
        let controller = CNContactViewController(for: contact)
        controller.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: context.coordinator, action: #selector(context.coordinator.didTapClose))
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CNContactViewController, context: Context) {
        
    }
    
    class Coordinator {
        internal init(viewController: DismissAction) {
            self.viewController = viewController
        }
        
        let viewController: DismissAction
        
        @objc
        func didTapClose() {
            viewController()
        }
    }
}
