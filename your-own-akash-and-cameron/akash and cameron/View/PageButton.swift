//
//  PageButton.swift
//  akash and cameron
//
//  Created by keckuser on 5/2/24.
//

import SwiftUI

struct PageButton: View {
    @Binding var page: Int
    @State var nextDisabled: Bool
    
    var body: some View {
        HStack {
            Button("Last page") {
                page -= 1
            }
            .disabled(page == 0)
            .task {
                if page < 0 {
                    page = 0
                }
            }
            Button("Next page") {
                page += 1
            }.disabled(nextDisabled)
        }
    }
}
