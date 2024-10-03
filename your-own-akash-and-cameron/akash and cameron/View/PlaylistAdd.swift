//
//  PlaylistDetail.swift
//  akash and cameron
//
//  Created by keckuser on 4/26/24.
//
// The info that is displayed when a user views all their playlists.
//

import SwiftUI

struct PlaylistAdd: View {
    @EnvironmentObject var songService: SongService
    let uid: String
    @Binding var song: Song
    
    @State var newPlaylist = ""
    
    enum PlaylistError: Error {
        case addError
        case delError
    }
    
    @State var error: PlaylistError?
    
    func setError(adding: Bool) {
        if adding {
            self.error = PlaylistError.addError
            print("Error in adding")
        } else {
            self.error = PlaylistError.delError
            print("Error in deleting")
        }
    }
    
    func addOrDelete(adding: Bool) {
        do {
            print("Editing song playlists")
            let trySongEdit = try songService.editPlaylists(
                song: song,
                adding: adding,
                playlist: newPlaylist,
                userId: uid
            ) 
            if let songEdit = trySongEdit {
                song = songEdit
                newPlaylist = ""
            } else {
                setError(adding: adding)
            }
            
        } catch {
            print("Error in adding or deleting playlist")
            setError(adding: adding)
        }
    }
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(song.playlists, id: \.self) { playlist in
                        Text(playlist)
                        //                        .foregroundColor(Color(red: 55/255, green: 26/255, blue: 77/255))
                        //                        .padding()
                            .foregroundColor(Color(red: 55/255, green: 26/255, blue: 77/255))
                            .padding()
                    }
                    .onDelete(perform: {_ in
                        addOrDelete(adding: false)
                    })
                }.navigationBarItems(trailing: EditButton())
            }
            
            TextField("Create new playlist...", text: $newPlaylist, onCommit: {
                addOrDelete(adding: true)
            }
            )
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            
            if self.error != nil {
                switch self.error {
                case .addError:
                    Text("Error adding, please try again")
                case .delError:
                    Text("Error deleting, please try again")
                case .none:
                    Text("")
                }
            }
        }
        .background(Color(red: 240/255, green: 231/255, blue: 246/255))
    }
}

//#Preview {
//    PlaylistDetail()
//}
