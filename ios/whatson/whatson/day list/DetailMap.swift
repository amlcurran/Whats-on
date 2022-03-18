//
//  DetailMap.swift
//  whatson
//
//  Created by Alex Curran on 03/03/2022.
//  Copyright © 2022 Alex Curran. All rights reserved.
//

import SwiftUI
import MapKit

struct DetailMap: View {
    
    let placemark: CLPlacemark
    @State var directions: MKDirections.ETAResponse?
    private let formatter: DateComponentsFormatter = {
        let format = DateComponentsFormatter()
        format.allowedUnits = [.hour, .minute]
        format.unitsStyle = .brief
        return format
    }()
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: placemark.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))), annotationItems: [placemark], annotationContent: { _ in
                MapMarker(coordinate: placemark.location!.coordinate, tint: .pink)
            })
            ZStack {
                if let directions = directions {
                    Button {
                        
                    } label: {
                        Label(formatter.string(from: directions.expectedTravelTime)!, systemImage: "car.fill")
                    }
                    .padding(6)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                }
            }
            .animation(.default, value: directions)
            .opacity(directions == nil ? 0 : 1)
            .padding()
        }
        .frame(height: 160)
        .task {
            do {
                let source = MKMapItem.forCurrentLocation()
                let destination = MKMapItem(placemark: MKPlacemark(placemark: placemark))
                let directionsRequest = MKDirections.Request()
                directionsRequest.source = source
                directionsRequest.destination = destination
                let directions = MKDirections(request: directionsRequest)
                let eta = try await directions.calculateETA()
                self.directions = eta
            } catch {
                print(error)
            }
        }
    }
    
}

extension CLPlacemark: Identifiable {
    
}
