//
//  ProfileMenu.swift
//  firebase-backed
//
//  Created by Taylor Musso on 3/24/24.
//

import SwiftUI

struct ProfileMenu: View {
    @EnvironmentObject var auth: BlogAuth
    @Binding var currentUser: Author
    @Binding var editProfile: Bool
    @Binding var showMenu: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Profile(currentUser: $currentUser)
                    .padding(.top, 50)
                
                Spacer()
                
                Button("Update Profile", systemImage: "pencil") {
                    editProfile = true
                    showMenu = false
                }
                .foregroundStyle(Color(red: 0.924, green: 0.639, blue: 0.749))
                .padding()
                .font(Font.custom("Rockin'-Record", size: 20))
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .background(Color(red: -0.046, green: 0.137, blue: 0.227))
                .clipped()
                Button("Sign Out", systemImage: "rectangle.portrait.and.arrow.right") {
                    do {
                        try auth.signOut()
                        showMenu = false
                    } catch {
                    }
                }
                .foregroundStyle(Color(red: 0.924, green: 0.639, blue: 0.749))
                .padding()
                .font(Font.custom("Rockin'-Record", size: 20))
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .background(Color(red: -0.046, green: 0.137, blue: 0.227))
                .clipped()
            }
            .background(Color(red: 0.856, green: 0.826, blue: 0.805))
            .navigationTitle("Profile")
        }
    }
}
//
//#Preview {
//    ProfileMenu()
//}
