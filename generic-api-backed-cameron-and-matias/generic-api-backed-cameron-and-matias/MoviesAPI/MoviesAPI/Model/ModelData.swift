////
////  ModelData.swift
////  MoviesAPI
////
////  Created by Matias Martinez on 19/02/24.
////

import Foundation
@Observable
class modelData {
    
}
struct Movie: Hashable, Codable {
    let results: [Result]
}

struct Result: Hashable,  Codable, Identifiable {
    let id: String
    let titleText: MovieTitle
    let releaseYear: Year
    let position: Int
    let primaryImage: MovieImage
    
    struct MovieImage: Hashable, Codable {
        let url: String
    }
    
    
    struct MovieTitle: Hashable, Codable {
            let text: String
    }
    
    struct Year: Hashable, Codable {
        let year: Int
    }
}

