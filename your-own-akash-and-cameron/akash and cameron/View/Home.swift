//
//  ArticleList.swift
//  akash and cameron
//
//  Created by keckuser on 4/23/24.
//

import SwiftUI
import Combine

private class DebouncedState: ObservableObject {
    @Published var currentValue: String
    @Published var debouncedValue: String
    
    private var subscriber: AnyCancellable?
    
    init(initialValue: String, delay: Double = 0.3) {
        _currentValue = Published(initialValue: initialValue)
        _debouncedValue = Published(initialValue: initialValue)
        subscriber = $currentValue
            .debounce(for: .seconds(delay), scheduler: RunLoop.main)
            .sink { value in
                self.debouncedValue = value
            }
    }
}


struct Home: View {
    
    
    @EnvironmentObject var auth: SongAuth
    
    @EnvironmentObject var songService: SongService
    
    @Binding var requestLogin: Bool
    
    @State var downloading = false
    
    @State var fetching = false
    
    @State var animated = false
    
    @State var error: Error?
    
    @StateObject private var searchText = DebouncedState(initialValue: "", delay: 0.5)
    
    @EnvironmentObject var client: TelegramClient
    @State var displaySongs = false
    
    @State var loadingDisplay = false
    
    
    
    var body: some View {
        NavigationView {
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Color(red: 215/255, green: 161/255, blue: 240/255), Color(red: 150/255, green: 50/255, blue: 120/255)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                VStack {
                    Text("Music Mixer")
                        .font(Font.custom("SpecialElite-Regular", size: 50))
                        .foregroundStyle(.white)
                        .font(.largeTitle)
                        .offset(y: -100)
                        .foregroundColor(Color(red: 55/255, green: 26/255, blue: 77/255))
                    Text("You may need to log in to Telegram to interact with the Bot. Make sure to 'Sign In' in the top right corner to actually save songs. Make sure to 'Close Bot' before closing the app to turn off the Bot.")
                        .font(Font.custom("SpecialElite-Regular", size: 15))
                        .foregroundStyle(.white)
                        .offset(y: -100)
                        .padding()
                    
                    if loadingDisplay {
                        ProgressView().task {
                            loadingDisplay = false
                            displaySongs = true
                        }
                    } else {
                        if displaySongs {
                            TelegramSearchView(input: searchText.currentValue.trimmingCharacters(in: .whitespacesAndNewlines))
                                .offset(y: -80)
                        }
                    }
                    
                    Spacer()
                    
                    
                    Spacer()
                    
                    if fetching {
                        ProgressView()
                            .frame(maxWidth:.infinity, maxHeight:.infinity)
                    } else if error != nil {
                        Text("\(String(describing: error))")
                        Text("Something went wrong…we wish we can say more 🤷🏽")
                            .frame(maxWidth:.infinity, maxHeight:.infinity)
                            .foregroundColor(.white)
                    } else {
                        VStack (spacing: 0) {
                        }
                        .frame(maxWidth: .infinity)
                        .searchable(text: $searchText.currentValue)
                        .onSubmit(of: .search) {
                            loadingDisplay = true
                        }
                    }
                }
                .background(Color.clear)
                .toolbar {
                    
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        if fetching {
                            ProgressView()
                                .frame(maxWidth:.infinity, maxHeight:.infinity)
                                .background(Color(red: 240/255, green: 231/255, blue: 246/255))
                        }
                        
                        if let authuser = auth.user {
                            NavigationLink("Profile") {
                                Profile(uid: authuser.uid)
                                    .environmentObject(songService)
                                    .environmentObject(auth)
                            }
                            .foregroundColor(.white)
                            
                        } else {
                            Button("Sign In") {
                                requestLogin = true
                            }
                            .foregroundColor(.white)
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        TelegramLogin()
                    }
                }
                
            }
        }.accentColor(.white)
    }
}
