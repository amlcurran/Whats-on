//
//  PresenterEventList.swift
//  whatson
//
//  Created by Alex Curran on 14/05/2022.
//  Copyright © 2022 Alex Curran. All rights reserved.
//

import SwiftUI
import Core

struct PresenterEventList: View {
    
    @ObservedObject var presenter: WhatsOnPresenter
    private let feedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        EventList(slots: $presenter.events,
                  redaction: $presenter.redaction) { event in
            presenter.remove(event)
            feedback.notificationOccurred(.success)
        }
            .onAppear {
                presenter.beginPresenting()
            }
            .onDisappear {
                presenter.stopPresenting()
            }
    }
    
}
