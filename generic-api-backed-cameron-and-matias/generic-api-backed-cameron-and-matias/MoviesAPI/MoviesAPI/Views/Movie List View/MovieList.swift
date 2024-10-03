//
//  MovieList.swift
//  MoviesAPI
//
//  Created by Matias Martinez on 20/02/24.
//

import SwiftUI

var num = 0


struct MovieList: View {
    @State var movie: Movie?
    
    var body: some View {
        VStack {
            
            NavigationStack {
                VStack {
                    if let loadedMovie = movie {
                        List {
                            ForEach(loadedMovie.results) { m in
                                MovieRow(result: m)
                            }
                        }
                        
                    } else {
                        ProgressView()
                    }
                
                    NavigationLink (destination: MovieList()){
                        Text("Next Page")
                    }.frame(width: 300, height: 30, alignment: .top).toolbar{
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                var current = num
                                num = 0
                            } label: {
                                Text("Back to Page 0")
                                    
                            }
                        }
                    }
                }
            }
        }.task {
            await loadMovie()
        }
    }
    
    func loadMovie() async {
        num += 1

        do {
            self.movie = try await getMovie(page: num)
        } catch {
        }
    }
}


#Preview {
    MovieList()
}
