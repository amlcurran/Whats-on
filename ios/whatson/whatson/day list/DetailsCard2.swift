//
//  DetailsCard2.swift
//  whatson
//
//  Created by Alex Curran on 28/02/2022.
//  Copyright © 2022 Alex Curran. All rights reserved.
//

import SwiftUI
import MapKit
import Core

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
    
    typealias ViewState = EventCalendarItem
    
    struct Location: Equatable {
        let location: String
        let coordinate: CLLocationCoordinate2D?
    }
    
    @State var viewState: ViewState
    @State var isExpanded: Bool = false
    @State var placemark: CLPlacemark?
    let onMapTapped: (CLPlacemark) -> Void
    
    private let geocoder = CLGeocoder()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewState.title)
                        .labelStyle(.header)
                    if isExpanded {
                        Text("From " + viewState.startTime.formatted(date: .omitted, time: .shortened) + " to " + viewState.endTime.formatted(date: .omitted, time: .shortened))
                            .labelStyle(.lower)
                    } else {
                        Text("From " + viewState.startTime.formatted(date: .omitted, time: .shortened))
                            .labelStyle(.lower)
                    }
                }
            }
            .padding([.leading, .top, .trailing])
            if isExpanded {
                if let location = viewState.location {
                    Text(location)
                        .labelStyle(.lower)
                        .padding([.leading, .trailing])
                }
                if let placemark = placemark {
                    DetailMap(placemark: placemark)
                        .onTapGesture {
                            onMapTapped(placemark)
                        }
                        .padding(.top, 4)
                } else {
                    HStack {
                        
                    }
                    .frame(height: 8)
                }
            } else {
                HStack {
                    
                }
                .frame(height: 8)
            }
        }
        .privacySensitive()
        .frame(maxWidth: .infinity, alignment: .leading)
        .animation(.easeInOut.speed(3), value: placemark)
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
                    self.placemark = geocoded.first
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
                viewState: .init(eventId: "def",
                                 title: "Foo",
                                 location: "Tate Modern",
                                 startTime: Date(),
                                 endTime: Date().addingTimeInterval(60 * 60)),
                isExpanded: true, placemark: nil
            ) { _ in }
            DetailsCard2(
                viewState: .init(eventId: "abc",
                                 title: "Foo",
                                 location: "Tate Modern",
                                 startTime: Date(),
                                 endTime: Date().addingTimeInterval(60 * 60)),
                placemark: nil
            ) { _ in }
            Spacer(minLength: 0)
        }
        .padding()
        .background(Color.green.opacity(0.2))
//        .preferredColorScheme(.dark)
    }
}
