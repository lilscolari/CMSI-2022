//
//  Profile.swift
//  firebase-backed
//
//  Created by Taylor Musso on 3/20/24.
//

import SwiftUI

struct Profile: View {
    @Binding var currentUser: Author
    
    var body: some View {
        VStack (alignment: .leading) {
            ZStack (alignment: .leading) {
                BannerImage(imageURL: currentUser.bannerPhotoURL, height: 150)
                    .padding(.top, -100)
                
                ProfileImage(imageURL: currentUser.profilePhotoURL, backgroundColor: Color(red: 0.924, green: 0.639, blue: 0.749), width: 100, height: 100)
                    .padding(.top, 50)
                    .padding(.leading, 10)
            }
            
            VStack (alignment: .leading) {
                Text(currentUser.displayName)
                    .font(Font.custom("Rockin'-Record", size: 20))
                    .padding(.bottom, 20)
                Text(currentUser.bio)
                    .font(Font.custom("SpecialElite-Regular", size: 15))
                    .padding(.bottom, 50)
            }
            .padding(10)       
        }
        .background(Color(red: 0.924, green: 0.639, blue: 0.749))
        .foregroundColor(Color(red: 0.44, green: -0.051, blue: 0.328))

    }
}

struct Profile_Previews: PreviewProvider {
    @State static var currentUser = Author(
        id: "0",
        displayName: "taylor !!",
        bio: "please send help",
        profilePhotoURL: URL(string:"https://firebasestorage.googleapis.com:443/v0/b/fir-mobile-5302f.appspot.com/o/article%2F9O7H4xU8TvLN726AFGdm?alt=media&token=645d9c09-e632-409f-95dc-7e7477592533")!,
        bannerPhotoURL: URL(string:"https://firebasestorage.googleapis.com:443/v0/b/fir-mobile-5302f.appspot.com/o/article%2F9O7H4xU8TvLN726AFGdm?alt=media&token=645d9c09-e632-409f-95dc-7e7477592533")!
    )
    static var previews: some View {
        Profile(currentUser: $currentUser)
    }
}
