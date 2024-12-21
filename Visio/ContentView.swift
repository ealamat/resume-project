//
//  ContentView.swift
//  Visio
//
//  Created by Elias Alamat on 12/7/24.
//
import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import PhotosUI

class AppDelegate: NSObject, UIApplicationDelegate {
    var authStateListenerHandle: AuthStateDidChangeListenerHandle? // Store the listener handle

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        setupFirestoreStructure()

        // Store the listener handle to prevent it from being deallocated
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                print("Authenticated user UID: \(user.uid)")
                CurrentUser.shared.uid = user.uid
                self.fetchUsername(for: user.uid)
                CurrentUser.shared.setupListeners()
            } else {
                print("No user is currently authenticated.")
                CurrentUser.shared.reset()
            }
        }

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Remove the listener when the app terminates
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    func setupFirestoreStructure() {
        // Define any Firestore setup if needed
    }

    func fetchUsername(for uid: String) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }

            guard let data = snapshot?.data(), let username = data["username"] as? String else {
                print("User data not found.")
                return
            }

            DispatchQueue.main.async {
                CurrentUser.shared.username = username
            }
        }
    }
}


@main
struct YourApp: App {
    @StateObject var currentUser = CurrentUser.shared // Initialize CurrentUser

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
            WindowGroup {
                First_Screen()
                    .environmentObject(currentUser) // Pass CurrentUser to all child views
            }
    }
}

// MARK: - Extension for Custom Colors
extension Color {
    static let visioGold = Color(red: 212/255, green: 175/255, blue: 55/255)
    static let backgroundGray = Color(red: 0.2, green: 0.2, blue: 0.2)
}







struct First_Screen: View {
    @EnvironmentObject var currentUser: CurrentUser // Access CurrentUser
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @State private var isLoggedIn: Bool = false // Controls navigation to the next screen
    @State private var showRegistration: Bool = false // controls navigation to the register screen
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.2, green: 0.2, blue: 0.2)
                    .ignoresSafeArea()
                VStack{
                    HStack{
                        Spacer()
                        VStack{
                            HStack{
                                Image(systemName: "star.fill")
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                                Image(systemName: "star.fill")
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                                Image(systemName: "star.fill")
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                            }
                            HStack{
                                Image(systemName: "star.fill")
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                                Image(systemName: "star.fill")
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                            }
                            
                            
                        }
                        
                        Rectangle()
                            .frame(width: 4, height: 75)
                            .padding(.leading, 20)
                            .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                        
                        VStack{
                            Text("V I S I O")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                            Text("Pure Potential")
                                .font(.subheadline)
                                .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                            
                        }
                        .padding(.leading, 20)
                        Spacer()
                    }
                    .padding(.top, -350)// end of H-stack
                }
                
                
                
                
                VStack {
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color(red: 212/255, green: 175/255, blue: 55/255))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(red: 212/255, green: 175/255, blue: 55/255))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .padding()
                    }
                    
                    Button("Login") {
                        loginUser()
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: 120)
                    .padding()
                    .background(Color(red: 212/255, green: 175/255, blue: 55/255))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .navigationDestination(isPresented: $isLoggedIn) {
                        LoggedInView()
                            .environmentObject(currentUser) // Pass currentUser to LoggedInView
                    }
                    Text("Or, if you don't have an account: ")
                        .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                        .padding(.top, 30)
                        .font(.footnote)
                        .fontWeight(.light)
                    
                    Button("Create Account") {
                        showRegistration = true
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: 120)
                    .padding()
                    .background(Color(red: 212/255, green: 175/255, blue: 55/255))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .navigationDestination(isPresented: $showRegistration){
                        CreateAccountView()
                    }
            
                }
            }
        }
        .tint(Color(red: 212/255, green: 175/255, blue: 55/255))
    }
    
    func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                return
            }

            guard let user = result?.user else { return }
            let db = Firestore.firestore()
            db.collection("users").document(user.uid).getDocument { snapshot, error in
                if let error = error {
                    print("Error fetching user data: \(error.localizedDescription)")
                    return
                }

                guard let data = snapshot?.data(), let username = data["username"] as? String else {
                    print("User data not found.")
                    return
                }

                DispatchQueue.main.async {
                    currentUser.uid = user.uid
                    currentUser.username = username
                    isLoggedIn = true // Update this only when data is ready
                }
            }
        }
    }

    
}

struct LoggedInView: View {
    @EnvironmentObject var currentUser: CurrentUser
    @State private var selectedTab = 0
    @State private var selectedUser: User? = nil
    @State private var navigateToChat: Bool = false

