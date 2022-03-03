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
    
    var body: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(center: placemark.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))), annotationItems: [placemark], annotationContent: { _ in
            MapMarker(coordinate: placemark.location!.coordinate, tint: .pink)
        })
            .frame(height: 160)
    }
    
}

extension CLPlacemark: Identifiable {
    
}
