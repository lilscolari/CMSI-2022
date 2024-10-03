//
//  MovieRow.swift
//  MoviesAPI
//
//  Created by Matias Martinez on 20/02/24.
//

import SwiftUI
struct MovieRow: View {
    @State var result: Result?
    @State private var num: Int = 0
    @State private var movie: Movie?
    
    var body: some View {
        
        HStack{
            
            if let loadedMovie = result {
                AsyncImage(url: URL(string: loadedMovie.primaryImage.url)) { image in
                    image.resizable()
                    
                } placeholder : {
                    ProgressView()
                }
                .frame(width: 80, height: 50)
                
                VStack {
                    Text(loadedMovie.titleText.text)
                    
                    Text("Year: \(String(loadedMovie.releaseYear.year))")
                        .frame(alignment: .trailing)
                    
                }
                .padding()
            }
            
            
        }
        .task {
            await loadRow()
        }
        
    }
    
    func loadRow() async {
        num += 1
        do {
            self.movie = try await getMovie(page: num)
        } catch {
        }
    }
}

#Preview {
    MovieRow()
}
