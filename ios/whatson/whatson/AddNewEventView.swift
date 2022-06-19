//
//  AddNewEventView.swift
//  whatson
//
//  Created by Alex Curran on 26/05/2022.
//  Copyright © 2022 Alex Curran. All rights reserved.
//

import SwiftUI
import Core
import MapKit

struct AddNewEventView: View {
    
    private let geocoder = CLGeocoder()
    @State var eventName: String = ""
    @State var location: String = ""
    @State var loadedResults: [CLPlacemark] = []
    @State var pickedCalendar: EventCalendar.ID?
    @State var loadedCalendars: [EventCalendar] = []
    
    var body: some View {
        List {
            TextField("Event name", text: $eventName)
            TextField("Location", text: $location)
                .onChange(of: location) { newValue in
                    Task {
                        loadedResults = try await geocoder.geocodeAddressString(newValue)
                        eventName = "\(loadedResults.count)"
                    }
                }
            if !loadedResults.isEmpty {
                List {
                    ForEach(loadedResults, id: \.id) {
                        Text($0.name ?? "Blank")
                    }
                }
                .listStyle(.plain)
            }
            Picker(selection: $pickedCalendar) {
                ForEach(loadedCalendars) {
                    Text($0.name)
                        .tag(Optional.some($0.id))
                }
            } label: {
                Text("Calendar")
            }
        }
        .animation(.easeInOut.speed(2), value: loadedResults)
        .toolbar {
            ToolbarItem {
                Button("More options") {
                    
                }
            }
        }
        .navigationTitle("Add new event")
    }
}

struct AddNewEventView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddNewEventView(
                loadedCalendars:
                    (0..<3).map {
                    EventCalendar(name: "Foo \($0)", account: "Foo", id: EventCalendar.Id(rawValue: "foo\($0)"), included: true, editable: true)
                    }
                
            )
        }
    }
}
