/**
 * ArticleDetail displays a single article model object.
 */
import SwiftUI

struct ArticleDetail: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var auth: BlogAuth
    @EnvironmentObject var articleService: BlogArticle
    @EnvironmentObject var storage: BlogStorage
    
    @Binding var editing: Bool
    @Binding var articles: [Article]
    @Binding var authors: [Author]
    @State private var comments: [Comment] = []
    @State private var commentAuthors: [Author] = []
    @State private var text: String = ""
    @State var article: Article
    @State var imageURL: URL = URL(string: "https://tr.rbxcdn.com/38c6edcb50633730ff4cf39ac8859840/420/420/Hat/Png")!
    @State var buttonTapped = false
    @State var fetching = false
    
    @State var author = Author(
        id: "0",
        displayName: "default",
        bio: "default",
        profilePhotoURL: URL(string: "https://tr.rbxcdn.com/38c6edcb50633730ff4cf39ac8859840/420/420/Hat/Png")!,
        bannerPhotoURL: URL(string: "https://tr.rbxcdn.com/38c6edcb50633730ff4cf39ac8859840/420/420/Hat/Png")!)
    
    @State var currentUser = Author(
        id: "0",
        displayName: "default",
        bio: "default",
        profilePhotoURL: URL(string: "https://tr.rbxcdn.com/38c6edcb50633730ff4cf39ac8859840/420/420/Hat/Png")!,
        bannerPhotoURL: URL(string: "https://tr.rbxcdn.com/38c6edcb50633730ff4cf39ac8859840/420/420/Hat/Png")!)
    
    func submitComment() {
        let commentId = articleService.addComment(article: article, comment: Comment(
            id: UUID().uuidString,
            uid: auth.user?.uid ?? "",
            date: Date(),
            text: text
        ))
        let comment = Comment(
            id: commentId,
            uid: auth.user?.uid ?? "",
            date: Date(),
            text: text
        )
        comments.insert(comment, at: 0)
        commentAuthors.insert(currentUser, at: 0)
        text = ""
    }
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    
                    Button("Edit", systemImage: "pencil") {
                        editing = true
                    }
                    .opacity(auth.user?.uid == article.uid ? 1 : 0)
                    .foregroundColor(/*@START_MENU_TOKEN@*/Color(red: 0.44, green: -0.051, blue: 0.328)/*@END_MENU_TOKEN@*/)
                    
                    Button("Delete", systemImage: "trash") {
                        let index = articles.firstIndex(of: article)
                        articleService.deleteArticle(article: article)
                        articles.remove(at: index!)
                        authors.remove(at: index!)
                        
                        presentationMode.wrappedValue.dismiss()
                        
                    }
                    .opacity(auth.user?.uid == article.uid ? 1 : 0)
                    .foregroundColor(Color(red: 0.701, green: 0.204, blue: 0.424))
                }
                .font(Font.custom("SpecialElite-Regular", size: 20))
                .padding(.horizontal, 50)
                
                BannerImage(imageURL: URL(string: article.photoURL)!, height: 100)
                    .padding(10)
                    .contentShape(Rectangle())
                
                ArticleLayout(article: article, author: author)
                    .padding(10)
                
                HStack (alignment: .center){
                    Button(action: {
                        self.buttonTapped.toggle()
                        let updatedArticle = try? articleService.updateScore(article: article, userUID: auth.user!.uid)
                        let index = articles.firstIndex(of: article)
                        articles[index!] = updatedArticle!
                        article = updatedArticle!
                    }) {
                        FavoriteButton(buttonTapped: $buttonTapped)
                    }
                    .disabled(buttonTapped || auth.user?.uid == nil || article.favorites.contains(auth.user!.uid))
                    
                    Text(String(article.score))
                        .font(Font.custom("SpecialElite-Regular", size: 20))
                        .foregroundStyle(buttonTapped ? Color(red: 140/255, green: 120/255, blue: 80/255) : .gray)
                        .scaleEffect(buttonTapped ? 1 : 0.85)
                        .animation(.bouncy, value: buttonTapped)
                    
                    if auth.user?.uid == nil {
                        Text("Please sign in to favorite :)")
                            .font(Font.custom("SpecialElite-Regular", size: 13))
                            .foregroundStyle(Color(red: -0.046, green: 0.137, blue: 0.227))
                            .padding(.leading, 50)
                    }
                    Spacer()
                    
                }
                .padding(.leading, 20)
                .padding(.bottom, 50)
                
                VStack (alignment: .trailing){
                    Text("Comments")
                        .font(Font.custom("Rockin'-Record", size: 35))
                        .padding(10)
                        .foregroundColor(Color(red: 0.924, green: 0.639, blue: 0.749))
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.44, green: -0.051, blue: 0.328))
                    
                    if auth.user != nil {
                        TextField("Leave a comment...", text: $text, axis: .vertical)
                            .textFieldStyle(.plain)
                            .lineLimit(2...10)
                            .padding()
                            .font(Font.custom("SpecialElite-Regular", size: 20))
                            .tint(Color(red: 0.44, green: -0.051, blue: 0.328))
                            .foregroundStyle(Color(red: -0.046, green: 0.137, blue: 0.227))
                            .background(RoundedRectangle(cornerRadius:5)
                                .strokeBorder(Color(red: -0.046, green: 0.137, blue: 0.227), lineWidth: 2))
                        
                        Button(action: {
                            submitComment()
                        }) {
                            Text("Post")
                                .padding(5)
                                .font(Font.custom("Rockin' Record", size: 20))
                                .foregroundStyle(Color(red: 0.924, green: 0.639, blue: 0.749))
                                .background(Color(red: -0.046, green: 0.137, blue: 0.227))
                        }
                    }
                    if comments.isEmpty {
                        HStack {
                            Spacer()
                            Text("No Comments...")
                            Spacer()
                        }
                        .font(Font.custom("SpecialElite-Regular", size: 20))
                        .foregroundStyle(Color(red: -0.046, green: 0.137, blue: 0.227))
                        .padding(.vertical, 20)
                        
                    } else if commentAuthors.isEmpty || fetching {
                        ProgressView()
                    } else {
                        ForEach(comments.indices, id: \.self) { index in
                            CommentMetadata(
                                author: commentAuthors[index],
                                comment: comments[index])
                        }
                    }
                    
                }
                .padding()
                .sheet(isPresented: $editing) {
                    EditArticle(article: $article, articles: $articles, imageURL: $imageURL, editing: $editing)
                }
            }
            .padding(.top)
        }
        .background(Color(red: 0.856, green: 0.826, blue: 0.805))
        .toolbarTitleDisplayMode(.inline)
        .onAppear(perform: {
            imageURL = URL(string: article.photoURL)!
            Task {
                do {
                    fetching = true
                    author = await articleService.fetchUser(uid: article.uid)
                    comments = try await articleService.fetchComments(id: article.id)
                    
                    for comment in comments {
                        let author = await articleService.fetchUser(uid: comment.uid)
                        commentAuthors.append(author)
                    }
                    
                    if auth.user?.uid != nil {
                        if article.favorites.contains(auth.user!.uid) {
                            buttonTapped = true
                        }
                        
                        currentUser = await articleService.fetchUser(uid: auth.user!.uid)
                        
                    }
                    fetching = false
                } catch {
                    author = Author(
                        id: "0",
                        displayName: "default",
                        bio: "default",
                        profilePhotoURL: URL(string: "https://tr.rbxcdn.com/38c6edcb50633730ff4cf39ac8859840/420/420/Hat/Png")!,
                        bannerPhotoURL: URL(string: "https://tr.rbxcdn.com/38c6edcb50633730ff4cf39ac8859840/420/420/Hat/Png")!)
                    
                }
            }
        })
    }
}

