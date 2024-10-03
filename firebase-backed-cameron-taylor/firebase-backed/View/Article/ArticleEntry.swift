/**
 * ArticleEntry is a view for creating a new article.
 */
import SwiftUI

struct ArticleEntry: View {
    @EnvironmentObject var auth: BlogAuth
    @EnvironmentObject var articleService: BlogArticle
    @EnvironmentObject var storage: BlogStorage
    
    @Binding var articles: [Article]
    @Binding var authors: [Author]
    @Binding var writing: Bool
    
    @State private var error: Bool = false
    @State var fetching: Bool = false
    
    @State var currentUser: Author
    
    @State private var title = ""
    @State private var articleBody = ""
    @State private var selectedImage: UIImage? = nil
    @State private var selectedImageURL: URL = URL(string: "IMG_3574.jpg")!
    @State private var showingImagePicker = false
    
    func submitArticle() async {
        fetching = true
        let articleId = articleService.createArticle(article: Article(
            id: UUID().uuidString,
            title: title,
            date: Date(),
            body: articleBody,
            score: 0,
            uid: auth.user?.uid ?? "0",
            favorites: [],
            photoURL: selectedImageURL.absoluteString
        ))
        let article = Article(
            id: articleId,
            title: title,
            date: Date(),
            body: articleBody,
            score: 0,
            uid: auth.user?.uid ?? "0",
            favorites: [],
            photoURL: selectedImageURL.absoluteString
        )
        
        let photoURLResult = await withCheckedContinuation { continuation in
            storage.uploadArticlePhoto(article: article, url: selectedImageURL) { result in
                continuation.resume(returning: result)
            }
        }
        
        guard case let .success(photoURL) = photoURLResult else {
            error = true
            return
        }
        
        let updatedArticle = try? articleService.updateArticle(id: articleId, title: title, body: articleBody, photoURL: photoURL.absoluteString, article: article)
        articles.insert(updatedArticle!, at: 0)
        
        authors.insert(currentUser, at: 0)
        
        writing = false
        fetching = false
    }
    
    var body: some View {
        NavigationView {
            if fetching {
                ProgressView()
            }
            if error {
                ErrorView()
            }
            else {
                ScrollView {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 150)
                            .clipped()
                    } else {
                        Button(action: {
                            showingImagePicker = true
                        }) {
                            BannerImage(imageURL: selectedImageURL, height: 150)
                                .overlay(
                                    Image(systemName: "pencil.circle.fill")
                                        .foregroundStyle(Color(red: 0.91, green: 0.324, blue: 0.57))
                                        .font(.system(size: 60))
                                )
                        }
                    }
                    
                    VStack(spacing: 0) {
                        Text("Title")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundStyle(Color(red: 0.924, green: 0.639, blue: 0.749))
                            .background(Color(red: 0.44, green: -0.051, blue: 0.328))
                        TextField("", text: $title)
                            .font(Font.custom("SpecialElite-Regular", size: 15))
                            .padding(10)
                            .background(Color(red: 0.924, green: 0.639, blue: 0.749))
                            .padding(.bottom, 40)
                    }
                    
                    VStack(spacing: 0) {
                        Text("Body")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundStyle(Color(red: 0.924, green: 0.639, blue: 0.749))
                            .background(Color(red: 0.44, green: -0.051, blue: 0.328))
                        TextEditor(text: $articleBody)
                            .scrollContentBackground(.hidden)
                            .font(Font.custom("SpecialElite-Regular", size: 15))
                            .background(Color(red: 0.924, green: 0.639, blue: 0.749))
                            .frame(minHeight: 256, maxHeight: .infinity)
                    }
                }
                .font(Font.custom("Rockin'-Record", size: 20))
                .padding(10)
                .foregroundStyle(Color(red: -0.046, green: 0.137, blue: 0.227))
                .navigationTitle("New Article")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            writing = false
                        }
                    }
                    
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button("Submit") {
                            Task {
                                await submitArticle()
                            }
                        }
                        .disabled(title.isEmpty || articleBody.isEmpty || selectedImage == nil)
                    }
                }
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(selectedImage: $selectedImage, selectedImageURL: $selectedImageURL)
                }
            }
        }
    }
}

//struct ArticleEntry_Previews: PreviewProvider {
//    @State static var articles: [Article] = []
//    @State static var writing = false
//
//    static var previews: some View {
//        ArticleEntry(articles: $articles, writing: $writing)
//            .environmentObject(BlogAuth())
//            .environmentObject(BlogArticle())
//            .environmentObject(BlogStorage())
//    }
//}
