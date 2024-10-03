/**
 * The Blog view provides a top-level wrapper to check whether things are configured OK.
 */
import SwiftUI

struct Blog: View {
    @EnvironmentObject var auth: BlogAuth
    @EnvironmentObject var articleService: BlogArticle
    
    @State var currentUser = Author(
        id: "0",
        displayName: "default",
        bio: "default",
        profilePhotoURL: URL(string: "https://tr.rbxcdn.com/38c6edcb50633730ff4cf39ac8859840/420/420/Hat/Png")!,
        bannerPhotoURL: URL(string: "https://tr.rbxcdn.com/38c6edcb50633730ff4cf39ac8859840/420/420/Hat/Png")!)
    @State var requestLogin = false
    @State var showMenu = false
    
    var body: some View {
        if let authUI = auth.authUI {
            ArticleList(requestLogin: $requestLogin, showMenu: $showMenu, currentUser: $currentUser, articles: [], authors: [])
                .sheet(isPresented: $requestLogin) {
                    AuthenticationViewController(authUI: authUI)
                        .background(Color(red: 0.856, green: 0.826, blue: 0.805))
                }
                .onReceive(auth.$user) { user in
                    if let user = user {
                        
                        Task {
                            currentUser = await articleService.fetchUser(uid: user.uid)
                            if currentUser.id == "default" {
                                currentUser = articleService.addUserData(author: Author(
                                    id: auth.user!.uid,
                                    displayName: auth.user!.displayName ?? "default",
                                    bio: "default",
                                    profilePhotoURL: auth.user!.photoURL ?? URL(string: "https://tr.rbxcdn.com/38c6edcb50633730ff4cf39ac8859840/420/420/Hat/Png")!,
                                    bannerPhotoURL: URL(string: "https://tr.rbxcdn.com/38c6edcb50633730ff4cf39ac8859840/420/420/Hat/Png")!)
                                )
                            }
                        }
                    }
                }
        } else {
            VStack {
                Text("Sorry, looks like we aren’t set up right!")
                    .padding()
                
                Text("Please contact this app’s developer for assistance.")
                    .padding()
            }
        }
    }
}

#Preview {
    Blog()
        .environmentObject(BlogAuth())
        .environmentObject(BlogArticle())
}
