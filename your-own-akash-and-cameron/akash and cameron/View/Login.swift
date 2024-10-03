//
//  Blog.swift
//  akash and cameron
//
//  Created by keckuser on 4/23/24.
//

import SwiftUI

struct Login: View {
    
    @EnvironmentObject var auth: SongAuth
    @EnvironmentObject var songServ: SongService
    
    @EnvironmentObject var client: TelegramClient
    @State var requestLogin = false
    
    
    var body: some View {
        if let authUI = auth.authUI {
            Home(requestLogin: $requestLogin)
                .environmentObject(auth)
                .environmentObject(songServ)
                .sheet(isPresented: $requestLogin) {
                    AuthenticationViewController(authUI: authUI)
                }
        } else {
            VStack {
                Text("Sorry, looks like we aren’t set up right!")
                    .padding()
                
                Text("Please contact this app’s developer for assistance.")
                    .padding()
            }
        }
    }
}
