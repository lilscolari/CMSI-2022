//
//  BannerImage.swift
//  firebase-backed
//
//  Created by Taylor Musso on 3/21/24.
//

import SwiftUI

struct BannerImage: View {
    var imageURL: URL
    var height: CGFloat?
    
    var body: some View {
        AsyncImage(url: imageURL) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: height)
                    .clipped()
            } else if phase.error != nil {
                Image("default-pfp")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: height)
                    .clipped()
                    .overlay(Text("no photo"))
            } else {
                ZStack {
                    Image("default-pfp")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: height)
                        .clipped()
                    ProgressView()
                }
            }
        }
    }
}

#Preview {
    BannerImage(
        imageURL: URL(string:"https://firebasestorage.googleapis.com:443/v0/b/fir-mobile-5302f.appspot.com/o/article%2F9O7H4xU8TvLN726AFGdm?alt=media&token=645d9c09-e632-409f-95dc-7e7477592533")!,
        height: 150)
}
