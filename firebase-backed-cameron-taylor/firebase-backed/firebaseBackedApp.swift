//
//  firebase_backedApp.swift
//  firebase-backed
//
//  Created by Taylor Musso on 3/12/24.
//

import SwiftUI

@main
struct firebaseBackedApp: App {
    // This connects our newfangled SwiftUI app with the UIApplicationDelegate
    // object mentioned in the Firebase documentation.
    @UIApplicationDelegateAdaptor(firebaseBackedAppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(BlogAuth())
                .environmentObject(BlogArticle())
                .environmentObject(BlogStorage())
        }
    }
}
