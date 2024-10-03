//
//  MatiasCamaron_StandaloneApp.swift
//  MatiasCamaron-Standalone
//
//  Created by Matias Martinez on 22/01/24.
//

import SwiftUI

@main
struct MatiasCamaron_StandaloneApp: App {
    @State private var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(modelData)
        }
    }
}