    var body: some View {
        TabView(selection: $selectedTab) {
            // Chats Tab
            NavigationStack {
                VStack(spacing: 20) {
                    Text("Welcome, \(currentUser.username)")
                        .font(.largeTitle)
                        .padding()

                    NavigationLink("Select User to Chat With", destination: UserListView(selectedUser: $selectedUser))
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)

                    Button("Logout") {
                        logout()
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)

                    // Hidden NavigationLink for programmatic navigation
                    if let user = selectedUser {
                        NavigationLink(
                            destination: ChatView(receiver: user).environmentObject(currentUser),
                            isActive: $navigateToChat
                        ) {
                            EmptyView()
                        }
                        .hidden()
                    }
                }
                .navigationTitle("Chats")
            }
            .tabItem {
                Label("Chats", systemImage: "message")
            }
            .tag(0)

            // Profile Tab
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
                .tag(1)

            // Create Post Tab
            NavigationStack {
                ImageManagementView()
            }
            .tabItem {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 30)) // Larger icon for emphasis
                Text("Create")
            }
            .tag(2)

            // Search Users Tab
            SearchUsersView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(3)
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: selectedUser) { newValue in
            if newValue != nil {
                navigateToChat = true
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            currentUser.reset()
        } catch {
            print("Error logging out: \(error.localizedDescription)")
        }
    }
}


struct LoggedInView_Previews: PreviewProvider {
    static var previews: some View {
        LoggedInView()
            .environmentObject(CurrentUser.shared)
    }
}


// FollowButton.swift

import SwiftUI
import FirebaseFirestore

struct FollowButton: View {
    @EnvironmentObject var currentUser: CurrentUser
    let userToFollow: User
    @State private var isFollowing: Bool = false
    @State private var isLoading: Bool = false
    @State private var showingAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        Button(action: {
            isFollowing ? unfollowUser() : followUser()
        }) {
            Text(isFollowing ? "Unfollow" : "Follow")
                .foregroundColor(isFollowing ? .red : .white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(isFollowing ? Color.gray : Color.visioGold)
                .cornerRadius(8)
        }
        .onAppear {
            checkIfFollowing()
        }
        .disabled(isLoading)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Notification"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func checkIfFollowing() {
        guard !currentUser.uid.isEmpty else { return }
        let db = Firestore.firestore()
        db.collection("users").document(currentUser.uid).collection("following").document(userToFollow.uid).getDocument { snapshot, error in
            if let error = error {
                print("Error checking follow status: \(error.localizedDescription)")
                return
            }
            self.isFollowing = snapshot?.exists ?? false
        }
    }
    
    func followUser() {
        isLoading = true
        let db = Firestore.firestore()
        
        // Add to current user's following subcollection
        let followingRef = db.collection("users").document(currentUser.uid).collection("following").document(userToFollow.uid)
        
        // Add to target user's followers subcollection
        let followersRef = db.collection("users").document(userToFollow.uid).collection("followers").document(currentUser.uid)
        
        // Use a batch write for atomicity
        let batch = db.batch()
        batch.setData(["timestamp": Timestamp()], forDocument: followingRef)
        batch.setData(["timestamp": Timestamp()], forDocument: followersRef)
        
        // Update counts
        let currentUserRef = db.collection("users").document(currentUser.uid)
        let targetUserRef = db.collection("users").document(userToFollow.uid)
        batch.updateData(["followingCount": FieldValue.increment(Int64(1))], forDocument: currentUserRef)
        batch.updateData(["followersCount": FieldValue.increment(Int64(1))], forDocument: targetUserRef)
        
        batch.commit { error in
            isLoading = false
            if let error = error {
                print("Error following user: \(error.localizedDescription)")
                alertMessage = "Error following user: \(error.localizedDescription)"
                showingAlert = true
            } else {
                isFollowing = true
                currentUser.following.insert(userToFollow.uid)
                currentUser.followers.insert(userToFollow.uid) // Not strictly necessary here
            }
        }
    }
    
    func unfollowUser() {
        isLoading = true
        let db = Firestore.firestore()
        
        // Remove from current user's following subcollection
        let followingRef = db.collection("users").document(currentUser.uid).collection("following").document(userToFollow.uid)
        
        // Remove from target user's followers subcollection
        let followersRef = db.collection("users").document(userToFollow.uid).collection("followers").document(currentUser.uid)
        
        // Use a batch write for atomicity
        let batch = db.batch()
        batch.deleteDocument(followingRef)
        batch.deleteDocument(followersRef)
        
        // Update counts
        let currentUserRef = db.collection("users").document(currentUser.uid)
        let targetUserRef = db.collection("users").document(userToFollow.uid)
        batch.updateData(["followingCount": FieldValue.increment(Int64(-1))], forDocument: currentUserRef)
        batch.updateData(["followersCount": FieldValue.increment(Int64(-1))], forDocument: targetUserRef)
        
        batch.commit { error in
            isLoading = false
            if let error = error {
                print("Error unfollowing user: \(error.localizedDescription)")
                alertMessage = "Error unfollowing user: \(error.localizedDescription)"
                showingAlert = true
            } else {
                isFollowing = false
                currentUser.following.remove(userToFollow.uid)
                currentUser.followers.remove(userToFollow.uid) // Not strictly necessary here
            }
        }
    }
}

//struct UserProfileView: View
struct UserProfileView: View {
    let user: User
    @State private var posts: [Post] = []
    @State private var isLoading = true
    
