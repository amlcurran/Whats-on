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
    @AppStorage("direction") var direction: DirectionType = .any
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: placemark.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))), annotationItems: [placemark], annotationContent: { _ in
                MapMarker(coordinate: placemark.location!.coordinate, tint: .pink)
            })
            ZStack {
                if let directions = directions {
                    Label(formatter.string(from: directions.expectedTravelTime)!, systemImage: directions.transportType.image)
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
                directionsRequest.transportType = direction.asMapKitDirection
                let directions = MKDirections(request: directionsRequest)
                let eta = try await directions.calculateETA()
                self.directions = eta
            } catch {
                print(error)
            }
        }
    }
    
}

extension MKDirectionsTransportType {
    
    var image: String {
        switch self {
        case .transit:
            return "bus.fill"
        case .automobile:
            return "car.fill"
        case .walking:
            return "figure.walking"
        default:
            print("Unknown direction reponse type \(self.rawValue)")
            return "car.fill"
        }
    }
    
}

extension CLPlacemark: Identifiable {
    
}
