//
//  ContentView.swift
//  MatiasCamaron-Standalone
//
//  Created by Matias Martinez on 22/01/24.
//

import SwiftUI
struct ContentView: View {
    var body: some View {
        PremierList()
    }
}
#Preview {
    ContentView()
        .environment(ModelData())
}
