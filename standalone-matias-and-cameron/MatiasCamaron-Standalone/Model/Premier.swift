//
//  Premier.swift
//  MatiasCamaron-Standalone
//
//  Created by Matias Martinez on 23/01/24.
//

import Foundation
import SwiftUI
import CoreLocation

struct Premier: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var stadium: String
    var description: String
    var players: [String]
    var city: String
    var isFavorite: Bool
    
    private var imageName: String
    var image: Image {
        Image(imageName)
    }
    
    private var coordinates: Coordinates
    
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }
    struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
    }
}
