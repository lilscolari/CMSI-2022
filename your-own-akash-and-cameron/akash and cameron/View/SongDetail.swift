//
//  SongDetail.swift
//  akash and cameron
//
//  Created by keckuser on 4/15/24.
//

import SwiftUI

struct SongDetail: View {
    @EnvironmentObject var songService: SongService
    @EnvironmentObject var auth: SongAuth
    
    @Binding var isActive: Bool
    
    @Binding var song: Song
    @Binding var favorited: Bool
    @State var running = false
    @State var failed = false
    
    @State var songID = ""
    
    @State var showPlaylistView = false
    
    enum SongError: Error {
        case unauthorizedError
    }
    
    var body: some View {
        
        VStack {
            HStack {
                Text(song.title)
                    .font(Font.custom("SpecialElite-Regular", size: 30))
                Spacer()
                if auth.user != nil {
                    Button(action: {
                        running = true
                    }) {
                        FavoriteButton(buttonTapped: $favorited, title: song.title)
                    }
                    .disabled(running || failed)
                    
                    if failed {
                        Button(action: {
                            running = true
                        }) {
                            if let authuser = auth.user {
                                Text("Try again")
                            } else {
                                Text("Please log in")
                            }
                        }
                    }
                }
            }
            .padding()
            VStack {
                if let authuser = auth.user {
                    Button("Add to playlist") {
                        showPlaylistView = true
                    }.sheet(isPresented: $showPlaylistView) {
                        PlaylistAdd(uid: authuser.uid, song: $song)
                    }
                }
            }
            .padding()
            .offset(x: 0)
            
            if running {
                Spacer().task {
                    do {
                        if let authuser = auth.user {
                            if favorited {
                                try await songService.deleteSong(id: song.id, userId: authuser.uid)
                                print("Should be deleting")
                                favorited = false
                            } else {
                                song = try songService.createSongAndUpdate(song: song, userId: authuser.uid)
                                favorited = true
                            }
                            failed = false
                        } else {
                            throw SongError.unauthorizedError
                        }
                    } catch {
                        failed = true
                    }
                    running = false
                }
            } else {
                Spacer()
            }
        }.background(Color.clear)
    }
}

