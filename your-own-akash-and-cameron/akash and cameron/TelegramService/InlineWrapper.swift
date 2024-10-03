//
//  ReplyMarkupWrapper.swift
//  akash and cameron
//
//  Created by Akash on 4/30/24.
//

import Foundation
import TDLibKit

struct InlineWrapper: Identifiable, Codable, Equatable, Hashable {
    var id = UUID()
    let messageId: Int64
    let text: String
    let sendbackData: Data
    var favorited: Bool
}
