//
//  TabsView.swift
//  MoviesAPI
//
//  Created by Matias Martinez on 20/02/24.
//

import SwiftUI

struct TabsView: View {
    var body: some View {
        
        TabView {
            MovieList()
                .tabItem {
                    Label("List of movies", systemImage: "globe")
                }
            
            RandomMovie()
                .tabItem {
                    Label("Random movie", systemImage: "star")
                }
        }
    }
}

#Preview {
    TabsView()
}
