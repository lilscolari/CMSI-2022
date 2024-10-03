/**
 * BareBonesBlogAppDelegate sets up the Firebase SDK for communication with your
 * project. It does this via the UIApplicationDelegate protocol, which provides
 * a mechanism for executing application-level code that isn’t covered directly by
 * SwiftUI. The Firebase documentation uses this mechanism to get your app going
 * with Firebase. Take a look at BareBonesBlogApp to see how this “delegate” is
 * connected to the SwiftUI app itself.
 *
 * For a few more details, look at this brief item from Hacking with Swift:
 *     https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-an-appdelegate-to-a-swiftui-app
 */
import Foundation
import UIKit
import SwiftUI

// As a personal preference, I tend to put third-party library imports after the
// first-party iOS ones just so I know who’s responsible for what.
import Firebase
import GoogleSignIn
import FirebaseCore
import FirebaseAuth


class firebaseBackedAppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        let appearance = UINavigationBarAppearance()
        let navyBlue = UIColor(Color(red: -0.046, green: 0.137, blue: 0.227))
        let lightPink = UIColor(Color(red: 0.924, green: 0.639, blue: 0.749))
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = navyBlue
        appearance.titleTextAttributes = [.foregroundColor: lightPink, .font: UIFont(name: "Rockin'-Record", size: 20)!]
        appearance.largeTitleTextAttributes = [.foregroundColor: lightPink, .font: UIFont(name: "Rockin'-Record", size: 50)!]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        UISearchBar.appearance().overrideUserInterfaceStyle = .dark
                
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}
