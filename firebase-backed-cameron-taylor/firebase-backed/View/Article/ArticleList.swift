/**
 * ArticleList displays a list of articles, toggling between the list and a chosen article.
 */
import SwiftUI
import Combine



private class DebouncedState: ObservableObject {
    @Published var currentValue: String
    @Published var debouncedValue: String
    
    private var subscriber: AnyCancellable?
    
    init(initialValue: String, delay: Double = 0.3) {
        _currentValue = Published(initialValue: initialValue)
        _debouncedValue = Published(initialValue: initialValue)
        subscriber = $currentValue
            .debounce(for: .seconds(delay), scheduler: RunLoop.main)
            .sink { value in
                self.debouncedValue = value
            }
    }
}

struct ArticleList: View {
    @EnvironmentObject var auth: BlogAuth
    @EnvironmentObject var articleService: BlogArticle
    @EnvironmentObject var storage: BlogStorage
    
    @Binding var requestLogin: Bool
    @Binding var showMenu: Bool
    
    @Binding var currentUser: Author
    @State var articles: [Article]
    @State var authors: [Author]
    @State var error: Error?
    @State var fetching = false
    @State var writing = false
    @State var editing = false
    @State var editProfile = false
    @StateObject private var searchText = DebouncedState(initialValue: "", delay: 0.5)
    
    @State private var selection = "Default"
    
    let options = ["Default", "Score ↓", "Score ↑", "Date"]
    
