//
//  Author.swift
//  firebase-backed
//
//  Created by Taylor Musso on 3/21/24.
//

import Foundation
import SwiftUI


struct Author: Hashable, Codable, Identifiable {
    var id: String
    var displayName: String
    var bio: String
    var profilePhotoURL: URL
    var bannerPhotoURL: URL
}