    init(user: User) {
            self.user = user
            print("UserProfileView initialized for userID: \(user.uid)") // Debug
        }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Picture
                if let profilePictureURL = user.profilePictureURL, !profilePictureURL.isEmpty {
                    AsyncImage(url: URL(string: profilePictureURL)) { image in
                        image.resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.gray)
                }

                // User Info
                VStack(alignment: .leading, spacing: 10) {
                    Text("Username: \(user.username)")
                        .font(.title)
                        .fontWeight(.bold)
                    if let realName = user.realName {
                        Text("Real Name: \(realName)")
                    }
                }
                .padding()

                Divider()

                // User Posts Section
                Text("Posts")
                    .font(.headline)

                if isLoading {
                    ProgressView("Loading posts...")
                } else if posts.isEmpty {
                    Text("No posts yet.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(posts) { post in
                        VStack(alignment: .leading) {
                            if let imageURL = post.imageURL {
                                AsyncImage(url: URL(string: imageURL)) { image in
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(height: 200)
                                        .cornerRadius(8)
                                } placeholder: {
                                    ProgressView()
                                }
                            }

                            Text(post.content)
                                .font(.body)
                                .padding(.vertical, 5)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("\(user.username)'s Profile")
        .onAppear {
            fetchUserPosts()
        }
        .onChange(of: posts) { newPosts in
            print("Fetched posts: \(newPosts)") // Debug: Log fetched posts
        }
    }

    func fetchUserPosts() {
        print("Fetching posts for userID: \(user.uid)") // Log user ID
        isLoading = true
        let db = Firestore.firestore()
        db.collection("posts")
            .whereField("userID", isEqualTo: user.uid) // Filter by userID
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                self.isLoading = false
                if let error = error {
                    print("Error fetching posts: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No posts found for userID: \(user.uid)") // Debug: No posts
                    return
                }

                print("Fetched \(documents.count) posts for userID: \(user.uid)") // Debug: Post count

                DispatchQueue.main.async {
                    self.posts = documents.map { doc -> Post in
                        let data = doc.data()
                        print("Fetched post data: \(data)") // Debug: Post data
                        return Post(id: doc.documentID, data: data)
                    }
                }
            }
    }


}



struct SearchUsersView: View {
    @EnvironmentObject var currentUser: CurrentUser
    @State private var searchText: String = ""
    @State private var searchResults: [User] = []
    @State private var isLoading: Bool = false
    @State private var showingAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                // Search Bar
                TextField("Search by username", text: $searchText)
                    .padding(8)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .onChange(of: searchText) { newValue in
                        searchUsers() // Call search as the user types
                    }

                if isLoading {
                    ProgressView("Searching...")
                        .padding()
                }

