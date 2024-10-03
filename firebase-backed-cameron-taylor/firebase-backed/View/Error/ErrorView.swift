//
//  ErrorView.swift
//  firebase-backed
//
//  Created by keckuser on 3/25/24.
//

import SwiftUI

struct ErrorView: View {
    var body: some View {
        Text("We ran into an error. Please restart the app.")
            .frame(maxWidth:.infinity, maxHeight:.infinity)
            .background(Color(red: 0.856, green: 0.826, blue: 0.805))
    }
}

#Preview {
    ErrorView()
}
