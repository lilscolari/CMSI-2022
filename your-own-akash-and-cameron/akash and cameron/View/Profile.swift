//
//  Profile.swift
//  akash and cameron
//
//  Created by keckuser on 4/25/24.
//

import SwiftUI

struct Profile: View {
    @EnvironmentObject var auth: SongAuth
    @EnvironmentObject var songService: SongService
    let uid: String
    
    @State var playlists: [String]?
    
    
    @State var appeared1: Double = 0
    @State var appeared2: Double = 0
    @State var appeared3: Double = 0
    
    @State var fetching = false
    
    func loadPlaylists() {
        fetching = true
        Task {
            do {
                let playlists = try await songService.fetchListOfPlaylists(userId: uid)
            } catch {
                print("Error in profile")
            }
        }
        fetching = false
    }
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color(red: 215/255, green: 161/255, blue: 240/255), Color(red: 150/255, green: 50/255, blue: 120/255)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack {
                Text("Profile")
                    .font(Font.custom("SpecialElite-Regular", size: 50))
                    .foregroundColor(.white)
                    .offset(y: -25)
                    .opacity(appeared3)
                    .animation(Animation.easeInOut(duration: 0.5), value: appeared3)
                    .onAppear {self.appeared3 = 1.0}
                    .onDisappear {self.appeared3 = 0.0}
                Divider()
                    .foregroundColor(.white)
                VStack {
                    NavigationLink(
                        destination: SongList(uid: uid)
                            .environmentObject(songService)
                            .environmentObject(auth),
                        
                        label: {
                            Text("View Your Songs")
                                .foregroundColor(.white)
                        }).navigationBarBackButtonHidden(true)
                        .navigationBarItems(leading: BackButton())
                        .opacity(appeared1)
                        .animation(Animation.easeInOut(duration: 0.5), value: appeared1)
                        .onAppear {self.appeared1 = 1.0}
                        .onDisappear {self.appeared1 = 0.0}
                    
                    if let playlistsExists = playlists {
                        ForEach(playlistsExists, id: \.self) { playlist in
                            NavigationLink(
                                destination: SongList(uid: uid, playlist: playlist)
                                    .environmentObject(songService)
                                    .environmentObject(auth),
                                
                                label: {
                                    Text(playlist)
                                        .foregroundColor(.white)
                                }).navigationBarBackButtonHidden(true)
                                .navigationBarItems(leading: BackButton())
                                .opacity(appeared1)
                                .animation(Animation.easeInOut(duration: 0.5), value: appeared1)
                                .onAppear {self.appeared1 = 1.0}
                                .onDisappear {self.appeared1 = 0.0}
                        }
                    } else {
                        if fetching {
                            ProgressView().task {
                                loadPlaylists()
                            }
                        } else {
                            Button("Try again") {
                                fetching = true
                            }.offset(y: 100)
                            
                        }
                    }
                    
                }
                .font(Font.custom("SpecialElite-Regular", size: 20))
                .foregroundColor(.white)
                .padding()
                .offset(y: 50)
                Spacer()
            }
            Spacer()
            ZStack {
                Triangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 215/255, green: 161/255, blue: 240/255), Color(red: 150/255, green: 50/255, blue: 120/255)]), startPoint: .top, endPoint: .bottom))                    
                    .edgesIgnoringSafeArea(.all)
                    .offset(y: 150)
                Triangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 215/255, green: 161/255, blue: 240/255), Color(red: 150/255, green: 50/255, blue: 120/255)]), startPoint: .top, endPoint: .bottom))                    
                    .offset(x: 100, y: 150)
                    .edgesIgnoringSafeArea(.all)
                Triangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 215/255, green: 161/255, blue: 240/255), Color(red: 150/255, green: 50/255, blue: 120/255)]), startPoint: .top, endPoint: .bottom))                    
                    .offset(x: -100, y: 150)
                    .edgesIgnoringSafeArea(.all)
                Triangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 215/255, green: 161/255, blue: 240/255), Color(red: 150/255, green: 50/255, blue: 120/255)]), startPoint: .top, endPoint: .bottom))                    
                    .offset(x: 200, y: 150)
                    .edgesIgnoringSafeArea(.all)
                Triangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 215/255, green: 161/255, blue: 240/255), Color(red: 150/255, green: 50/255, blue: 120/255)]), startPoint: .top, endPoint: .bottom))
                    .offset(x: -200, y: 150)
                    .edgesIgnoringSafeArea(.all)
                
                
            }
            .offset(y: 500)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.blue)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("Sign Out") {
                    do {
                        try auth.signOut()
                    } catch {
                        ErrorView()
                    }
                }.foregroundColor(.white)
                
            }
        }
    }
}
//}

//#Preview {
//    Profile()
//}
