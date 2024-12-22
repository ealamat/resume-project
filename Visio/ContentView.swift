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


//struct NotificationDropdown: View {
//    @ObservedObject var notificationManager = NotificationManager.shared
//    @Binding var showDropdown: Bool // Binding to toggle dropdown visibility
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            if notificationManager.unreadNotifications > 0 {
//                Text("You have \(notificationManager.unreadNotifications) new notifications:")
//                    .font(.headline)
//                    .padding(.bottom, 5)
//
//                // Example notifications
//                if !notificationManager.unreadMessages.isEmpty {
//                    Button(action: {
//                        print("View new messages")
//                        showDropdown = false // Close dropdown
//                    }) {
//                        Text("📩 New Message")
//                    }
//                }
//
//                if !notificationManager.newFollowers.isEmpty {
//                    Button(action: {
//                        print("View new followers")
//                        showDropdown = false // Close dropdown
//                    }) {
//                        Text("👤 New Follower")
//                    }
//                }
//
//                if !notificationManager.newPosts.isEmpty {
//                    Button(action: {
//                        print("View new posts")
//                        showDropdown = false // Close dropdown
//                    }) {
//                        Text("📷 New Post")
//                    }
//                }
//            } else {
//                Text("No new notifications")
//                    .foregroundColor(.gray)
//            }
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(8)
//        .shadow(radius: 4)
//        .frame(maxWidth: 200) // Adjust size as needed
//        .onTapGesture {
//            // Prevent taps inside the dropdown from closing it
//        }
//    }
//}










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

//struct LoggedInView: View {
//    @EnvironmentObject var currentUser: CurrentUser
//    @State private var selectedTab = 0
//    @State private var selectedUser: User? = nil
//    @State private var navigateToChat: Bool = false
//
//    var body: some View {
//        TabView(selection: $selectedTab) {
//            // Chats Tab
//            NavigationStack {
//                VStack(spacing: 20) {
//                    Text("Welcome, \(currentUser.username)")
//                        .font(.largeTitle)
//                        .padding()
//
//                    NavigationLink("Select User to Chat With", destination: UserListView(selectedUser: $selectedUser))
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//
//                    Button("Logout") {
//                        logout()
//                    }
//                    .padding()
//                    .background(Color.red)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//
//                    // Hidden NavigationLink for programmatic navigation
//                    if let user = selectedUser {
//                        NavigationLink(
//                            destination: ChatView(receiver: user).environmentObject(currentUser),
//                            isActive: $navigateToChat
//                        ) {
//                            EmptyView()
//                        }
//                        .hidden()
//                    }
//                }
//                .navigationTitle("Chats")
//            }
//            .tabItem {
//                Label("Chats", systemImage: "message")
//            }
//            .tag(0)
//
//            // Profile Tab
//            ProfileView()
//                .tabItem {
//                    Label("Profile", systemImage: "person.crop.circle")
//                }
//                .tag(1)
//
//            // Create Post Tab
//            NavigationStack {
//                ImageManagementView()
//            }
//            .tabItem {
//                Image(systemName: "plus.circle.fill")
//                    .font(.system(size: 30)) // Larger icon for emphasis
//                Text("Create")
//            }
//            .tag(2)
//
//            // Search Users Tab
//            SearchUsersView()
//                .tabItem {
//                    Label("Search", systemImage: "magnifyingglass")
//                }
//                .tag(3)
//        }
//        .navigationBarBackButtonHidden(true)
//        .onChange(of: selectedUser) { newValue in
//            if newValue != nil {
//                navigateToChat = true
//            }
//        }
//    }
//
//    func logout() {
//        do {
//            try Auth.auth().signOut()
//            currentUser.reset()
//        } catch {
//            print("Error logging out: \(error.localizedDescription)")
//        }
//    }
//}
struct LoggedInView: View {
    @EnvironmentObject var currentUser: CurrentUser
    @State private var selectedTab = 0
    @State private var selectedUser: User? = nil
    @State private var navigateToChat: Bool = false

    var body: some View {
        NavigationView {
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
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NotificationBubble()
                        }
                    }
                }
                .tabItem {
                    Label("Chats", systemImage: "message")
                }
                .tag(0)

                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
                    .tag(1)

                ImageManagementView()
                    .tabItem {
                        Image(systemName: "plus.circle.fill")
                        Text("Create")
                    }
                    .tag(2)

                SearchUsersView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .tag(3)
            }
            .onAppear {
                NotificationManager.shared.startListening(for: currentUser.uid)
            }
            .onDisappear {
                NotificationManager.shared.stopListening()
            }
        }
        .navigationBarBackButtonHidden(true)
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

