//
//  SongAPI.swift
//  akash and cameron
//
//  Created by keckuser on 4/23/24.
//

import Foundation

func getSong (query: String) async throws -> Song?  {
    let url = URL(string: "https://spotify-scraper.p.rapidapi.com/v1/track/download?track=\(query)")!
    var request = URLRequest(url: url)
    request.setValue("b99a4e4c1cmshe2f9cf4be8a7dc1p12a911jsndd3d748d06de", forHTTPHeaderField: "X-RapidAPI-Key")
    request.setValue("spotify-scraper.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
    
    
    let (data, _) = try await URLSession.shared.data(for: request)
    print (data)
    
    if let decodedSong = try? JSONDecoder().decode(Song.self, from: data) {
        return decodedSong
    } else {
        fatalError()
    }
}
