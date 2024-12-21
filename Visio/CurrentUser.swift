//
//  CurrentUser.swift
//  Visio
//
//  Created by Elias Alamat on 12/12/24.
//


import SwiftUI
//
//class CurrentUser: ObservableObject {
//    @Published var uid: String = ""
//    @Published var username: String = ""
//    @Published var email: String = ""
//
//    func reset() {
//        self.uid = ""
//        self.username = ""
//        self.email = ""
//    }
//}

// CurrentUser.swift

// CurrentUser.swift

import Foundation
import FirebaseAuth
import FirebaseFirestore

// MARK: - CurrentUser Class
class CurrentUser: ObservableObject {
    static let shared = CurrentUser()
    
    @Published var uid: String = ""
    @Published var username: String = ""
    @Published var following: Set<String> = [] // Set of user UIDs the current user is following
    @Published var followers: Set<String> = [] // Set of user UIDs following the current user
    
    private var followingListener: ListenerRegistration?
    private var followersListener: ListenerRegistration?
    
    private init() {}
    
    func reset() {
        uid = ""
        username = ""
        following = []
        followers = []
        followingListener?.remove()
        followersListener?.remove()
    }
    
    func setupListeners() {
        guard !uid.isEmpty else { return }
        let db = Firestore.firestore()
        
        // Listener for following
        followingListener = db.collection("users").document(uid).collection("following").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error listening to following: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            let followingUIDs = documents.map { $0.documentID }
            DispatchQueue.main.async {
                self.following = Set(followingUIDs)
            }
        }
        
        // Listener for followers
        followersListener = db.collection("users").document(uid).collection("followers").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error listening to followers: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            let followerUIDs = documents.map { $0.documentID }
            DispatchQueue.main.async {
                self.followers = Set(followerUIDs)
            }
        }
    }
}
