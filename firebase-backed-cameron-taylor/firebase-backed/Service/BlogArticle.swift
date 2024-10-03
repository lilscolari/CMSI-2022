/**
 * BareBonesBlogArticle is the article service—it completely hides the data store from the rest of the app.
 * No other part of the app knows how the data is stored. If anyone wants to read or write data, they have
 * to go through this service.
 */
import Foundation

import Firebase

let COLLECTION_NAME = "articles"
let PAGE_LIMIT = 20

enum ArticleServiceError: Error {
    case mismatchedDocumentError
    case unexpectedError
}

class BlogArticle: ObservableObject {
    private let db = Firestore.firestore()
    
    
    var data: [Article] = []
    
    var lastDoc: QueryDocumentSnapshot!
    
    
    // Some of the iOS Firebase library’s methods are currently a little…odd.
    // They execute synchronously to return an initial result, but will then
    // attempt to write to the database across the network asynchronously but
    // not in a way that can be checked via try async/await. Instead, a
    // callback function is invoked containing an error _if it happened_.
    // They are almost like functions that return two results, one synchronously
    // and another asynchronously.
    //
    // To deal with this, we have a published variable called `error` which gets
    // set if a callback function comes back with an error. SwiftUI views can
    // access this error and it will update if things change.
    @Published var error: Error?
    
    func createArticle(article: Article) -> String {
        var ref: DocumentReference? = nil
        
        // addDocument is one of those “odd” methods.
        ref = db.collection(COLLECTION_NAME).addDocument(data: [
            "title": article.title,
            "date": article.date, // This gets converted into a Firestore Timestamp.
            "body": article.body,
            "score": article.score,
            "uid": article.uid,
            "favorites": article.favorites,
            "photoURL": article.photoURL
        ]) { possibleError in
            if let actualError = possibleError {
                self.error = actualError
            }
        }
        
        // If we don’t get a ref back, return an empty string to indicate “no ID.”
        return ref?.documentID ?? ""
    }
    
    // Note: This is quite unsophisticated! It only gets the first PAGE_LIMIT articles.
    // In a real app, you implement pagination.
    func fetchArticles(selection: String, pageNumber: Int, articles: [Article]) async throws -> [Article] {
        
        var articleQuery: Query
        var index: Int = 0
        if pageNumber != 1 {
            index = ((pageNumber - 1) * PAGE_LIMIT) - 1
        }
        
        if selection == "Score ↑" {
            let startScore = articles[index].score
            if pageNumber == 1 {
                articleQuery = db.collection(COLLECTION_NAME)
                    .order(by: "score", descending: false)
                    .limit(to: PAGE_LIMIT)
            } else {
                articleQuery = db.collection(COLLECTION_NAME)
                    .order(by: "score", descending: false)
                    .start(after: [startScore])
                    .limit(to: PAGE_LIMIT)
            }
        }
        else if selection == "Score ↓" {
            let articles = articles.sorted { $0.score > $1.score }
            if pageNumber == 1 {
                articleQuery = db.collection(COLLECTION_NAME)
                    .order(by: "score", descending: true)
                    .limit(to: PAGE_LIMIT)
            } else {
                articleQuery = db.collection(COLLECTION_NAME)
                    .order(by: "score", descending: true)
                    .start(after: [articles.last!.score])
                    .limit(to: PAGE_LIMIT)
            }
        }
        else if selection == "Date" {
            let startDate = articles[index].date
            if pageNumber == 1 {
                articleQuery = db.collection(COLLECTION_NAME)
                    .order(by: "date", descending: true)
                    .limit(to: PAGE_LIMIT)
            } else {
                articleQuery = db.collection(COLLECTION_NAME)
                    .order(by: "date", descending: true)
                    .start(after: [startDate])
                    .limit(to: PAGE_LIMIT)
            }
        }
        else {
            if pageNumber == 1 {
                articleQuery = db.collection(COLLECTION_NAME)
                    .order(by: "uid", descending: true)
                    .limit(to: PAGE_LIMIT)
            } else {
                articleQuery = db.collection(COLLECTION_NAME)
                    .order(by: "uid", descending: true)
                    .start(after: [articles.last!.uid])
                    .limit(to: PAGE_LIMIT)
            }
        }
        
        if let lastSnapshot = lastDoc, pageNumber > 1 {
            articleQuery = articleQuery.start(afterDocument: lastSnapshot)
        }
        
        articleQuery.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error with pagination")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.lastDoc = documents.last
        }
        
        
        // Fortunately, getDocuments does have an async version.
        //
        // Firestore calls query results “snapshots” because they represent a…wait for it…
        // _snapshot_ of the data at the time that the query was made. (i.e., the content
        // of the database may change after the query but you won’t see those changes here)
        let querySnapshot = try await articleQuery.getDocuments()
        