                // Search Results
                if searchResults.isEmpty && !isLoading && !searchText.isEmpty {
                    Text("No users found.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(searchResults) { user in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(user.username)
                                    .font(.headline)
                            }
                            Spacer()
                            NavigationLink(destination: UserProfileView(user: user)) {
                                Text("View Profile")
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Search Users")
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    
    func searchUsers() {
        let trimmedQuery = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        print("Searching for username: \(trimmedQuery)")

        guard !trimmedQuery.isEmpty else {
            searchResults = []
            return
        }

        // Clear the results to prevent accumulation of duplicates
        searchResults = []
        isLoading = true
        let db = Firestore.firestore()

        db.collection("users")
            .whereField("username_lowercase", isGreaterThanOrEqualTo: trimmedQuery)
            .whereField("username_lowercase", isLessThanOrEqualTo: "\(trimmedQuery)\u{f8ff}")
            .getDocuments { snapshot, error in
                self.isLoading = false

                if let error = error {
                    print("Error searching users: \(error.localizedDescription)")
                    alertMessage = "Error searching users: \(error.localizedDescription)"
                    showingAlert = true
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No documents found.")
                    self.searchResults = []
                    return
                }

                var uniqueUsers = Set<String>() // Use a Set to track unique UIDs
                var filteredUsers: [User] = []

                for doc in documents {
                    let data = doc.data()
                    let uid = doc.documentID // Use Firestore document ID as UID

                    // Check if UID is already in the set
                    if uniqueUsers.insert(uid).inserted {
                        let user = User(uid: uid, data: data)
                        filteredUsers.append(user)
                    } else {
                        print("Duplicate user skipped: \(uid)")
                    }
                }

                DispatchQueue.main.async {
                    self.searchResults = filteredUsers.filter { $0.uid != currentUser.uid }
                    print("Search results: \(self.searchResults)")
                }
            }
    }




}







struct FollowButton_Previews: PreviewProvider {
    static var previews: some View {
        FollowButton(userToFollow: User(uid: "user123", username: "JohnDoe"))
            .environmentObject(CurrentUser.shared)
    }
}


// ProfileView.swift


//struct ProfileView: View {
//    @Environment(\.dismiss) var dismiss
//    @EnvironmentObject var currentUser: CurrentUser
//    
//    @State private var profile: UserProfile? = nil
//    @State private var isLoading = true
//    @State private var showImagePicker = false
//    @State private var selectedImage: UIImage? = nil
//    @State private var isSaving = false
//    @State private var showingAlert: Bool = false
//    @State private var alertMessage: String = ""
//    
//    var body: some View {
//        NavigationStack {
//            if isLoading {
//                ProgressView("Loading profile...")
//            } else if let profile = profile {
//                Form {
//                    // Profile Picture Section
//                    Section {
//                        HStack {
//                            Spacer()
//                            profileImageView
//                                .onTapGesture {
//                                    showImagePicker = true
//                                }
//                            Spacer()
//                        }
//                    }
//                    
//                    // Profile Details Section
//                    Section(header: Text("Personal Info")) {
//                        TextField("Real Name", text: Binding(
//                            get: { self.profile?.realName ?? "" },
//                            set: { self.profile?.realName = $0 }
//                        ))
//                        TextField("Username", text: .constant(profile.username))
//                            .disabled(true)
//                        TextField("Height (cm)", value: Binding(
//                            get: { self.profile?.height ?? 0 },
//                            set: { self.profile?.height = $0 }
//                        ), formatter: NumberFormatter())
//                        TextField("Age", value: Binding(
//                            get: { self.profile?.age ?? 0 },
//                            set: { self.profile?.age = $0 }
//                        ), formatter: NumberFormatter())
//                        TextField("Current School", text: Binding(
//                            get: { self.profile?.currentSchool ?? "" },
//                            set: { self.profile?.currentSchool = $0 }
//                        ))
//                        TextField("School Year", text: Binding(
//                            get: { self.profile?.schoolYear ?? "" },
//                            set: { self.profile?.schoolYear = $0 }
//                        ))
//                    }
//                    
//                    // Followers and Following Section
//                    Section(header: Text("Connections")) {
//                        HStack {
//                            VStack(alignment: .leading) {
//                                Text("Followers")
//                                    .font(.headline)
//                                Text("\(currentUser.followers.count)")
//                                    .font(.subheadline)
//                            }
//                            Spacer()
//                            VStack(alignment: .leading) {
//                                Text("Following")
//                                    .font(.headline)
//                                Text("\(currentUser.following.count)")
//                                    .font(.subheadline)
//                            }
//                        }
//                    }
//                    
//                    // Save Button
//                    Section {
//                        Button(action: {
//                            saveProfile()
//                        }) {
//                            if isSaving {
//                                ProgressView()
//                            } else {
//                                Text("Save Changes")
//                                    .foregroundColor(.black)
//                            }
//                        }
//                        .background(Color.visioGold.opacity(0.2))
//                        .cornerRadius(8)
//                        .disabled(isSaving)
//                        .alert(isPresented: $showingAlert) {
//                            Alert(title: Text("Notification"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//                        }
//                    }
//                }
//                .navigationTitle("Your Profile")
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Button(action: {
//                            dismiss()
//                        }) {
//                            HStack {
//                                Image(systemName: "chevron.left")
//                                Text("Back")
//                            }
//                            .foregroundColor(.visioGold)
//                        }
//                    }
//                }
//                .sheet(isPresented: $showImagePicker) {
//                    ImagePicker(selectedImage: $selectedImage)
//                }
//            } else {
//                Text("Profile data is not available.")
//            }
//        }
//        .onAppear {
//            fetchProfile()
//        }
//    }
//    
//    var profileImageView: some View {
//        Group {
//            if let selectedImage = selectedImage {
//                Image(uiImage: selectedImage)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 150, height: 150)
//                    .clipShape(Circle())
//            } else if let url = profile?.profilePictureURL, let imageURL = URL(string: url) {
//                AsyncImage(url: imageURL) { image in
//                    image.resizable()
//                } placeholder: {
//                    ProgressView()
//                }
//                .scaledToFit()
//                .frame(width: 150, height: 150)
//                .clipShape(Circle())
//            } else {
//                Image(systemName: "person.crop.circle.fill")
//                    .resizable()
//                    .frame(width: 150, height: 150)
//                    .foregroundColor(.gray)
//            }
//        }
//    }
//    
//    func fetchProfile() {
//        guard let userId = Auth.auth().currentUser?.uid else { return }
//        let db = Firestore.firestore()
//        db.collection("users").document(userId).getDocument { snapshot, error in
//            if let error = error {
//                print("Error fetching profile: \(error.localizedDescription)")
//                alertMessage = "Error fetching profile: \(error.localizedDescription)"
//                showingAlert = true
//            } else if let data = snapshot?.data() {
//                self.profile = UserProfile(data: data)
//            } else {
//                print("No profile data found.")
//                alertMessage = "No profile data found."
//                showingAlert = true
//            }
//            self.isLoading = false
//        }
//    }
//    
//    func saveProfile() {
//        guard let userId = Auth.auth().currentUser?.uid else { return }
//        guard var profile = profile else { return }
//        let db = Firestore.firestore()
//
//        // Fetch the current document to retrieve username_lowercase
//        db.collection("users").document(userId).getDocument { snapshot, error in
//            if let error = error {
//                print("Error fetching user document: \(error.localizedDescription)")
//                alertMessage = "Error fetching user document: \(error.localizedDescription)"
//                showingAlert = true
//                return
//            }
//
//            var updatedData = profile.toDictionary()
//
//            if let data = snapshot?.data(), let usernameLowercase = data["username_lowercase"] as? String {
//                updatedData["username_lowercase"] = usernameLowercase // Ensure this field persists
//            }
//
//            isSaving = true
//
//            // Handle profile picture updates
//            if let selectedImage = selectedImage {
//                let storageRef = Storage.storage().reference().child("profilePictures/\(userId).jpg")
//                if let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
//                    let metadata = StorageMetadata()
//                    metadata.contentType = "image/jpeg"
//
//                    storageRef.putData(imageData, metadata: metadata) { _, error in
//                        if let error = error {
//                            print("Error uploading profile picture: \(error.localizedDescription)")
//                            alertMessage = "Error uploading profile picture: \(error.localizedDescription)"
//                            showingAlert = true
//                            isSaving = false
//                            return
//                        }
//                        storageRef.downloadURL { url, error in
//                            if let error = error {
//                                print("Error fetching download URL: \(error.localizedDescription)")
//                                alertMessage = "Error fetching download URL: \(error.localizedDescription)"
//                                showingAlert = true
//                                isSaving = false
//                                return
//                            }
//                            if let url = url {
//                                updatedData["profilePictureURL"] = url.absoluteString
//                                saveToFirestore(db: db, userId: userId, updatedData: updatedData)
//                            }
//                        }
//                    }
//                } else {
//                    print("Failed to generate image data.")
//                    alertMessage = "Failed to generate image data."
//                    showingAlert = true
//                    isSaving = false
//                }
//            } else {
//                saveToFirestore(db: db, userId: userId, updatedData: updatedData)
//            }
//        }
//    }
//
//    func saveToFirestore(db: Firestore, userId: String, updatedData: [String: Any]) {
//        db.collection("users").document(userId).setData(updatedData) { error in
//            isSaving = false
//            if let error = error {
//                print("Error saving profile: \(error.localizedDescription)")
//                alertMessage = "Error saving profile: \(error.localizedDescription)"
//                showingAlert = true
//            } else {
//                print("Profile successfully updated!")
//                alertMessage = "Profile successfully updated!"
//                showingAlert = true
//            }
//        }
//    }
//
//    
//}
struct ProfileView: View {
    @EnvironmentObject var currentUser: CurrentUser
    @State private var posts: [Post] = []
    @State private var isLoading = true
    @State private var selectedImage: UIImage? = nil

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading posts...")
            } else if posts.isEmpty {
                Text("No posts yet.")
                    .foregroundColor(.gray)
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(posts) { post in
                            VStack(alignment: .leading) {
                                if let imageURL = post.imageURL, let url = URL(string: imageURL) {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 200)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                                Text(post.content)
                                    .font(.body)
                                    .padding(.vertical, 5)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                }
            }
        }
        .onAppear {
            fetchPosts(for: currentUser.uid) { fetchedPosts in
                self.posts = fetchedPosts
                self.isLoading = false
            }
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(CurrentUser.shared)
    }
}



// MARK: - UserProfile Model
struct UserProfile {
    var realName: String
    var username: String
    var height: Int
    var age: Int
    var currentSchool: String
    var schoolYear: String
    var profilePictureURL: String?

    init(data: [String: Any]) {
        self.realName = data["realName"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
        self.height = data["height"] as? Int ?? 0
        self.age = data["age"] as? Int ?? 0
        self.currentSchool = data["currentSchool"] as? String ?? ""
        self.schoolYear = data["schoolYear"] as? String ?? ""
        self.profilePictureURL = data["profilePictureURL"] as? String
    }

    func toDictionary() -> [String: Any] {
        return [
            "realName": realName,
            "username": username,
            "height": height,
            "age": age,
            "currentSchool": currentSchool,
            "schoolYear": schoolYear,
            "profilePictureURL": profilePictureURL ?? ""
        ]
    }
}

// MARK: - ImagePicker View for Profile Picture Selection
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }

            provider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    self.parent.selectedImage = image as? UIImage
                }
            }
        }
    }
}