//struct UserProfileView: View {
//    let user: User
//    @State private var posts: [Post] = []
//    @State private var isLoading = true
//    @State private var followerCount: Int = 0
//    @State private var followingCount: Int = 0
//    
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 20) {
//                // Profile Picture
//                if let profilePictureURL = user.profilePictureURL, !profilePictureURL.isEmpty {
//                    AsyncImage(url: URL(string: profilePictureURL)) { image in
//                        image.resizable()
//                            .scaledToFit()
//                            .frame(width: 150, height: 150)
//                            .clipShape(Circle())
//                    } placeholder: {
//                        ProgressView()
//                    }
//                } else {
//                    Image(systemName: "person.crop.circle.fill")
//                        .resizable()
//                        .frame(width: 150, height: 150)
//                        .foregroundColor(.gray)
//                }
//
//                // User Info and Counts
//                VStack(alignment: .center, spacing: 10) {
//                    Text(user.username)
//                        .font(.title)
//                        .fontWeight(.bold)
//                    
//                    if let realName = user.realName {
//                        Text(realName)
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                    }
//                    
//                    HStack {
//                        VStack {
//                            Text("\(followerCount)")
//                                .font(.headline)
//                            Text("Followers")
//                                .font(.subheadline)
//                        }
//                        .padding(.horizontal)
//
//                        VStack {
//                            Text("\(followingCount)")
//                                .font(.headline)
//                            Text("Following")
//                                .font(.subheadline)
//                        }
//                        .padding(.horizontal)
//                    }
//                }
//
//                Divider()
//
//                // Display all User Attributes
//               VStack(alignment: .leading, spacing: 10) {
//                    if user.age > 0 { // Assuming 0 is a placeholder for no age
//                        Text("Age: \(user.age)")
//                    }
//                    if user.height > 0 { // Assuming 0 is a placeholder for no height
//                        Text("Height: \(user.height) cm")
//                    }
//                    if let currentSchool = user.currentSchool, !currentSchool.isEmpty {
//                        Text("School: \(currentSchool)")
//                    }
//                    if let schoolYear = user.schoolYear, !schoolYear.isEmpty {
//                        Text("Year: \(schoolYear)")
//                    }
//                }
//
//                .padding()
//
//                Divider()
//
//                // User Posts Section
//                Text("Posts")
//                    .font(.headline)
//
//                if isLoading {
//                    ProgressView("Loading posts...")
//                } else if posts.isEmpty {
//                    Text("No posts yet.")
//                        .foregroundColor(.gray)
//                } else {
//                    ForEach(posts) { post in
//                        VStack(alignment: .leading) {
//                            if let imageURL = post.imageURL {
//                                AsyncImage(url: URL(string: imageURL)) { image in
//                                    image.resizable()
//                                        .scaledToFit()
//                                        .frame(height: 200)
//                                        .cornerRadius(8)
//                                } placeholder: {
//                                    ProgressView()
//                                }
//                            }
//
//                            Text(post.content)
//                                .font(.body)
//                                .padding(.vertical, 5)
//                        }
//                        .padding()
//                        .background(Color.gray.opacity(0.1))
//                        .cornerRadius(8)
//                    }
//                }
//            }
//            .padding()
//        }
//        .navigationTitle("\(user.username)'s Profile")
//        .onAppear {
//            fetchUserData()
//            fetchUserPosts()
//        }
//    }
//
//    func fetchUserData() {
//        let db = Firestore.firestore()
//        
//        // Fetch follower and following counts
//        db.collection("users").document(user.uid).getDocument { snapshot, error in
//            if let error = error {
//                print("Error fetching user data: \(error.localizedDescription)")
//                return
//            }
//            
//            if let data = snapshot?.data() {
//                followerCount = data["followersCount"] as? Int ?? 0
//                followingCount = data["followingCount"] as? Int ?? 0
//            }
//        }
//    }
//
//    func fetchUserPosts() {
//        isLoading = true
//        let db = Firestore.firestore()
//        db.collection("posts")
//            .whereField("userID", isEqualTo: user.uid)
//            .order(by: "timestamp", descending: true)
//            .getDocuments { snapshot, error in
//                isLoading = false
//                if let error = error {
//                    print("Error fetching posts: \(error.localizedDescription)")
//                    return
//                }
//
//                guard let documents = snapshot?.documents else { return }
//
//                DispatchQueue.main.async {
//                    self.posts = documents.map { doc -> Post in
//                        let data = doc.data()
//                        return Post(id: doc.documentID, data: data)
//                    }
//                }
//            }
//    }
//}
struct UserProfileView: View {
    @EnvironmentObject var currentUser: CurrentUser
    let user: User
    @State private var posts: [Post] = []
    @State private var isLoading = true
    @State private var followerCount: Int = 0
    @State private var followingCount: Int = 0
    @State private var isFollowing: Bool = false // Track follow status

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

