//
//  MovieView.swift
//  MoviesAPI
//
//  Created by Matias Martinez on 19/02/24.
//

import SwiftUI

struct MovieView: View {
    @State var movie: Movie?
    
    var body: some View {
        VStack {
            if let loadedMovie = movie {
                HStack{
                    
                    AsyncImage(url: URL(string: loadedMovie.results[0].primaryImage.url))
                        .frame(width: 50, height: 50)
                    
                    Spacer()
                        
                    VStack {
                        Text(loadedMovie.results[0].titleText.text)
                        Text("Year: \(String(loadedMovie.results[0].releaseYear.year))")
                            .frame(alignment: .trailing)
                    
                    }
                    .padding()
                }
                
            } else {
                ProgressView()
            }
            
        }.task {
            await loadMovie()
        }
    }
    
    func loadMovie() async {
       
        do {
            self.movie = try await getMovie(page: 1)
        } catch {
        }
    }
}

#Preview {
    MovieView()
}
