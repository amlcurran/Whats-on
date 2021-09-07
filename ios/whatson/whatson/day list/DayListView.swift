//
//  DayListView.swift
//  DayListView
//
//  Created by Alex Curran on 06/09/2021.
//  Copyright © 2021 Alex Curran. All rights reserved.
//

import SwiftUI
import Core

struct DayListView: View {

    @ObservedObject var viewModel: DayListViewModel

    var body: some View {
        NavigationView {
            List(viewModel.slots) { slot in
                Day(slot: slot)
            }
            .navigationTitle("What's on")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            viewModel.startLoading()
        }
    }
}

class DayListViewModel: ObservableObject, WhatsOnPresenterView {

    @Published var slots: [CalendarSlot] = []

    let presenter: WhatsOnPresenter

    init(presenter: WhatsOnPresenter) {
        self.presenter = presenter
    }

    func startLoading() {
        presenter.beginPresenting(on: self)
    }

    func showCalendar(_ source: [CalendarSlot]) {
        self.slots = source
    }

    func showAccessFailure() {

    }

    func failedToDelete(_ event: CalendarItem, withError error: Error) {

    }

    func showLoading() {

    }
}
