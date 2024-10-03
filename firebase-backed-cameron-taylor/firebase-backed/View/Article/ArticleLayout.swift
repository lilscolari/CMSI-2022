//
//  ArticleLayout.swift
//  firebase-backed
//
//  Created by Taylor Musso on 3/18/24.
//

import SwiftUI

struct ArticleLayout: View {
    var article: Article
    var author: Author
    
    var body: some View {
        VStack (spacing: 0) {
            Text(article.title)
                .font(Font.custom("Rockin'-Record", size: 50))
                .padding(10)
                .foregroundColor(Color(red: 0.924, green: 0.639, blue: 0.749))
                .frame(maxWidth: .infinity)
                .background(Color(red: -0.046, green: 0.137, blue: 0.227))
            
            HStack {
                ProfileImage(imageURL: author.profilePhotoURL, backgroundColor: Color(red: 0.44, green: -0.051, blue: 0.328), width: 40, height: 40)
                Text(String(author.displayName))
                    .font(Font.custom("SpecialElite-Regular", size: 20))
                Spacer()
                VStack(alignment: .trailing) {
                    Text(article.date, style: .date)
                    
                    Text(article.date, style: .time)
                    
                }
            }
            .font(Font.custom("SpecialElite-Regular", size: 14))
            .padding(5)
            .background(Color(red: 0.44, green: -0.051, blue: 0.328))
            .foregroundColor(Color(red: 0.924, green: 0.639, blue: 0.749))
            
            Text(article.body)
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(Color(red: -0.046, green: 0.137, blue: 0.227))
                .background(Color(red: 0.924, green: 0.639, blue: 0.749))
                .font(Font.custom("SpecialElite-Regular", size: 20))
        }
    }
}

//#Preview {
//    ArticleLayout(article: Article(
//        id: "12345",
//        title: "Preview",
//        date: Date(),
//        body: "Lorem ipsum dolor sit something something amet",
//        score: 0,
//        author: "display name 1",
//        uid: "test",
//        favorites: [],
//        photoURL: "https://firebasestorage.googleapis.com:443/v0/b/fir-mobile-5302f.appspot.com/o/article%2F9O7H4xU8TvLN726AFGdm?alt=media&token=645d9c09-e632-409f-95dc-7e7477592533"
//    ), imageURL: URL(string: "https://firebasestorage.googleapis.com:443/v0/b/fir-mobile-5302f.appspot.com/o/article%2F9O7H4xU8TvLN726AFGdm?alt=media&token=645d9c09-e632-409f-95dc-7e7477592533")!)
//}