                // User Info and Counts
                VStack(alignment: .center, spacing: 10) {
                    Text(user.username)
                        .font(.title)
                        .fontWeight(.bold)

                    if let realName = user.realName {
                        Text(realName)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        VStack {
                            Text("\(followerCount)")
                                .font(.headline)
                            Text("Followers")
                                .font(.subheadline)
                        }
                        .padding(.horizontal)

                        VStack {
                            Text("\(followingCount)")
                                .font(.headline)
                            Text("Following")
                                .font(.subheadline)
                        }
                        .padding(.horizontal)
                    }
                }

                Divider()

                // Follow/Unfollow Button
                if user.uid != currentUser.uid { // Ensure user is not following themselves
                    Button(isFollowing ? "Unfollow" : "Follow") {
                        toggleFollowStatus()
                    }
                    .padding()
                    .background(isFollowing ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }

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
            fetchUserData()
            fetchUserPosts()
            checkFollowStatus() // Check initial follow status
        }
    }

    func fetchUserData() {
        let db = Firestore.firestore()

        // Fetch follower and following counts
        db.collection("users").document(user.uid).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }

            if let data = snapshot?.data() {
                self.followerCount = data["followersCount"] as? Int ?? 0
                self.followingCount = data["followingCount"] as? Int ?? 0
            }
        }
    }

    func fetchUserPosts() {
        isLoading = true
        let db = Firestore.firestore()
        db.collection("posts")
            .whereField("userID", isEqualTo: user.uid)
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                isLoading = false
                if let error = error {
                    print("Error fetching posts: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                DispatchQueue.main.async {
                    self.posts = documents.map { doc -> Post in
                        let data = doc.data()
                        return Post(id: doc.documentID, data: data)
                    }
                }
            }
    }

    func checkFollowStatus() {
        guard !currentUser.uid.isEmpty else { return }
        let db = Firestore.firestore()
        db.collection("users")
            .document(currentUser.uid)
            .collection("following")
            .document(user.uid)
            .getDocument { snapshot, error in
                if let error = error {
                    print("Error checking follow status: \(error.localizedDescription)")
                    return
                }

                self.isFollowing = snapshot?.exists ?? false
            }
    }

    func toggleFollowStatus() {
        isFollowing ? unfollowUser() : followUser()
    }

    func followUser() {
        let db = Firestore.firestore()
        let batch = db.batch()

        // Update current user's following collection
        let followingRef = db.collection("users").document(currentUser.uid).collection("following").document(user.uid)
        batch.setData(["timestamp": Timestamp()], forDocument: followingRef)

        // Update target user's followers collection
        let followersRef = db.collection("users").document(user.uid).collection("followers").document(currentUser.uid)
        batch.setData(["timestamp": Timestamp()], forDocument: followersRef)

        // Update follower and following counts
        let currentUserRef = db.collection("users").document(currentUser.uid)
        let targetUserRef = db.collection("users").document(user.uid)
        batch.updateData(["followingCount": FieldValue.increment(Int64(1))], forDocument: currentUserRef)
        batch.updateData(["followersCount": FieldValue.increment(Int64(1))], forDocument: targetUserRef)

        // Commit batch
        batch.commit { error in
            if let error = error {
                print("Error following user: \(error.localizedDescription)")
            } else {
                isFollowing = true
                followerCount += 1
            }
        }
    }

    func unfollowUser() {
        let db = Firestore.firestore()
        let batch = db.batch()

        // Remove from current user's following collection
        let followingRef = db.collection("users").document(currentUser.uid).collection("following").document(user.uid)
        batch.deleteDocument(followingRef)

        // Remove from target user's followers collection
        let followersRef = db.collection("users").document(user.uid).collection("followers").document(currentUser.uid)
        batch.deleteDocument(followersRef)

        // Update follower and following counts
        let currentUserRef = db.collection("users").document(currentUser.uid)
        let targetUserRef = db.collection("users").document(user.uid)
        batch.updateData(["followingCount": FieldValue.increment(Int64(-1))], forDocument: currentUserRef)
        batch.updateData(["followersCount": FieldValue.increment(Int64(-1))], forDocument: targetUserRef)

        // Commit batch
        batch.commit { error in
            if let error = error {
                print("Error unfollowing user: \(error.localizedDescription)")
            } else {
                isFollowing = false
                followerCount -= 1
            }
        }
    }
}






