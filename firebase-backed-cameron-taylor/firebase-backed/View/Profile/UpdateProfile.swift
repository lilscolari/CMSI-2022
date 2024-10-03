//
//  UpdateProfile.swift
//  firebase-backed
//
//  Created by Taylor Musso on 3/21/24.
//

import SwiftUI

struct UpdateProfile: View {
    @EnvironmentObject var auth: BlogAuth
    @EnvironmentObject var articleService: BlogArticle
    @EnvironmentObject var storage: BlogStorage
    @Binding var editProfile: Bool
    
    @Binding var author: Author
    
    @State private var displayName = ""
    @State private var bio = ""
    @State private var selectedProfileImage: UIImage? = nil
    @State private var selectedProfileImageURL: URL = URL(string: "https://tr.rbxcdn.com/38c6edcb50633730ff4cf39ac8859840/420/420/Hat/Png")!
    @State private var selectedBannerImage: UIImage? = nil
    @State private var selectedBannerImageURL: URL = URL(string: "https://tr.rbxcdn.com/38c6edcb50633730ff4cf39ac8859840/420/420/Hat/Png")!
    @State private var showingProfileImagePicker = false
    @State private var showingBannerImagePicker = false
    
    func submitProfile() {
        storage.uploadProfilePhoto(uid: author.id, url: selectedProfileImageURL)
        storage.uploadBannerPhoto(uid: author.id, url: selectedBannerImageURL)
        Task {
            let profileURL = await storage.fetchProfilePhoto(uid: author.id)
            let bannerURL = await storage.fetchBannerPhoto(uid: author.id)
            
            auth.updateProfile(currentUser: auth.user!, displayName: displayName, photoURL: profileURL)
            author = articleService.addUserData(author: Author(id: author.id, displayName: displayName, bio: bio, profilePhotoURL: profileURL, bannerPhotoURL: bannerURL))
        }
        
        editProfile = false
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack (alignment: .leading) {
                    Button(action: {
                        showingBannerImagePicker = true
                    }) {
                        BannerImage(imageURL: selectedBannerImage != nil ? selectedBannerImageURL : author.bannerPhotoURL, height: 150)
                            .overlay(
                                Image(systemName: "pencil.circle.fill")
                                    .foregroundStyle(Color(red: 0.91, green: 0.324, blue: 0.57))
                                    .font(.system(size: 60))
                            )
                    }
                    
                    Button(action: {
                        showingProfileImagePicker = true
                    }) {
                        ProfileImage(imageURL: selectedProfileImage != nil ? selectedProfileImageURL : author.profilePhotoURL, backgroundColor: Color(red: 0.856, green: 0.826, blue: 0.805), width: 100, height: 100)
                            .overlay(
                                Image(systemName: "pencil.circle.fill")
                                    .foregroundStyle(Color(red: 0.91, green: 0.324, blue: 0.57))
                                    .font(.system(size: 40))
                            )
                            .padding(.top, 150)
                            .padding(.leading, 10)
                    }
                }
                .padding(.top, -50)
                ScrollView {
                    
                    VStack (spacing: 0) {
                        Text("Display Name")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundStyle(Color(red: 0.924, green: 0.639, blue: 0.749))
                            .background(Color(red: 0.44, green: -0.051, blue: 0.328))
                        TextField("", text: $displayName)
                            .font(Font.custom("SpecialElite-Regular", size: 15))
                            .padding(10)
                            .background(Color(red: 0.924, green: 0.639, blue: 0.749))
                            .padding(.bottom, 40)
                    }
                                   
                    VStack (spacing: 0) {
                        Text("Bio")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundStyle(Color(red: 0.924, green: 0.639, blue: 0.749))
                            .background(Color(red: 0.44, green: -0.051, blue: 0.328))
                        TextEditor(text: $bio)
                            .scrollContentBackground(.hidden)
                            .font(Font.custom("SpecialElite-Regular", size: 15))
                            .background(Color(red: 0.924, green: 0.639, blue: 0.749))
                            .frame(minHeight: 256, maxHeight: .infinity)
                    }
                }
                .font(Font.custom("Rockin'-Record", size: 20))
                .padding(10)
                .foregroundStyle(Color(red: -0.046, green: 0.137, blue: 0.227))
                .navigationTitle("Edit Profile")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            editProfile = false
                        }
                    }
                    
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button("Submit") {
                            submitProfile()
                        }
                        .disabled(displayName.isEmpty || bio.isEmpty || selectedProfileImage == nil || selectedBannerImage == nil)
                    }
                }
                .sheet(isPresented: $showingProfileImagePicker) {
                    ImagePicker(selectedImage: $selectedProfileImage, selectedImageURL: $selectedProfileImageURL)
                }
                .sheet(isPresented: $showingBannerImagePicker) {
                    ImagePicker(selectedImage: $selectedBannerImage, selectedImageURL: $selectedBannerImageURL)
                }
            }
            .background(Color(red: 0.856, green: 0.826, blue: 0.805))
        }
        .onAppear( perform:{
            displayName = author.displayName
            bio = author.bio
        })
    }
}

struct UpdateProfile_Previews: PreviewProvider {
    @State static var editProfile = false
    @State static var author = Author(
        id: "0",
        displayName: "taylor !!",
        bio: "please send help",
        profilePhotoURL: URL(string:"https://firebasestorage.googleapis.com:443/v0/b/fir-mobile-5302f.appspot.com/o/article%2F9O7H4xU8TvLN726AFGdm?alt=media&token=645d9c09-e632-409f-95dc-7e7477592533")!,
        bannerPhotoURL: URL(string:"https://firebasestorage.googleapis.com:443/v0/b/fir-mobile-5302f.appspot.com/o/article%2F9O7H4xU8TvLN726AFGdm?alt=media&token=645d9c09-e632-409f-95dc-7e7477592533")!
    )
    
    static var previews: some View {
        UpdateProfile(editProfile: $editProfile, author: $author)
            .environmentObject(BlogAuth())
            .environmentObject(BlogArticle())
            .environmentObject(BlogStorage())
    }
}

