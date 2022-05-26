//
//  MultipleEventView.swift
//  whatson
//
//  Created by Alex Curran on 22/05/2022.
//  Copyright © 2022 Alex Curran. All rights reserved.
//

import SwiftUI
import Core
import MapKit

struct MultipleEventView: View {
    
    let events: [EventCalendarItem]
    @State var contentSize: CGSize = .zero
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .top) {
                ForEach(events, id: \.eventId) { event in
                    DetailsCard2(calendarItem: event) { coordinate in
                        let item = MKMapItem(placemark: MKPlacemark(placemark: coordinate))
                        item.openInMaps(launchOptions: [:])
                    }
                    .if(!contentSize.width.isZero) {
                        $0.frame(width: 0.8 * contentSize.width)
                    }
                    
                }
            }.padding(.bottom, 4)
                .padding([.leading, .trailing])
        }
        .overlay {
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        contentSize = geo.size
                    }
            }
        }
    }
}