struct EditProfileView: View {
    @EnvironmentObject var currentUser: CurrentUser
    @State private var realName: String = ""
    @State private var age: Int = 0
    @State private var height: Int = 0
    @State private var currentSchool: String = ""
    @State private var schoolYear: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker: Bool = false
    @State private var isSaving: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Profile Picture")) {
                    HStack {
                        Spacer()
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                                .onTapGesture {
                                    showImagePicker = true
                                }
                        } else if !currentUser.profilePictureURL.isEmpty {
                            AsyncImage(url: URL(string: currentUser.profilePictureURL)) { image in
                                image.resizable()
                                    .scaledToFit()
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                            }
                            .onTapGesture {
                                showImagePicker = true
                            }
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 150, height: 150)
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    showImagePicker = true
                                }
                        }
                        Spacer()
                    }
                }

                Section(header: Text("Personal Info")) {
                    TextField("Real Name", text: $realName)
                    TextField("Age", value: $age, formatter: NumberFormatter())
                    TextField("Height (cm)", value: $height, formatter: NumberFormatter())
                }

                Section(header: Text("School Info")) {
                    TextField("Current School", text: $currentSchool)
                    TextField("School Year", text: $schoolYear)
                }

                Section {
                    Button("Save Changes") {
                        saveChanges()
                    }
                    .disabled(isSaving)
                }
            }
            .navigationTitle("Edit Profile")
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
            .onAppear {
                loadCurrentUserData()
            }
        }
    }

    func loadCurrentUserData() {
        realName = currentUser.realName
        age = currentUser.age
        height = currentUser.height
        currentSchool = currentUser.currentSchool
        schoolYear = currentUser.schoolYear
    }

    func saveChanges() {
        isSaving = true

        // Update Firestore with new data
        var updatedData: [String: Any] = [
            "realName": realName,
            "age": age,
            "height": height,
            "currentSchool": currentSchool,
            "schoolYear": schoolYear
        ]

        if let image = selectedImage {
            uploadProfilePicture(image: image) { result in
                switch result {
                case .success(let url):
                    updatedData["profilePictureURL"] = url
                    saveToFirestore(updatedData: updatedData)
                case .failure(let error):
                    print("Error uploading profile picture: \(error.localizedDescription)")
                    isSaving = false
                }
            }
        } else {
            saveToFirestore(updatedData: updatedData)
        }
    }

    func saveToFirestore(updatedData: [String: Any]) {
        let db = Firestore.firestore()
        db.collection("users").document(currentUser.uid).updateData(updatedData) { error in
            isSaving = false
            if let error = error {
                print("Error saving profile data: \(error.localizedDescription)")
            } else {
                currentUser.realName = realName
                currentUser.age = age
                currentUser.height = height
                currentUser.currentSchool = currentSchool
                currentUser.schoolYear = schoolYear
                print("Profile updated successfully.")
            }
        }
    }

    func uploadProfilePicture(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data."])))
            return
        }

        let storage = Storage.storage()
        let ref = storage.reference().child("profilePictures/\(currentUser.uid).jpg")
        ref.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                ref.downloadURL { url, error in
                    if let error = error {
                        completion(.failure(error))
                    } else if let url = url {
                        completion(.success(url.absoluteString))
                    }
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
//struct SearchUsersView: View 


//MARK: woahhhh
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








struct FollowButton_Previews: PreviewProvider {
    static var previews: some View {
        FollowButton(userToFollow: User(uid: "user123", username: "JohnDoe"))
            .environmentObject(CurrentUser.shared)
    }
}


// ProfileView.swift
struct ProfileView: View {
    @EnvironmentObject var currentUser: CurrentUser
    @State private var posts: [Post] = []
    @State private var isLoading = true
    @State private var followerCount: Int = 0
    @State private var followingCount: Int = 0
    @State private var navigateToEditProfile: Bool = false // State for navigation

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Picture
                if !currentUser.profilePictureURL.isEmpty {
                    AsyncImage(url: URL(string: currentUser.profilePictureURL)) { image in
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
                VStack(alignment: .center, spacing: 10) {
                    Text(currentUser.username)
                        .font(.title)
                        .fontWeight(.bold)

                    if !currentUser.realName.isEmpty {
                        Text(currentUser.realName)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    // Follower/Following Counts
                    HStack {
                        VStack {
                            Text("\(followerCount)")
                                .font(.headline)
                            Text("Followers")
                                .font(.subheadline)
                        }
                        .padding(.horizontal)

                        VStack {
                            Text("\(followingCount)")
                                .font(.headline)
                            Text("Following")
                                .font(.subheadline)
                        }
                        .padding(.horizontal)
                    }
                }

                Divider()

                // Display User Attributes
                VStack(alignment: .leading, spacing: 10) {
                    if currentUser.age > 0 {
                        Text("Age: \(currentUser.age)")
                    }
                    if currentUser.height > 0 {
                        Text("Height: \(currentUser.height) cm")
                    }
                    if !currentUser.currentSchool.isEmpty {
                        Text("School: \(currentUser.currentSchool)")
                    }
                    if !currentUser.schoolYear.isEmpty {
                        Text("Year: \(currentUser.schoolYear)")
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

                // "Edit Profile" Button
                Button("Edit Profile") {
                    navigateToEditProfile = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)

                // NavigationLink to EditProfileView
                NavigationLink(
                    destination: EditProfileView().environmentObject(currentUser),
                    isActive: $navigateToEditProfile
                ) {
                    EmptyView()
                }
                .hidden()
            }
            .padding()
        }
        .navigationTitle("Your Profile")
        .onAppear {
            fetchUserData()
            fetchPosts()
        }
    }

    func fetchUserData() {
        let db = Firestore.firestore()

        // Fetch follower and following counts
        db.collection("users").document(currentUser.uid).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }

            if let data = snapshot?.data() {
                self.followerCount = data["followersCount"] as? Int ?? 0
                self.followingCount = data["followingCount"] as? Int ?? 0
            }
        }
    }

    func fetchPosts() {
        isLoading = true
        let db = Firestore.firestore()
        db.collection("posts")
            .whereField("userID", isEqualTo: currentUser.uid)
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                isLoading = false
                if let error = error {
                    print("Error fetching posts: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                DispatchQueue.main.async {
                    self.posts = documents.map { doc -> Post in
                        let data = doc.data()
                        return Post(id: doc.documentID, data: data)
                    }
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
class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    @Published var unreadNotifications: Int = 0
    @Published var unreadMessages: [String] = [] // Store message summaries
    @Published var newFollowers: [String] = []   // Store follower names
    @Published var newPosts: [String] = []       // Store post summaries

    private var messageListener: ListenerRegistration?
    private var followerListener: ListenerRegistration?
    private var postListener: ListenerRegistration?

    func startListening(for userId: String) {
        let db = Firestore.firestore()

        // Listen for new messages
        messageListener = db.collection("messages")
            .whereField("participants", arrayContains: userId)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error listening to messages: \(error.localizedDescription)")
                    return
                }

                self.unreadMessages = snapshot?.documents.compactMap { doc in
                    let data = doc.data()
                    let lastReadTimestamp = data["lastRead_\(userId)"] as? Timestamp ?? Timestamp(seconds: 0, nanoseconds: 0)
                    let latestMessageTimestamp = (data["timestamp"] as? Timestamp) ?? Timestamp()
                    return latestMessageTimestamp.dateValue() > lastReadTimestamp.dateValue() ? data["content"] as? String : nil
                } ?? []

                DispatchQueue.main.async {
                    self.updateUnreadCount()
                }
            }

        // Listen for new followers
        followerListener = db.collection("users").document(userId).collection("followers")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error listening to followers: \(error.localizedDescription)")
                    return
                }

                self.newFollowers = snapshot?.documentChanges.compactMap { change in
                    if change.type == .added, let followerName = change.document.data()["name"] as? String {
                        return followerName
                    }
                    return nil
                } ?? []

                DispatchQueue.main.async {
                    self.updateUnreadCount()
                }
            }

        // Listen for new posts from followed users
        let followedUserIds = getFollowingList(for: userId)
        guard !followedUserIds.isEmpty else {
            print("No followed users. Skipping post listener.")
            return
        }

        postListener = db.collection("posts")
            .whereField("userID", in: followedUserIds)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error listening to posts: \(error.localizedDescription)")
                    return
                }

                self.newPosts = snapshot?.documentChanges.compactMap { change in
                    if change.type == .added, let postContent = change.document.data()["content"] as? String {
                        return postContent
                    }
                    return nil
                } ?? []

                DispatchQueue.main.async {
                    self.updateUnreadCount()
                }
            }
    }
    func stopListening() {
        messageListener?.remove()
        messageListener = nil

        followerListener?.remove()
        followerListener = nil

        postListener?.remove()
        postListener = nil
    }

    private func getFollowingList(for userId: String) -> [String] {
        // Simulated fetching of followed user IDs
        return [] // Replace with actual query result
    }

    private func updateUnreadCount() {
        self.unreadNotifications = unreadMessages.count + newFollowers.count + newPosts.count
    }
}


