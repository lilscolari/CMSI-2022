//
//  SongQuery.swift
//  akash and cameron
//
//  Created by keckuser on 4/30/24.
//

import Foundation
import TDLibKit

struct Song: Hashable, Codable, Identifiable {
    let title: String
    let id: String
    
    let msgId: Int64? // id of the message where the song is contained
    
    let playlists: [String]
}
