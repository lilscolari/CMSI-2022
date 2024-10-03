//
//  EditArticle.swift
//  firebase-backed
//
//  Created by Taylor Musso on 3/13/24.
//

import SwiftUI

struct EditArticle: View {
    @EnvironmentObject var auth: BlogAuth
    @EnvironmentObject var articleService: BlogArticle
    @EnvironmentObject var storage: BlogStorage
    
    @Binding var article: Article
    @Binding var articles: [Article]
    @Binding var imageURL: URL
    @Binding var editing: Bool
    
    @State var title = ""
    @State var articleBody = ""
    @State var error: Bool = false
    @State private var selectedImage: UIImage? = nil
    @State private var selectedImageURL: URL = URL(string: "IMG_3574.jpg")!
    @State private var showingImagePicker = false
    
    @State var fetching: Bool = false
    
    
    func editArticle() async {
        fetching = true
        let photoURLResult = await withCheckedContinuation { continuation in
            storage.uploadArticlePhoto(article: article, url: selectedImageURL) { result in
                continuation.resume(returning: result)
            }
        }
        
        guard case let .success(photoURL) = photoURLResult else {
            error = true
            return
        }
        let updatedArticle = try? articleService.updateArticle(
            id: article.id,
            title: title,
            body: articleBody,
            photoURL: photoURL.absoluteString,
            article: article
        )
        
        let index = articles.firstIndex(of: article)
        articles[index!] = updatedArticle!
        imageURL = photoURL
        
        article = updatedArticle!
        editing = false
        
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
                .navigationTitle("Edit Article")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            editing = false
                        }
                    }
                    
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button("Submit") {
                            Task {
                                await editArticle()
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
        .onAppear( perform:{
            title = article.title
            articleBody = article.body
        })
    }
}

struct EditArticle_Previews: PreviewProvider {
    @State static var articles: [Article] = []
    @State static var imageURL: URL = URL(string: "https://tr.rbxcdn.com/38c6edcb50633730ff4cf39ac8859840/420/420/Hat/Png")!
    @State static var editing = true
    @State static var article: Article = Article(
        id: "12345",
        title: "Preview",
        date: Date(),
        body: "Lorem ipsum dolor sit something something amet",
        score: 0,
        uid: "0",
        favorites: [],
        photoURL: "https://tr.rbxcdn.com/38c6edcb50633730ff4cf39ac8859840/420/420/Hat/Png"
    )
    
    static var previews: some View {
        EditArticle(article: $article,
                    articles: $articles, imageURL: $imageURL, editing: $editing)
        .environmentObject(BlogAuth())
        .environmentObject(BlogArticle())
    }
}
