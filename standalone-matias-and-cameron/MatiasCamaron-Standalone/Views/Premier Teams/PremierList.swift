//
//  PremierList.swift
//  MatiasCamaron-Standalone
//
//  Created by Matias Martinez on 24/01/24.
//  Purpose of the file: Display the list of Premier League teams and give the choice to filter options.

import SwiftUI

struct PremierList: View {
    @Environment(ModelData.self) var modelData
    @State private var showFavoritesOnly = false
    
    var filteredTeams: [Premier] {
        modelData.premierTeams.filter { premier in
                (!showFavoritesOnly || premier.isFavorite)
        }
    }
    
    var body: some View {
        NavigationSplitView {
            
            List{
                Toggle(isOn: $showFavoritesOnly){
                    Text("Favorites Only")
                }
                ForEach(filteredTeams) { premier in
                    
                    NavigationLink {
                        PremierDetail(premier: premier)
                    } label: {
                        PremierRow(premier: premier)
                    }
                }
            }
            .animation(.default, value: filteredTeams)
            .navigationTitle("Teams")
        } detail: {
            Text("Select a Team")
            
        }
    }
}

#Preview {
    PremierList()
        .environment(ModelData())
}
