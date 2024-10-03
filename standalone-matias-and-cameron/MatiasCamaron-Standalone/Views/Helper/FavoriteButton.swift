//
//  FavoriteButton.swift
//  MatiasCamaron-Standalone
//
//  Created by Matias Martinez on 24/01/24.
//

import SwiftUI

struct FavoriteButton: View {
    @Binding var isSet: Bool
    var body: some View {
        Button {
            isSet.toggle()
        } label: {
            Label("Toggle Favorite", systemImage: isSet ? "heart.fill" : "heart")
                .labelStyle(.iconOnly)
                .foregroundStyle(isSet ? .red : .gray)
        }
    }
}
    

#Preview {
    FavoriteButton(isSet: .constant(true))
}