struct UserListView: View {
    @EnvironmentObject var currentUser: CurrentUser
    @Binding var selectedUser: User?
    @State private var users: [User] = []

    var body: some View {
        List(users) { user in
            NavigationLink(destination: ChatView(receiver: user)) {
                Text(user.username)
            }
        }
        .onAppear {
            fetchUsers()
        }
        .navigationTitle("Select User")
    }

    func fetchUsers() {
        let db = Firestore.firestore()
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }
            DispatchQueue.main.async {
                self.users = documents.compactMap { doc -> User? in
                    let data = doc.data()
                    guard let username = data["username"] as? String else { return nil }
                    let uid = doc.documentID
                    return User(uid: uid, username: username)
                }.filter { $0.uid != currentUser.uid }
            }
        }
    }
}
struct ChatView: View {
    @EnvironmentObject var currentUser: CurrentUser
    let receiver: User
    @State private var messageText: String = ""
    @State private var messages: [Message] = []

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(messages, id: \.id) { message in
                        HStack {
                            if message.senderID == currentUser.uid {
                                Spacer()
                                Text(message.text)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                            } else {
                                Text(message.text)
                                    .padding()
                                    .background(Color.gray.opacity(0.5))
                                    .cornerRadius(10)
                                Spacer()
                            }
                        }
                    }
                }
                .padding()
            }

            HStack {
                TextField("Enter message", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Send") {
                    sendMessage()
                }
                .padding()
                .background(Color.green)
                .cornerRadius(8)
            }
            .padding()
        }
        .navigationTitle("Chat with \(receiver.username)")
        .onAppear {
            fetchMessages()
        }
    }

    func sendMessage() {
        // Check current user authentication
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            print("Error: No authenticated user.")
            return
        }

        // Use receiver.uid directly since it's not an optional
        let receiverUID = receiver.uid

        // Validate message text
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("Error: Cannot send an empty message.")
            return
        }

        // Generate a consistent conversation ID
        let conversationID = [currentUserUID, receiverUID].sorted().joined(separator: "_")

        // Prepare message data
        let messageData: [String: Any] = [
            "senderID": currentUserUID,
            "receiverID": receiverUID,
            "text": messageText,
            "timestamp": Timestamp(),
            "participants": [currentUserUID, receiverUID]
        ]

        print("Attempting to write message: \(messageData)")

        // Write the message to Firestore
        Firestore.firestore()
            .collection("messages")
            .document(conversationID)
            .collection("chat")
            .addDocument(data: messageData) { error in
                if let error = error {
                    print("Error sending message: \(error.localizedDescription)")
                } else {
                    print("Message sent successfully!")
                    DispatchQueue.main.async {
                        self.messageText = ""
                    }
                }
            }
    }


    
    
    
    func fetchMessages() {
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            print("Error: No authenticated user.")
            return
        }

        let conversationID = [currentUserUID, receiver.uid].sorted().joined(separator: "_")
        print("Fetching messages from /messages/\(conversationID)/chat/")

        Firestore.firestore()
            .collection("messages")
            .document(conversationID)
            .collection("chat")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching messages: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No messages found.")
                    return
                }

                let messages = documents.map { doc -> Message in
                    let data = doc.data()
                    print("Fetched message: \(data)")
                    return Message(
                        id: doc.documentID,
                        senderID: data["senderID"] as? String ?? "",
                        receiverID: data["receiverID"] as? String ?? "",
                        text: data["text"] as? String ?? "",
                        timestamp: data["timestamp"] as? Timestamp ?? Timestamp()
                    )
                }

                DispatchQueue.main.async {
                    self.messages = messages
                }
            }
    }
}