struct NotificationBubble: View {
    @ObservedObject var notificationManager = NotificationManager.shared
    @State private var showDropdown = false // Controls dropdown visibility

    var body: some View {
        ZStack {
            // Background to detect taps outside the dropdown
            if showDropdown {
                Color.black.opacity(0.3) // Semi-transparent background
                    .ignoresSafeArea()
                    .onTapGesture {
                        showDropdown = false // Close dropdown when tapping outside
                    }
            }

            ZStack(alignment: .topTrailing) {
                // Bell Icon
                Image(systemName: "bell.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        if notificationManager.unreadNotifications > 0 {
                            showDropdown.toggle()
                        }
                    }

                // Notification Count
                if notificationManager.unreadNotifications > 0 {
                    Text("\(notificationManager.unreadNotifications)")
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.red)
                        .clipShape(Circle())
                        .offset(x: 10, y: -10)
                }

                // Dropdown Menu
                if showDropdown {
                    NotificationDropdown(showDropdown: $showDropdown)
                        .offset(y: 40) // Position below the bubble
                        .transition(.opacity) // Smooth transition
                        .zIndex(1) // Ensure it appears above other views
                }
            }
        }
    }
}

struct NotificationDropdown: View {
    @ObservedObject var notificationManager = NotificationManager.shared
    @Binding var showDropdown: Bool // Binding to toggle dropdown visibility

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if notificationManager.unreadNotifications > 0 {
                Text("You have \(notificationManager.unreadNotifications) new notifications:")
                    .font(.headline)
                    .padding(.bottom, 5)

                // Display unread messages
                ForEach(notificationManager.unreadMessages, id: \.self) { message in
                    Button(action: {
                        print("View new message: \(message)")
                        showDropdown = false // Close dropdown
                    }) {
                        Text("📩 \(message)")
                    }
                }

                // Display new followers
                ForEach(notificationManager.newFollowers, id: \.self) { follower in
                    Button(action: {
                        print("\(follower) followed you")
                        showDropdown = false // Close dropdown
                    }) {
                        Text("👤 \(follower)")
                    }
                }

                // Display new posts
                ForEach(notificationManager.newPosts, id: \.self) { post in
                    Button(action: {
                        print("View new post: \(post)")
                        showDropdown = false // Close dropdown
                    }) {
                        Text("📷 \(post)")
                    }
                }
            } else {
                Text("No new notifications")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
        .frame(maxWidth: 200) // Adjust size as needed
    }
}






