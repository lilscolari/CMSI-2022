//
//  ContentView.swift
//  telegramClient2
//
//  Created by keckuser on 4/24/24.
//

import SwiftUI

struct TelegramLogin: View {
    
    @EnvironmentObject var client: TelegramClient
    
    @State var presentSheet = false
    
    @State var loggedIn = false
    
    var body: some View {
        HStack {
            Button(action: {
                client.close()
            }) {
                Text("Close Bot")
                    .foregroundColor(.white)
            }
            
            Button(action: {
                print(client.authState)
                presentSheet = client.awaitingInput
                loggedIn = true
            }) {
                if !loggedIn {
                    Text("Login")
                        .foregroundColor(.white)
                }
            }
        }
        .task {
            presentSheet = client.awaitingInput
        }.sheet(isPresented: $presentSheet) {
            AuthorizationInterface(client: client, presentSheet: $presentSheet, loggedIn: $loggedIn)
        }
    }
}