func addLowercaseUsernames() {
    let db = Firestore.firestore()
    db.collection("users").getDocuments { snapshot, error in
        if let error = error {
            print("Error fetching documents: \(error.localizedDescription)")
            return
        }

        guard let documents = snapshot?.documents else {
            print("No documents found.")
            return
        }

        for document in documents {
            let data = document.data()
            if let username = data["username"] as? String {
                let lowercaseUsername = username.lowercased()
                db.collection("users").document(document.documentID).updateData([
                    "username_lowercase": lowercaseUsername
                ]) { error in
                    if let error = error {
                        print("Error updating document \(document.documentID): \(error.localizedDescription)")
                    } else {
                        print("Successfully updated document \(document.documentID)")
                    }
                }
            }
        }
    }
}

//struct User: Identifiable, Equatable {
//    let uid: String
//    let username: String
//    var id: String { uid }
//
//    var profilePictureURL: String?
//    var realName: String?
//    var age: Int
//    var height: Int
//    var currentSchool: String?
//    var schoolYear: String?
//
//    init(uid: String, username: String, profilePictureURL: String? = nil, realName: String? = nil, age: Int = 0, height: Int = 0, currentSchool: String? = nil, schoolYear: String? = nil) {
//        self.uid = uid
//        self.username = username
//        self.profilePictureURL = profilePictureURL
//        self.realName = realName
//        self.age = age
//        self.height = height
//        self.currentSchool = currentSchool
//        self.schoolYear = schoolYear
//    }
//
//    init(data: [String: Any]) {
//        self.uid = data["uid"] as? String ?? ""
//        self.username = data["username"] as? String ?? ""
//        self.profilePictureURL = data["profilePictureURL"] as? String
//        self.realName = data["realName"] as? String
//        self.age = data["age"] as? Int ?? 0
//        self.height = data["height"] as? Int ?? 0
//        self.currentSchool = data["currentSchool"] as? String
//        self.schoolYear = data["schoolYear"] as? String
//    }
//
//    static func == (lhs: User, rhs: User) -> Bool {
//        return lhs.uid == rhs.uid
//    }
//}
struct User: Identifiable, Equatable {
    let uid: String
    let username: String
    var id: String { uid } // Use `uid` as the unique identifier