    @State var pageNumber: Int = 1
    
    
    @State var animated = false
    
    
    var body: some View {
        NavigationView {
            VStack {
                if fetching {
                    ProgressView()
                        .frame(maxWidth:.infinity, maxHeight:.infinity)
                        .background(Color(red: 0.856, green: 0.826, blue: 0.805))
                } else if error != nil {
                    Text("Something went wrong…we wish we can say more 🤷🏽")
                        .frame(maxWidth:.infinity, maxHeight:.infinity)
                        .background(Color(red: 0.856, green: 0.826, blue: 0.805))
                } else if articles.count == 0 {
                    VStack {
                        Spacer()
                        Text("There are no articles.")
                        BadgeBackground()
                            .animation(.spring(duration: 10), value: animated)
                    }
                    .frame(maxWidth:.infinity)
                    .background(Color(red: 0.856, green: 0.826, blue: 0.805))
                } else {
                    VStack (spacing: 0){
                        List(articles.indices, id: \.self) { index in
                            NavigationLink {
                                ArticleDetail(
                                    editing: $editing,
                                    articles: $articles,
                                    authors: $authors,
                                    article: articles[index],
                                    author: currentUser
                                    
                                )
                            } label: {
                                ArticleMetadata(
                                    article: articles[index],
                                    authorName: authors[index].displayName
                                )
                            }
                            .listRowBackground(
                                Color(red: 0.924, green: 0.639, blue: 0.749)
                                    .padding(.vertical, 5)
                            )
                            .listRowSeparator(.hidden)
                            .foregroundColor(Color(red: 0.44, green: -0.051, blue: 0.328))
                        }
                        .scrollContentBackground(.hidden)
                        .background(Color(red: 0.856, green: 0.826, blue: 0.805))
                        
                        HStack {
                            Text("Sort by: ")
                            Picker("Sort", selection: $selection) {
                                ForEach(options, id: \.self) {
                                    Text($0)
                                }
                            }
                            .onChange(of: selection) {
                                Task {
                                    pageNumber = 1
                                    await fetchData()
                                }
                            }
                            .pickerStyle(.menu)
                            
                        }
                        .foregroundStyle(Color(red: 0.91, green: 0.324, blue: 0.57))
                        .font(Font.custom("SpecialElite-Regular", size: 15))
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .background(Color(red: -0.046, green: 0.137, blue: 0.227))
                        
                        HStack (spacing: 20){
                            Button(action: {
                                Task {
                                    pageNumber -= 1
                                    await fetchData()
                                }}) {
                                    Text("< Previous")
                                }
                                .padding(.horizontal, 20)
                                .disabled(pageNumber == 1)
                            Button(action: {
                                Task {
                                    pageNumber += 1
                                    await fetchData()
                                }}) {
                                    Text("Next >")
                                }
                                .padding(.horizontal, 20)
                                .disabled(articles.count < 20)
                            
                        }
                        .font(Font.custom("SpecialElite-Regular", size: 15))
                        .frame(maxWidth: .infinity)
                        .background(Color(red: -0.046, green: 0.137, blue: 0.227))
                    }
                }
            }
            .searchable(text: $searchText.currentValue)
            
            .navigationTitle("Pink Posts")
            
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    if auth.user != nil {
                        Button("New", systemImage: "plus.circle") {
                            writing = true
                        }
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if auth.user != nil {
                        Button(action: {
                            showMenu = true
                        }) {
                            ProfileImage(
                                imageURL: currentUser.profilePhotoURL, backgroundColor: .clear, width: 30, height: 30)
                        }                 
                    } else {
                        Button(action: {
                            requestLogin = true
                        }) {
                            ProfileImage(
                                imageURL: URL(string: "https://tr.rbxcdn.com/38c6edcb50633730ff4cf39ac8859840/420/420/Hat/Png")!, backgroundColor: .clear, width: 30, height: 30)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showMenu) {
            ProfileMenu(currentUser: $currentUser, editProfile: $editProfile, showMenu: $showMenu)
            
                .onAppear{
                    Task {
                        await fetchUser()
                    }
                }
        }
        .sheet(isPresented: $editProfile) {
            UpdateProfile(editProfile: $editProfile, author: $currentUser)
        }
        .sheet(isPresented: $writing) {
            ArticleEntry(articles: $articles, authors: $authors, writing: $writing, currentUser: currentUser)
        }
        .task(id: searchText.debouncedValue) {
            
            await fetchData()
        }
        .tint(Color(red: 0.91, green: 0.324, blue: 0.57))
    }
    
    private func fetchData() async {
        do {
            fetching = true
            
            articles = try await searchText.debouncedValue == "" ? articleService.fetchArticles(selection: selection, pageNumber: pageNumber, articles: articles) : articleService.searchArticles(query: searchText.debouncedValue)
            
            authors.removeAll()
            
            for article in articles {
                let author = await articleService.fetchUser(uid: article.uid)
                authors.append(author)
            }
            fetching = false
        } catch {
            self.error = error
            fetching = false
        }
    }
    
    private func fetchUser() async {
        currentUser = await articleService.fetchUser(uid: auth.user!.uid)
    }
}

struct ArticleList_Previews: PreviewProvider {
    @State static var requestLogin = false
    @State static var showMenu = false
    @State static var currentUser = Author(
        id: "0",
        displayName: "taylor !!",
        bio: "send help :(",
        profilePhotoURL: URL(string: "https://tr.rbxcdn.com/38c6edcb50633730ff4cf39ac8859840/420/420/Hat/Png")!,
        bannerPhotoURL: URL(string: "https://tr.rbxcdn.com/38c6edcb50633730ff4cf39ac8859840/420/420/Hat/Png")!)
    
    static var previews: some View {
        ArticleList(requestLogin: $requestLogin, showMenu: $showMenu, currentUser: $currentUser, articles: [], authors: [])
            .environmentObject(BlogAuth())
        
        ArticleList(requestLogin: $requestLogin, showMenu: $showMenu, currentUser: $currentUser, articles: [
            Article(
                id: "12345",
                title: "Preview",
                date: Date(),
                body: "Lorem ipsum dolor sit something something amet",
                score: 0,
                uid: "0",
                favorites: [],
                photoURL: "https://tr.rbxcdn.com/38c6edcb50633730ff4cf39ac8859840/420/420/Hat/Png"
            ),
            
            Article(
                id: "67890",
                title: "Some time ago",
                date: Date(timeIntervalSinceNow: TimeInterval(-604800)),
                body: "Duis diam ipsum, efficitur sit amet something somesit amet",
                score: 0,
                uid: "0",
                favorites: [],
                photoURL: "https://tr.rbxcdn.com/38c6edcb50633730ff4cf39ac8859840/420/420/Hat/Png"
            )
        ], authors: [])
        .environmentObject(BlogAuth())
        .environmentObject(BlogArticle())
        .environmentObject(BlogStorage())
    }
}
