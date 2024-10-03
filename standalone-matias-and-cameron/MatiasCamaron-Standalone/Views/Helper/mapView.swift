//
//  mapView.swift
//  MatiasCamaron-Standalone
//
//  Created by Matias Martinez on 23/01/24.
//

import SwiftUI
import MapKit

struct mapView: View {
    var coordinate: CLLocationCoordinate2D
    var body: some View {
        Map(position: .constant(.region(region)))
    }
    
    private var region: MKCoordinateRegion {
            MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
            )
        }
}

#Preview {
    mapView(coordinate: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868))
}
