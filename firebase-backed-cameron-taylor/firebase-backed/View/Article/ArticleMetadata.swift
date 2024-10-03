/**
 * ArticleMetadata is a view that displays side information about its given article.
 */
import SwiftUI

struct ArticleMetadata: View {
    var article: Article
    var authorName: String
    
    var body: some View {
        HStack() {
            AsyncImage(url: URL(string: article.photoURL)!) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipped()
                } else if phase.error != nil {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipped()
                } else {
                    ProgressView()
                        .frame(width: 60, height: 60)
                }
            }
            VStack(alignment: .leading) {
                Text(authorName)
                    .font(Font.custom("SpecialElite-Regular", size: 15))
                Text("")
                Text(article.title)
                    .font(Font.custom("Rockin'-Record", size: 20))
            }
            .padding(.vertical, 5)
            
            
            Spacer()
            Text(Image(systemName: "star.fill")) + Text(" " + String(article.score))
                .font(Font.custom("SpecialElite-Regular", size: 20))
        }
    }
}

#Preview {
    ArticleMetadata(article: Article(
        id: "12345",
        title: "Preview",
        date: Date(),
        body: "Lorem ipsum dolor sit something something amet",
        score: 0,
        uid: "3141592653589793238462643383279502",
        favorites: [],
        photoURL: "https://tr.rbxcdn.com/38c6edcb50633730ff4cf39ac8859840/420/420/Hat/Png"
    ), authorName: "default")
}
