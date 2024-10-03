//
//  Comment.swift
//  firebase-backed
//
//  Created by Taylor Musso on 3/23/24.
//

import Foundation
import SwiftUI

struct Comment: Hashable, Codable, Identifiable {
    var id: String
    var uid: String
    var date: Date
    var text: String
}
