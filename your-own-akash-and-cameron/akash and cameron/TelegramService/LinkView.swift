//
//  LinkView.swift
//  akash and cameron
//
//  Created by keckuser on 5/1/24.
//

import SwiftUI

struct LinkView: View {
    @EnvironmentObject var client: TelegramClient
    @EnvironmentObject var songService: SongService
    
    @Binding var isActive: Bool
    
    @Binding var chosenSong: InlineWrapper
    
    @State var worked = false
    @State var offlineSong: Song
    
    func clickTelegramButton(inlineWrapper: InlineWrapper) {
        Task {
            worked = await client.clickButton(inlineWrapper: inlineWrapper)
        }
    }
    
    var body: some View {
        VStack {
            SongDetail(isActive: $isActive, song: $offlineSong, favorited: $chosenSong.favorited)
                .foregroundColor(.black)
            
            
            if worked {
                AudioView(title: chosenSong.text)
                    .foregroundColor(.black)
            } else {
                ProgressView().task {
                    clickTelegramButton(inlineWrapper: chosenSong)
                }
                Text("Failed to load the song chosen")
            }
        }
        .background(Color.clear)
    }
}
