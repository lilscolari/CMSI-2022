//
//  MovieModelAPI.swift
//  MoviesAPI
//
//  Created by Matias Martinez on 19/02/24.
//
import Foundation

func getMovie (page: Int) async throws -> Movie?  {
    let url = URL(string: "https://moviesdatabase.p.rapidapi.com/titles?list=top_boxoffice_200&page=\(page)")!
    var request = URLRequest(url: url)
    request.setValue("c9f8625745msh83cb06afbcbbe53p1c9794jsn8b771144528c", forHTTPHeaderField: "X-RapidAPI-Key")
    request.setValue("moviesdatabase.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
    
    
    let (data, _) = try await URLSession.shared.data(for: request)
    print (data)
    
    if let decodedMovie = try? JSONDecoder().decode(Movie.self, from: data) {
        return decodedMovie
    } else {
        fatalError()
    }
}
