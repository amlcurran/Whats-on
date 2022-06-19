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
import Contacts
import ContactsUI

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude
    }
    
    
}

struct Foo: Identifiable {
    var id: String
}

extension CNContact: Identifiable {
    
    public var id: String {
        identifier
    }
    
}

struct DetailsCard2: View {
    
    struct Location: Equatable {
        let location: String
        let coordinate: CLLocationCoordinate2D?
    }
    
    let calendarItem: EventCalendarItem
    @State var isExpanded: Bool = false
    @State var placemark: CLPlacemark?
    @State var selectedContact: CNContact?
    @State var isShowingEvent = false
    let onMapTapped: (CLPlacemark) -> Void
    
    private let geocoder = CLGeocoder()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(calendarItem.title)
                        .labelStyle(.header)
                    if isExpanded {
                        Text("From " + calendarItem.startTime.formatted(date: .omitted, time: .shortened) + " to " + calendarItem.endTime.formatted(date: .omitted, time: .shortened))
                            .labelStyle(.lower)
                    } else {
                        Text("From " + calendarItem.startTime.formatted(date: .omitted, time: .shortened))
                            .labelStyle(.lower)
                    }
                }
//                if isExpanded {
                    Spacer(minLength: 8)
                    ZStack {
                        ForEach(Array(calendarItem.attendees.enumerated()), id: \.element) { (index, attendee) in
                            ContactBadge(attendee: attendee)
                            .offset(x: -CGFloat(index * 16))
                            .onTapGesture {
                                selectedContact = try? CNContactStore().unifiedContact(withIdentifier: attendee.identifier, keysToFetch: [CNContactViewController.descriptorForRequiredKeys()])
                                
                            }
                    }
                    }
//                }
            }
            .padding([.leading, .top, .trailing])
            if isExpanded {
                if let location = calendarItem.location {
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
        .contextMenu {
            Button {
                isShowingEvent = true
            } label: {
                Label("Show full event", systemImage: "arrow.up.forward.square")
            }
        }
        .sheet(item: $selectedContact) { contact in
            ContactView(contact: contact)
        }
        .sheet(isPresented: $isShowingEvent) {
            EKEventView(event: calendarItem.event)
        }
    }
    
    func showMoreDetails() {
        Task {
            if let location = calendarItem.location {
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

//struct DetailsCard2_Previews: PreviewProvider {
//    static var previews: some View {
//        VStack {
//            DetailsCard2(
//                calendarItem: .init(
//                    eventId: "def",
//                    title: "Foo",
//                    location: "Tate Modern",
//                    startTime: Date(),
//                    endTime: Date().addingTimeInterval(60 * 60),
//                    attendees: [
//                        Attendee(identifier: "contacts://joeBloggs", givenName: "Joe",
//                                 familyName: "Bloggs"),
//                        Attendee(identifier: "contacts://joeFloggs", givenName: "Joe",
//                                 familyName: "Floggs")
//                    ],),
//                isExpanded: true,
//                placemark: nil
//            ) { _ in }
//            DetailsCard2(
//                calendarItem: .init(
//                    eventId: "abc",
//                    title: "Foo",
//                    location: "Tate Modern",
//                    startTime: Date(),
//                    endTime: Date().addingTimeInterval(60 * 60),
//                    attendees: [
//                        Attendee(identifier: "contacts://joeBloggs",
//                                 givenName: "Joe",
//                                 familyName: "Bloggs")
//                    ]),
//                placemark: nil
//            ) { _ in }
//            Spacer(minLength: 0)
//        }
//        .padding()
//        .background(Color.green.opacity(0.2))
//        .previewDevice("iPhone 13 mini")
////        .preferredColorScheme(.dark)
//    }
//}