//struct ArticleDetail_Previews: PreviewProvider {
//    @State static var editing = false
//    @State static var articles = [
//        Article(
//            id: "12345",
//            title: "Preview",
//            date: Date(),
//            body: "Lorem ipsum dolor sit something something amet",
//            score: 0,
//            uid: "test",
//            favorites: [],
//            photoURL: "https://firebasestorage.googleapis.com:443/v0/b/fir-mobile-5302f.appspot.com/o/article%2F9O7H4xU8TvLN726AFGdm?alt=media&token=645d9c09-e632-409f-95dc-7e7477592533"
//        ),
//
//        Article(
//            id: "67890",
//            title: "Some time ago",
//            date: Date(timeIntervalSinceNow: TimeInterval(-604800)),
//            body: "Duis diam ipsum, efficitur sit amet something somesit amet",
//            score: 0,
//            uid: "test",
//            favorites: [],
//            photoURL: "https://firebasestorage.googleapis.com:443/v0/b/fir-mobile-5302f.appspot.com/o/article%2F9O7H4xU8TvLN726AFGdm?alt=media&token=645d9c09-e632-409f-95dc-7e7477592533"
//        )
//    ]
//
//
//    static var previews: some View {
//        ArticleDetail(editing: $editing, articles: $articles, article: Article(
//            id: "12345",
//            title: "Preview",
//            date: Date(),
//            body: "Lorem ipsum dolor sit something something amet",
//            score: 0,
//            uid: "test",
//            favorites: [],
//            photoURL: "https://firebasestorage.googleapis.com:443/v0/b/fir-mobile-5302f.appspot.com/o/article%2F9O7H4xU8TvLN726AFGdm?alt=media&token=645d9c09-e632-409f-95dc-7e7477592533"
//        ))
//        .environmentObject(BlogAuth())
//        .environmentObject(BlogArticle())
//        .environmentObject(BlogStorage())
//    }
//}