//struct NotificationBubble: View {
//    @ObservedObject var notificationManager = NotificationManager.shared
//
//    var body: some View {
//        ZStack {
//            Image(systemName: "bell.fill")
//                .resizable()
//                .frame(width: 25, height: 25)
//                .foregroundColor(.blue)
//
//            if notificationManager.unreadNotifications > 0 {
//                Text("\(notificationManager.unreadNotifications)")
//                    .font(.caption2)
//                    .foregroundColor(.white)
//                    .padding(6)
//                    .background(Color.red)
//                    .clipShape(Circle())
//                    .offset(x: 10, y: -10)
//            }
//        }
//        .onTapGesture {
//            // Navigate to a notifications screen or clear notifications
//            notificationManager.clearNotifications()
//        }
//    }
//}

//struct NotificationBubble: View {
//    @ObservedObject var notificationManager = NotificationManager.shared
//    @State private var showDropdown = false // Controls dropdown visibility
//
//    var body: some View {
//        ZStack(alignment: .topTrailing) {
//            // Bell Icon
//            Image(systemName: "bell.fill")
//                .resizable()
//                .frame(width: 25, height: 25)
//                .foregroundColor(.blue)
//                .onTapGesture {
//                    if notificationManager.unreadNotifications > 0 {
//                        showDropdown.toggle()
//                    }
//                }
//
//            // Notification Count
//            if notificationManager.unreadNotifications > 0 {
//                Text("\(notificationManager.unreadNotifications)")
//                    .font(.caption2)
//                    .foregroundColor(.white)
//                    .padding(6)
//                    .background(Color.red)
//                    .clipShape(Circle())
//                    .offset(x: 10, y: -10)
//            }
//
//            // Dropdown Menu
//            if showDropdown {
//                NotificationDropdown(showDropdown: $showDropdown)
//                    .offset(y: 40) // Position below the bubble
//                    .transition(.opacity) // Smooth transition
//                    .zIndex(1) // Ensure it appears above other views
//            }
//        }
//    }
//}










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

