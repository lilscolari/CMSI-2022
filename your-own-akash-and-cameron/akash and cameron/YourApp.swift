//
//  App.swift
//  akash and cameron
//
//  Created by keckuser on 4/29/24.
//

import SwiftUI


@main
struct YourApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black
    }

    
    //@State var song: Song = Song(favorites: [], title: "")

  var body: some Scene {
    WindowGroup {
      NavigationView {
          ContentView(
            //song: song
          )
              .environmentObject(SongAuth())
               .environmentObject(TelegramClient())
              .environmentObject(SongService())
      }
    }
  }
}
