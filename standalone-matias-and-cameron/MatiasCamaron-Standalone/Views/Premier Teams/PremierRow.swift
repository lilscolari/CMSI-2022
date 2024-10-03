//
//  PremierRow.swift
//  MatiasCamaron-Standalone
//
//  Created by Matias Martinez on 23/01/24.
//Purpose of the file: Small preview of the list in the home page of the app. 

import SwiftUI

struct PremierRow: View {
    var premier: Premier
    
    var body: some View {
        HStack {
            if premier.isFavorite {
                Image(systemName: "heart.fill")
                    .foregroundStyle(.red)
            }
            Text(premier.name)
                .font(.system(size: 20))
                

            Spacer()
            premier.image
                .resizable()
                .frame(width: 50, height: 50)
                .padding()
        
    
        }
    }
}
#Preview {
    let premierTeams = ModelData().premierTeams
    return Group {
        PremierRow(premier: premierTeams[0])
        PremierRow(premier: premierTeams[1])

    }
}
