//
//  BlogStorage.swift
//  firebase-backed
//
//  Created by keckuser on 3/18/24.
//

import Foundation
import UIKit
import FirebaseStorage

class BlogStorage: ObservableObject {
    private let storage = Storage.storage().reference()
    
    func uploadArticlePhoto(article: Article, url: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        let storageRef = storage.child("article/\(article.id)")
        storageRef.putFile(from: url, metadata: nil) { metadata, error in
            guard let _ = metadata else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(NSError(domain: "uploadArticlePhoto", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"])))
                }
                return
            }
            
            storageRef.downloadURL { url, error in
                if let url = url {
                    completion(.success(url))
                } else if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(NSError(domain: "uploadArticlePhoto", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"])))
                }
            }
        }
    }
    
    func fetchArticlePhoto(article: Article) async -> URL {
        do {
            let url = try await storage.child("article/\(article.id)").downloadURL()
            return url
        } catch {
            return URL(string: "https://firebasestorage.googleapis.com/v0/b/fir-mobile-5302f.appspot.com/o/default_image.png?alt=media&token=your_default_token")!
        }
    }
    
    func uploadProfilePhoto(uid: String, url: URL) {
        storage.child("author/pfp/\(uid)").putFile(from: url)
    }
    
    func fetchProfilePhoto(uid: String) async -> URL {
        do {
            let url = try await storage.child("author/pfp/\(uid)").downloadURL()
            return url
        } catch {
            return URL(string: "https://firebasestorage.googleapis.com/v0/b/fir-mobile-5302f.appspot.com/o/default_image.png?alt=media&token=your_default_token")!
        }
    }
    
    func uploadBannerPhoto(uid: String, url: URL) {
        storage.child("author/banner/\(uid)").putFile(from: url)
    }
    
    func fetchBannerPhoto(uid: String) async -> URL {
        do {
            let url = try await storage.child("author/banner/\(uid)").downloadURL()
            return url
        } catch {
            return URL(string: "https://firebasestorage.googleapis.com/v0/b/fir-mobile-5302f.appspot.com/o/default_image.png?alt=media&token=your_default_token")!
        }
    }
}
