//
//  RandomMovie.swift
//  MoviesAPI
//
//  Created by Matias Martinez on 20/02/24.
//

import SwiftUI

struct RandomMovie: View {
    
    var body: some View {
        NavigationView {
            VStack {
            
                NavigationLink (destination: GetRandom()){
                    Text("Click for random movie")
                }.frame(width: 300, height: 30, alignment: .top)
            }
        }
    }
}
#Preview {
    RandomMovie()
}
