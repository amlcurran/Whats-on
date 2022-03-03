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

struct Foo: Identifiable {
    var id: String
}

struct DetailsCard2: View {
    
    typealias ViewState = Event
    
    struct Location: Equatable {
        let location: String
        let coordinate: CLLocationCoordinate2D?
    }
    
    @State var viewState: ViewState
    @State var isExpanded: Bool = false
    @State var coordinate: CLLocationCoordinate2D?
    let onMapTapped: (MKCoordinateRegion) -> Void
    
    private let geocoder = CLGeocoder()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewState.title)
                        .labelStyle(.header)
                    if isExpanded {
                        Text("From " + viewState.startDate.formatted(date: .omitted, time: .shortened) + " to " + viewState.endDate.formatted(date: .omitted, time: .shortened))
                            .labelStyle(.lower)
                    } else {
                        Text("From " + viewState.startDate.formatted(date: .omitted, time: .shortened))
                            .labelStyle(.lower)
                    }
                }
            }
            .padding()
            if isExpanded {
                if let location = viewState.location {
                    Text(location)
                        .labelStyle(.lower)
                        .padding(.horizontal)
                        .padding(.bottom, 4)
                }
                if let coordinate = coordinate {
                    Map(coordinateRegion: .constant(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))), annotationItems: [Foo(id: "abc")], annotationContent: { _ in
                        MapMarker(coordinate: coordinate, tint: .pink)
                    })
                        .frame(height: 160)
                        .onTapGesture {
                            onMapTapped(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)))
                        }
                }
            }
        }
        .privacySensitive()
        .frame(maxWidth: .infinity, alignment: .leading)
        .animation(.easeInOut.speed(3), value: coordinate)
        .background {
            Rectangle()
                .fill(Color("surface"))
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: .black.opacity(0.1), radius: 2, x: 1, y: 2)
        .onTapGesture {
            withAnimation(.easeInOut.speed(2)) {
                isExpanded.toggle()
            }
            showMoreDetails()
        }
    }
    
    func showMoreDetails() {
        Task {
            if let location = viewState.location {
                do {
                    let geocoded = try await geocoder.geocodeAddressString(location)
                    withAnimation(.easeInOut.speed(2)) {
                    self.coordinate = geocoded.first?.location?.coordinate
                    }
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
                isExpanded: true, coordinate: CLLocationCoordinate2D(latitude: 51.5675456, longitude: -0.105891)
            ) { _ in }
            DetailsCard2(
                viewState: .init(title: "Foo",
                                 location: "Tate Modern", startDate: Date(), endDate: Date().addingTimeInterval(60 * 60)),
                coordinate: nil
            ) { _ in }
            Spacer(minLength: 0)
        }
        .padding()
        .background(Color.green.opacity(0.2))
//        .preferredColorScheme(.dark)
    }
}
