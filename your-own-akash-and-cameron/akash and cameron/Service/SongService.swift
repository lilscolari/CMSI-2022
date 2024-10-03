//
//  SongService.swift
//  akash and cameron
//
//  Created by keckuser on 4/24/24.
//

import Foundation

import Firebase

let PAGE_LIMIT = 20

let PLAYLIST_COLLECTION = "playlists"


class SongService: ObservableObject {
    
    private let db = Firestore.firestore()
    
    var data: [Song] = []
    
    var lastDoc: QueryDocumentSnapshot!
    
    enum SongServiceError: Error {
        case mismatchedDocumentError
        case unexpectedError
        case creationError
        case pageError
        case dbError
    }
    
    @Published var error: Error?
    
    func editPlaylists(song: Song, adding: Bool, playlist: String, userId: String) throws -> Song? {
        
        var newPlaylists = [String]()
        if adding {
            newPlaylists = song.playlists
            newPlaylists.append(playlist)
        } else {
            for existingPlaylist in song.playlists {
                if existingPlaylist != playlist {
                    newPlaylists.append(existingPlaylist)
                }
            }
        }
        
        do {
            db.collection(userId).document(song.id).setData([
                "playlists": newPlaylists
            ])
            
            db.collection(PLAYLIST_COLLECTION).document(userId).setData([
                "playlists": newPlaylists
            ])
            
            return Song(
                title: song.title,
                id: song.id,
                msgId: song.msgId,
                playlists: newPlaylists
            )
        } catch {
            self.error = error
        }
    }
    
    func createSongAndUpdate(song: Song, userId: String) throws -> Song {
        do {
            let newId = try createSong(song: song, userId: userId)
            print("NEW ID equals \(newId)")
            return Song(
                title: song.title,
                id: newId,
                msgId: song.msgId,
                playlists: song.playlists
            )
        } catch {
            throw SongServiceError.creationError
        }
    }
    
    func createSong(song: Song, userId: String) throws -> String {
        var ref: DocumentReference? = nil
        
        // addDocument is one of those “odd” methods.
        ref = db.collection(userId).addDocument(data: [
            "title": song.title,
            "msgId": song.msgId,
            "playlists": song.playlists
            
        ]) { possibleError in
            if let actualError = possibleError {
                self.error = actualError
                print("Error:\(self.error)")
            }
        }
        
        // If we don’t get a ref back, return an empty string to indicate “no ID.”
        return ref?.documentID ?? ""
    }
    
    func fetchSongs(input: String?, userId: String) async throws -> [Song] {
        print("Fetching songs for user \(userId)")
        let songQueryCollection = db.collection(userId)
            .order(by: "title", descending: true)
            .limit(to: PAGE_LIMIT)
        
        let querySnapshot = try await songQueryCollection.getDocuments()
        
        var songsFiltered: [QueryDocumentSnapshot]
        if let inputExists = input {
            songsFiltered = querySnapshot.documents
                .filter { document in
                    if let name = document.get("title") as? String {
                        return name.lowercased().contains(inputExists.lowercased())
                    }
                    return false
                }
        } else {
            songsFiltered = querySnapshot.documents
        }
        
        
        return try songsFiltered.map {
            // This is likely new Swift for you: type conversion is conditional, so they
            // must be guarded in case they fail.
            guard let title = $0.get("title") as? String,
                  
                    // Firestore returns Swift Dates as its own Timestamp data type.
                  let msgId = $0.get("msgId") as? Int64,
                  let playlists = $0.get("playlists") as? [String]
            else {
                
                throw SongServiceError.mismatchedDocumentError
            }
            
            return Song(
                title: title,
                id: $0.documentID,
                msgId: msgId,
                playlists: playlists
            )
        }
    }
    
    func fetchListOfPlaylists(userId: String) async throws -> [String]? {
        print("Fetching songs for user \(userId)")
        let songQueryCollection = db.collection(PLAYLIST_COLLECTION)
            .limit(to: PAGE_LIMIT)
        
        let querySnapshot = try await songQueryCollection.getDocuments()
        
        let documents = try querySnapshot.documents
            .filter { document in
                return document.documentID == userId
        }
        
        for document in documents {
            return document.get("playlists") as? [String]
        }
        
        return nil
    }
    
    func fetchPlaylist(playlist: String, page: Int, userId: String) async throws -> [Song] {
        guard page >= 0 else {
            throw SongServiceError.pageError
        }
        
        let songQueryCollection = db.collection(userId)
            .order(by: "title", descending: true)
            .start(after: [page * PAGE_LIMIT])
            .limit(to: PAGE_LIMIT)
        
        let querySnapshot = try await songQueryCollection.getDocuments()
        
        var songsFiltered: [QueryDocumentSnapshot]
        songsFiltered = querySnapshot.documents
            .filter { document in
                if let playlists = document.get("playlists") as? [String] {
                    return playlists.contains(playlist)
                }
                return false
            }
        
        
        return try songsFiltered.map {
            // This is likely new Swift for you: type conversion is conditional, so they
            // must be guarded in case they fail.
            guard let title = $0.get("title") as? String,
                  
                    // Firestore returns Swift Dates as its own Timestamp data type.
                  let msgId = $0.get("msgId") as? Int64,
                  let playlists = $0.get("playlists") as? [String]
            else {
                
                throw SongServiceError.mismatchedDocumentError
            }
            
            return Song(
                title: title,
                id: $0.documentID,
                msgId: msgId,
                playlists: playlists
            )
        }
    }
    
    func deleteSong(id: String, userId: String) async throws {
        db.collection(userId).document(id).delete() { possibleError in
            if let actualError = possibleError {
                self.error = actualError
            } else {
                print("Successful deletion")
            }
        }
    }
}

