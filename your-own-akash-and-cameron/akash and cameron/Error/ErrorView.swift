//
//  ErrorView.swift
//  akash and cameron
//
//  Created by keckuser on 4/25/24.
//

import SwiftUI

struct ErrorView: View {
    var body: some View {
        Text("We ran into an error. Please restart the app.")
            .frame(maxWidth:.infinity, maxHeight:.infinity)
            .background(Color(red: 240/255, green: 231/255, blue: 246/255))
    }
}

#Preview {
    ErrorView()
}
