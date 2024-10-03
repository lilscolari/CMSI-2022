//
//  GetRandom.swift
//  MoviesAPI
//
//  Created by Matias Martinez on 21/02/24.
//

import SwiftUI

struct GetRandom: View {
    @State var movie: Movie?
    @State var animated = false
    var body: some View {
        VStack{
            if let loadedMovie = movie {
                AsyncImage(url: URL(string: loadedMovie.results[0].primaryImage.url)) { image in
                    image.resizable()
                        
                        .animation(.easeIn(duration: 8), value: animated)
                        .transition(.scale)
                    
                } placeholder : {
                    ProgressView()
                }
            }
            
        }
        .task {
            await loadRandom()
        }
    }
    func loadRandom() async {
       
        do {
            self.movie = try await getRandom()
        } catch {
        }
    }
}

#Preview {
    GetRandom()
}
