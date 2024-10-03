//
//  ProfileImage.swift
//  firebase-backed
//
//  Created by Taylor Musso on 3/21/24.
//

import SwiftUI

struct ProfileImage: View {
    var imageURL: URL
    var backgroundColor: Color
    var width: CGFloat?
    var height: CGFloat?
    
    var body: some View {
        AsyncImage(url: imageURL) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width: width, height: height)
                    .overlay {
                        Circle().stroke(backgroundColor, lineWidth: 5)
                    }
            } else if phase.error != nil {
                Image("default-pfp")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width: width, height: height)
                    .overlay {
                        Circle().stroke(backgroundColor, lineWidth: 5)
                    }
            } else {
                ZStack {
                    Image("default-pfp")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .frame(width: width, height: height)
                        .overlay {
                            Circle().stroke(backgroundColor, lineWidth: 5)
                        }
                    
                    ProgressView()
                        .frame(width: width, height: height)
                }
            }
        }
        .id(imageURL)
    }
}

#Preview {
    ProfileImage(
        imageURL: URL(string:"https://firebasestorage.googleapis.com:443/v0/b/fir-mobile-5302f.appspot.com/o/article%2F9O7H4xU8TvLN726AFGdm?alt=media&token=645d9c09-e632-409f-95dc-7e7477592533")!,
        backgroundColor: Color(red: 0.924, green: 0.639, blue: 0.749),
        width: 100,
        height: 100
    )
}