        return try querySnapshot.documents.map {
            // This is likely new Swift for you: type conversion is conditional, so they
            // must be guarded in case they fail.
            guard let title = $0.get("title") as? String,
                  
                    // Firestore returns Swift Dates as its own Timestamp data type.
                  let dateAsTimestamp = $0.get("date") as? Timestamp,
                  let score = $0.get("score") as? Int,
                  let uid = $0.get("uid") as? String,
                  let body = $0.get("body") as? String,
                  let favorites = $0.get("favorites") as? [String],
                  let photoURL = $0.get("photoURL") as? String else {
                
                throw ArticleServiceError.mismatchedDocumentError
            }
            
            return Article(
                id: $0.documentID,
                title: title,
                date: dateAsTimestamp.dateValue(),
                body: body,
                score: score,
                uid: uid,
                favorites: favorites,
                photoURL: photoURL
            )
        }
    }
    
    func updateArticle(id: String, title: String, body: String, photoURL: String, article: Article) throws -> Article {
        db.collection(COLLECTION_NAME).document(id).setData([
            "title": title,
            "date": article.date,
            "body": body,
            "score": article.score,
            "uid": article.uid,
            "favorites": article.favorites,
            "photoURL": photoURL
        ]) { possibleError in
            if let actualError = possibleError {
                self.error = actualError
            }
        }
        
        return Article(
            id: id,
            title: title,
            date: article.date,
            body: body,
            score: article.score,
            uid: article.uid,
            favorites: article.favorites,
            photoURL: photoURL
        )
    }
    
    func deleteArticle(article: Article)  {
        db.collection(COLLECTION_NAME).document(article.id).delete()
        
    }
    func updateScore(article: Article, userUID: String) throws -> Article {
        db.collection(COLLECTION_NAME).document(article.id).setData([
            "title": article.title,
            "date": article.date,
            "body": article.body,
            "score": article.score + 1,
            "uid": article.uid,
            "favorites": article.favorites + [userUID],
            "photoURL": article.photoURL
        ]) { possibleError in
            if let actualError = possibleError {
                self.error = actualError
            }
        }
        
        return Article(
            id: article.id,
            title: article.title,
            date: article.date,
            body: article.body,
            score: article.score + 1,
            uid: article.uid,
            favorites: article.favorites + [userUID],
            photoURL: article.photoURL
        )
    }
    
    
    func searchArticles(query: String) async throws -> [Article] {
        
        let articleQuery = db.collection(COLLECTION_NAME)
            .order(by: "date", descending: true)
            .limit(to: PAGE_LIMIT)
        
        // Fortunately, getDocuments does have an async version.
        //
        // Firestore calls query results “snapshots” because they represent a…wait for it…
        // _snapshot_ of the data at the time that the query was made. (i.e., the content
        // of the database may change after the query but you won’t see those changes here)
        let querySnapshot = try await articleQuery.getDocuments()
        
        return try querySnapshot.documents
            .filter { document in
                if let title = document.get("title") as? String {
                    return title.lowercased().contains(query.lowercased())
                }
                return false
            }
            .map {
                // This is likely new Swift for you: type conversion is conditional, so they
                // must be guarded in case they fail.
                guard let title = $0.get("title") as? String,
                      
                        // Firestore returns Swift Dates as its own Timestamp data type.
                      let dateAsTimestamp = $0.get("date") as? Timestamp,
                      let score = $0.get("score") as? Int,
                      let uid = $0.get("uid") as? String,
                      let body = $0.get("body") as? String,
                      let favorites = $0.get("favorites") as? [String],
                      let photoURL = $0.get("photoURL") as? String else {
                    
                    throw ArticleServiceError.mismatchedDocumentError
                }
                
                return Article(
                    id: $0.documentID,
                    title: title,
                    date: dateAsTimestamp.dateValue(),
                    body: body,
                    score: score,
                    uid: uid,
                    favorites: favorites,
                    photoURL: photoURL
                )
            }
    }
    
    func addUserData(author: Author) -> Author {
        db.collection("users").document(author.id).setData([
            "id": author.id,
            "displayName": author.displayName,
            "bio": author.bio,
            "profilePhotoURL": author.profilePhotoURL.absoluteString,
            "bannerPhotoURL": author.bannerPhotoURL.absoluteString,
        ]) { possibleError in
            if let actualError = possibleError {
                self.error = actualError
            }
        }
        return Author(
            id: author.id,
            displayName: author.displayName,
            bio: author.bio,
            profilePhotoURL: author.profilePhotoURL,
            bannerPhotoURL: author.bannerPhotoURL
        )
    }
    
    func fetchUser(uid: String) async -> Author {
        do {
            let docRef = db.collection("users").document(uid)
            let document = try await docRef.getDocument()
            guard let id = document.get("id") as? String,
                  let displayName = document.get("displayName") as? String,
                  let bio = document.get("bio") as? String,
                  let profilePhotoURL = document.get("profilePhotoURL") as? String,
                  let bannerPhotoURL = document.get("bannerPhotoURL") as? String else {
                throw ArticleServiceError.mismatchedDocumentError
            }
            return Author(
                id: id,
                displayName: displayName,
                bio: bio,
                profilePhotoURL: URL(string: profilePhotoURL) ?? URL(string: "https://tr.rbxcdn.com/38c6edcb50633730ff4cf39ac8859840/420/420/Hat/Png")!,
                bannerPhotoURL: URL(string: bannerPhotoURL) ?? URL(string: "https://tr.rbxcdn.com/38c6edcb50633730ff4cf39ac8859840/420/420/Hat/Png")!
            )
        } catch {
            return Author(
                id: "default",
                displayName: "default",
                bio: "default",
                profilePhotoURL: URL(string: "https://tr.rbxcdn.com/38c6edcb50633730ff4cf39ac8859840/420/420/Hat/Png")!,
                bannerPhotoURL: URL(string: "https://tr.rbxcdn.com/38c6edcb50633730ff4cf39ac8859840/420/420/Hat/Png")!
            )
        }
    }
    
    func addComment(article: Article, comment: Comment) -> String {
        var ref: DocumentReference? = nil
        
        // addDocument is one of those “odd” methods.
        ref = db.collection("\(COLLECTION_NAME)/\(article.id)/comments").addDocument(data: [
            "uid": comment.uid,
            "date": comment.date,
            "text": comment.text,
        ]) { possibleError in
            if let actualError = possibleError {
                self.error = actualError
            }
        }
        
        // If we don’t get a ref back, return an empty string to indicate “no ID.”
        return ref?.documentID ?? ""
    }
    
    func fetchComments(id: String) async throws -> [Comment] {
        let articleQuery = db.collection("\(COLLECTION_NAME)/\(id)/comments")
            .order(by: "date", descending: true)
            .limit(to: PAGE_LIMIT)
        
        let querySnapshot = try await articleQuery.getDocuments()
        
        return try querySnapshot.documents.map {
            
            guard let uid = $0.get("uid") as? String,
                  let dateAsTimestamp = $0.get("date") as? Timestamp,
                  let text = $0.get("text") as? String else {
                
                throw ArticleServiceError.mismatchedDocumentError
            }
            
            return Comment(
                id: $0.documentID,
                uid: uid,
                date: dateAsTimestamp.dateValue(),
                text: text
            )
        }
    }
}