struct User: Identifiable, Equatable {
    var uid: String
    var username: String
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
                // Picker to toggle between Profile Picture and Post Creation
                Picker("Action", selection: $isForProfilePicture) {
                    Text("Profile Picture").tag(true)
                    Text("Create Post").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // Content input for post creation
                if !isForProfilePicture {
                    TextField("What's on your mind?", text: $postContent, axis: .vertical)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }

                // Preview of selected image
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(8)
                }

                // Button to open image picker
                Button("Choose Image") {
                    showImagePicker.toggle()
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(selectedImage: $selectedImage)
                }

                // Upload Button
                if isUploading {
                    ProgressView("Uploading...")
                } else {
                    Button("Upload") {
                        handleUpload()
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

    // Handle upload action
    func handleUpload() {
        guard let image = selectedImage else {
            print("No image selected")
            return
        }

        isUploading = true

        if isForProfilePicture {
            uploadProfilePicture(image: image)
        } else {
            uploadPostImage(image: image, content: postContent)
        }
    }

    // Upload Profile Picture
    func uploadProfilePicture(image: UIImage) {
        uploadMedia(image: image, folder: "profilePictures") { result in
            isUploading = false
            switch result {
            case .success(let url):
                updateProfilePicture(withURL: url)
                print("Profile picture uploaded successfully.")
                selectedImage = nil
            case .failure(let error):
                print("Error uploading profile picture: \(error.localizedDescription)")
            }
        }
    }

    // Upload Post Image
    func uploadPostImage(image: UIImage, content: String) {
        uploadMedia(image: image, folder: "postImages") { result in
            isUploading = false
            switch result {
            case .success(let url):
                savePost(imageURL: url, content: content)
                print("Post created successfully.")
                selectedImage = nil
                postContent = ""
            case .failure(let error):
                print("Error uploading post: \(error.localizedDescription)")
            }
        }
    }

    // Update Profile Picture URL in Firestore
    func updateProfilePicture(withURL url: String) {
        let db = Firestore.firestore()
        db.collection("users").document(currentUser.uid).updateData(["profilePictureURL": url]) { error in
            if let error = error {
                print("Error updating profile picture URL: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    currentUser.profilePictureURL = url
                }
                print("Profile picture URL updated successfully.")
            }
        }
    }

    // Save Post to Firestore
    func savePost(imageURL: String, content: String) {
        let db = Firestore.firestore()
        let postData: [String: Any] = [
            "userID": currentUser.uid,
            "content": content,
            "imageURL": imageURL,
            "timestamp": FieldValue.serverTimestamp()
        ]

        db.collection("posts").addDocument(data: postData) { error in
            if let error = error {
                print("Error saving post: \(error.localizedDescription)")
            } else {
                print("Post saved successfully.")
            }
        }
    }

    // Upload media to Firebase Storage
    func uploadMedia(image: UIImage, folder: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data."])))
            return
        }

        let storage = Storage.storage()
        let fileName = UUID().uuidString
        let storageRef = storage.reference().child("\(folder)/\(fileName).jpg")

        storageRef.putData(imageData, metadata: nil) { _, error in
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
