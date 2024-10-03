//
//  SongList.swift
//  akash and cameron
//
//  Created by keckuser on 4/25/24.
//

import SwiftUI

struct SongList: View {
    @EnvironmentObject var auth: SongAuth
    @EnvironmentObject var songService: SongService
    let uid: String
    
    @State var playlist: String?
    
    @State var fetching = true
    
    @State var page = 0
    
    @State var songs: [Song]?
    
    @State var error: Error?
    
    enum SongListError: Error {
        case unauthorizedUser
        case fetchFailed
    }
    
    func fetchSongs() async {
        fetching = true
        do {
            if let playlistExists = playlist {
                songs = try await songService.fetchPlaylist(playlist: playlistExists, page: page, userId: uid)
            } else {
                songs = try await songService.fetchSongs(input: nil, userId: uid)
            }
        } catch {
            self.error = SongListError.fetchFailed
            print("ERROR: \(error)")
        }
        fetching = false
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(red: 215/255, green: 161/255, blue: 240/255), Color(red: 150/255, green: 50/255, blue: 120/255)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack {
                Text("Your Songs")
                    .font(Font.custom("SpecialElite-Regular", size: 50))
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .offset(y: -250)
                    .padding()
                Spacer()
                if fetching {
                    ProgressView().task {
                        await fetchSongs()
                    }
                } else {
                    if let songsExist = songs {
                        if songsExist.isEmpty {
                            Text("You have no songs to display! Go search for songs and start saving them to display them here.")
                                .foregroundStyle(.white)
                                .padding()
                        } else {
                            ForEach(songsExist, id: \.self) { song in
                                
                                Text(song.title)
                                    .foregroundStyle(.white)
                                    .offset(y: -250)
                            }
                        }
                    } else {
                        Text("Failed to load songs")
                        Button("Try again") {
                            fetching = true
                        }
                    }
                    Spacer()
                    PageButton(page: $page, nextDisabled: (songs ?? [Song]()).count < PAGE_LIMIT)
                        .padding()
                }
                
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButton())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Sign Out") {
                        do {
                            try auth.signOut()
                        } catch {
                            //ErrorView()
                        }
                    }.foregroundStyle(.white)
                    
                }
            }
        }.background(Color.clear)
    }
}


//#Preview {
//    SongList()
//}
