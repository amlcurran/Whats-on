//
//  NewEventView.swift
//  NewEventView
//
//  Created by Alex Curran on 13/09/2021.
//  Copyright © 2021 Alex Curran. All rights reserved.
//

import SwiftUI

struct Location: Identifiable {
    let id: String
    let name: String
    let street: String
}

class LocationsLoader: ObservableObject {
    @Published var locations: [Location]

    init(locations: [Location] ) {
        self.locations = locations
    }
}

struct NewEventView: View {

    @State var eventName: String = ""
    @State var location: String = ""
    @ObservedObject var locations: LocationsLoader

    var body: some View {
        VStack {
            Spacer()
            navigationView()
            TextField("Event name", text: $eventName)
                .font(.title)
                .padding(.horizontal)
            HStack {
                Image(systemName: "location.circle")
                    .foregroundColor(.accentColor)
                TextField("Location", text: $location)
            }.padding(.horizontal)
            List(locations.locations) { location in
                VStack(alignment: .leading) {
                    Text(location.name)
                    Text(location.street)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
                .frame(maxHeight: 200)
            Button(action: {

            }) {
                HStack {
                    Spacer()
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                    Text("Add")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                }.padding(.vertical)
            }.frame(width: .infinity)
                .background(ContainerRelativeShape().fill(Color.accentColor)).padding(.horizontal)

        }
        .accentColor(Color("accent"))
        .background(Color("windowBackground"))
    }

    @ViewBuilder
    private func navigationView() -> some View {
        HStack {
            Button("Cancel") {

            }
            Spacer()
        }.padding(.horizontal)
            .frame(minHeight: 44)
    }
}

struct NewEventView_Previews: PreviewProvider {
    static var previews: some View {
        NewEventView(locations: LocationsLoader(locations: [
            Location(id: "one", name: "Fink's Gillespie", street: "32 Gillespie Rd"),
            Location(id: "two", name: "Dempsey's", street: "124 Mountgrove Rd")
        ]))
    }
}
