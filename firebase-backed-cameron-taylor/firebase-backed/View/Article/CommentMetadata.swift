//
//  Comment.swift
//  firebase-backed
//
//  Created by Taylor Musso on 3/23/24.
//

import SwiftUI

struct CommentMetadata: View {
    var author: Author
    var comment: Comment
    
    var body: some View {
        VStack (alignment: .leading){
            
            HStack {
                ProfileImage(imageURL: author.profilePhotoURL, backgroundColor: Color(red: 0.924, green: 0.639, blue: 0.749), width: 30, height: 30)
                Text(author.displayName)
                Spacer()
                Text(comment.date, style: .offset) + Text(" ago")
            }
            
            Text(comment.text)
                .padding(5)
                .font(Font.custom("SpecialElite-Regular", size: 20))
        }
        .padding()
        .background(Color(red: 0.924, green: 0.639, blue: 0.749))
        .foregroundStyle(Color(red: 0.44, green: -0.051, blue: 0.328))
        .font(Font.custom("SpecialElite-Regular", size: 15))     
    }
}

#Preview {
    CommentMetadata(author: Author(
        id: "0",
        displayName: "taylor !!",
        bio: "please send help",
        profilePhotoURL: URL(string:"https://firebasestorage.googleapis.com:443/v0/b/fir-mobile-5302f.appspot.com/o/article%2F9O7H4xU8TvLN726AFGdm?alt=media&token=645d9c09-e632-409f-95dc-7e7477592533")!,
        bannerPhotoURL: URL(string:"https://firebasestorage.googleapis.com:443/v0/b/fir-mobile-5302f.appspot.com/o/article%2F9O7H4xU8TvLN726AFGdm?alt=media&token=645d9c09-e632-409f-95dc-7e7477592533")!
    ), comment: Comment(id: "0", uid: "0", date: Date(), text: "idk man"))
}
