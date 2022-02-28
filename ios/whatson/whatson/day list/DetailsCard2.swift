//
//  DetailsCard2.swift
//  whatson
//
//  Created by Alex Curran on 28/02/2022.
//  Copyright © 2022 Alex Curran. All rights reserved.
//

import SwiftUI
import MapKit

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude
    }
    
    
}

struct DetailsCard2: View {
    
    typealias ViewState = Event
    
    struct Location: Equatable {
        let location: String
        let coordinate: CLLocationCoordinate2D?
    }
    
    @State var viewState: ViewState {
        didSet {
            if let location = viewState.location {
                self.location = Location(location: location, coordinate: nil)
            } else {
                self.location = nil
            }
        }
    }
    @State var location: Location?
    
    private let geocoder = CLGeocoder()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
            Text(viewState.title)
                .labelStyle(.header)
            Text("From " + viewState.startDate.formatted(date: .omitted, time: .shortened) + " to " + viewState.endDate.formatted(date: .omitted, time: .shortened))
                .labelStyle(.lower)
            }
            .padding()
            if let location = location {
                Text(location.location)
                    .labelStyle(.lower)
                    .padding(.horizontal)
                if let coordinate = location.coordinate {
                    Map(coordinateRegion: .constant(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))))
                        .frame(maxHeight: 160)
                }
            }
        }
        .animation(.easeInOut.speed(3), value: location)
        .background {
            Rectangle()
                .fill(Color("surface"))
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .task {
            if let location = location {
                do {
                    try await geocoder.geocodeAddressString(location.location)
                } catch {
                    print(error)
                }
            }
        }
    }
}

struct DetailsCard2_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DetailsCard2(
                viewState: .init(title: "Foo",
                                 location: "Tate Modern", startDate: Date(), endDate: Date().addingTimeInterval(60 * 60)),
                location: DetailsCard2.Location(location: "Tate Modern", coordinate: CLLocationCoordinate2D(latitude: 51.5675456, longitude: -0.105891))
            )
            DetailsCard2(
                viewState: .init(title: "Foo",
                                 location: "Tate Modern", startDate: Date(), endDate: Date().addingTimeInterval(60 * 60)),
                location: nil
            )
        }
        .preferredColorScheme(.dark)
    }
}