    var profilePictureURL: String?
    var realName: String?
    var age: Int
    var height: Int
    var currentSchool: String?
    var schoolYear: String?

    // Primary initializer
    init(uid: String, username: String, profilePictureURL: String? = nil, realName: String? = nil, age: Int = 0, height: Int = 0, currentSchool: String? = nil, schoolYear: String? = nil) {
        self.uid = uid
        self.username = username
        self.profilePictureURL = profilePictureURL
        self.realName = realName
        self.age = age
        self.height = height
        self.currentSchool = currentSchool
        self.schoolYear = schoolYear
    }

    // Initializer with Firestore data
    init(uid: String, data: [String: Any]) {
        self.uid = uid
        self.username = data["username"] as? String ?? ""
        self.profilePictureURL = data["profilePictureURL"] as? String
        self.realName = data["realName"] as? String
        self.age = data["age"] as? Int ?? 0
        self.height = data["height"] as? Int ?? 0
        self.currentSchool = data["currentSchool"] as? String
        self.schoolYear = data["schoolYear"] as? String
    }

    // Equality operator for `Equatable`
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid
    }
}


func uploadImage(
    _ image: UIImage,
    to folder: String,
    withCompletion completion: @escaping (URL?) -> Void
) {
    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
        print("Failed to compress image.")
        completion(nil)
        return
    }

    let storage = Storage.storage()
    let uniqueID = UUID().uuidString
    let storageRef = storage.reference().child("\(folder)/\(uniqueID).jpg")

    storageRef.putData(imageData, metadata: nil) { _, error in
        if let error = error {
            print("Error uploading image: \(error.localizedDescription)")
            completion(nil)
            return
        }

        storageRef.downloadURL { url, error in
            if let error = error {
                print("Error getting download URL: \(error.localizedDescription)")
                completion(nil)
                return
            }
            completion(url)
        }
    }
}


struct ImageManagementView: View {
    @EnvironmentObject var currentUser: CurrentUser
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker: Bool = false
    @State private var isForProfilePicture: Bool = true
    @State private var postContent: String = ""
    @State private var isUploading: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Toggle between Profile Picture and Post Creation
                Picker("Action", selection: $isForProfilePicture) {
                    Text("Profile Picture").tag(true)
                    Text("Create Post").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // Show content input for post creation
                if !isForProfilePicture {
                    TextField("What's on your mind?", text: $postContent, axis: .vertical)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }

                // Show selected image preview
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(8)
                }

                // Button to pick an image
                Button("Choose Image") {
                    showImagePicker.toggle()
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(selectedImage: $selectedImage)
                }

                // Upload button
                if isUploading {
                    ProgressView("Uploading...")
                } else {
                    Button("Upload") {
                        uploadSelectedImage()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            .padding()
            .navigationTitle(isForProfilePicture ? "Update Profile Picture" : "Create Post")
        }
    }
    func uploadMedia(image: UIImage, folder: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data."])))
            return
        }

        let storageRef = Storage.storage().reference().child("\(folder)/\(UUID().uuidString).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        storageRef.putData(imageData, metadata: metadata) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url.absoluteString))
                }
            }
        }
    }

    

    func uploadSelectedImage() {
        guard let image = selectedImage else {
            print("No image selected")
            return
        }

        isUploading = true
        uploadMedia(image: image, folder: "postImages") { result in
            switch result {
            case .success(let url):
                savePost(imageURL: url, content: postContent, userId: currentUser.uid) { saveResult in
                    isUploading = false
                    switch saveResult {
                    case .success:
                        print("Post saved successfully")
                        selectedImage = nil
                        postContent = ""
                    case .failure(let error):
                        print("Error saving post: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                isUploading = false
                print("Error uploading media: \(error.localizedDescription)")
            }
        }
    }

    func updateProfilePicture(withURL url: String) {
        let db = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(userId).updateData(["profilePictureURL": url]) { error in
            if let error = error {
                print("Error updating profile picture: \(error.localizedDescription)")
            } else {
                print("Profile picture updated successfully.")
            }
        }
    }

    func createPost(withImageURL imageURL: String) {
        let db = Firestore.firestore()
        let postID = UUID().uuidString
        let postData: [String: Any] = [
            "userID": currentUser.uid, // Ensure this is correct
            "content": postContent,
            "imageURL": imageURL,
            "timestamp": FieldValue.serverTimestamp()
        ]

        db.collection("posts").document(postID).setData(postData) { error in
            if let error = error {
                print("Error creating post: \(error.localizedDescription)")
            } else {
                print("Post created successfully.")
                self.postContent = ""
                self.selectedImage = nil
            }
        }
    }

}




func fetchPosts(for userId: String, completion: @escaping ([Post]) -> Void) {
    let db = Firestore.firestore()
    db.collection("posts")
        .whereField("userID", isEqualTo: userId)
        .order(by: "timestamp", descending: true)
        .getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching posts: \(error.localizedDescription)")
                completion([])
                return
            }

            guard let documents = snapshot?.documents else {
                completion([])
                return
            }

            let posts = documents.compactMap { doc -> Post? in
                let data = doc.data()
                return Post(id: doc.documentID, data: data)
            }

            completion(posts)
        }
}
func savePost(imageURL: String, content: String, userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
    let db = Firestore.firestore()
    let postData: [String: Any] = [
        "userID": userId,
        "imageURL": imageURL,
        "content": content,
        "timestamp": FieldValue.serverTimestamp()
    ]

    db.collection("posts").addDocument(data: postData) { error in
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(()))
        }
    }
}








