//
//  Content.swift
//  akash and cameron
//
//  Created by keckuser on 4/23/24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var songServ: SongService
    
    @EnvironmentObject var auth: SongAuth
    
    
    var body: some View {
        Login()
        .environmentObject(songServ)
        .environmentObject(auth)
    }
}

//#Preview {
//    ContentView()
//}