struct Message: Identifiable {
    let id: String
    let senderID: String
    let receiverID: String
    let text: String
    let timestamp: Timestamp
}

//struct Post: Identifiable, Equatable {
//    let id: String
//    let userID: String
//    let content: String
//    let imageURL: String?
//    let timestamp: Date
//
//    init(id: String, data: [String: Any]) {
//        self.id = id
//        self.userID = data["userID"] as? String ?? ""
//        self.content = data["content"] as? String ?? ""
//        self.imageURL = data["imageURL"] as? String
//        self.timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
//    }
//}
struct Post: Identifiable, Equatable {
    let id: String
    let userID: String
    let content: String
    let imageURL: String?
    let timestamp: Date

    init(id: String, data: [String: Any]) {
        self.id = id
        self.userID = data["userID"] as? String ?? ""
        self.content = data["content"] as? String ?? ""
        self.imageURL = data["imageURL"] as? String
        self.timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
    }
}










struct CreateAccountView: View{
        @State private var email: String = ""
        @State private var password: String = ""
        @State private var username: String = ""
        @State private var errorMessage: String = ""
        @State private var isAccountCreated: Bool = false
    
    var body: some View{
        ZStack {
            Color(red: 0.2, green: 0.2, blue: 0.2)
                .ignoresSafeArea()
            
            VStack {
                HStack{
                    Spacer()
                    VStack{
                        HStack{
                            Image(systemName: "star.fill")
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                            Image(systemName: "star.fill")
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                            Image(systemName: "star.fill")
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                        }
                        HStack{
                            Image(systemName: "star.fill")
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                            Image(systemName: "star.fill")
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                        }
                        
                        
                    }
                    
                    Rectangle()
                        .frame(width: 4, height: 75)
                        .padding(.leading, 20)
                        .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                    
                    VStack{
                        Text("V I S I O")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                        Text("Pure Potential")
                            .font(.subheadline)
                            .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                        
                    }
                    .padding(.leading, 20)
                    Spacer()
                }
                .padding(.top, -200)

                
                Text("To Sign up, enter a valid email adress,your desired username, as well as your desired passowrd for your account with visio. Please note that your password will be encrypted and stored securely.")
                    .fontWeight(.ultraLight)
                    .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                    .font(.custom("SFProText-Light", size: 10))
                    .padding(.bottom, 20)
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(red: 212/255, green: 175/255, blue: 55/255))
                    .cornerRadius(8)
                    .padding(.horizontal)
                TextField("Username", text: $username)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(red: 212/255, green: 175/255, blue: 55/255))
                    .cornerRadius(8)
                    .padding(.horizontal)

                
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(red: 212/255, green: 175/255, blue: 55/255))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .padding()
                }
                
                Button("Sign Up!") {
                    registerUser()
                }
                .frame(maxWidth: 120)
                .foregroundStyle(.black)
                .padding()
                .background(Color(red: 212/255, green: 175/255, blue: 55/255))
                .cornerRadius(8)
                .padding(.horizontal)
                
                if isAccountCreated {
                    Text("Account successfully created! Please login.")
                        .foregroundStyle(.green)
                        .padding()
                }
            }// end of vstack
        } // end of ztack
        //.navigationBarBackButtonHidden(true)
    }

//    func registerUser()
    func registerUser() {
        guard !username.isEmpty else {
            errorMessage = "Username cannot be empty."
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else if let user = result?.user {
                let db = Firestore.firestore()
                db.collection("users").document(user.uid).setData([
                    "username": username,
                    "username_lowercase": username.lowercased(), // Add lowercase username
                    "email": email,
                    "realName": "", // Placeholder
                    "profilePictureURL": "", // Placeholder for profile picture
                    "height": 0, // Default height
                    "age": 0, // Default age
                    "currentSchool": "", // Placeholder
                    "schoolYear": "" // Placeholder
                ]) { err in
                    if let err = err {
                        errorMessage = "Failed to save user data: \(err.localizedDescription)"
                    } else {
                        errorMessage = ""
                        isAccountCreated = true
                        print("Account created for user: \(user.email ?? "Unknown") with username: \(username)")
                    }
                }
            }
        }
    }


    
}



#Preview {
    CreateAccountView()
}
