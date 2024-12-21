//
//  setup.swift
//  Visio
//
//  Created by Elias Alamat on 12/13/24.
//

import Firebase

func setupFirestoreStructure() {
    let db = Firestore.firestore()
    
    // Define the conversation ID
    let conversationID = "user1_user2"
    
    // Define the participants
    let participants = ["user1", "user2"]
    
    // Step 1: Write the parent document with participants
    db.collection("messages")
        .document(conversationID)
        .setData(["participants": participants]) { error in
            if let error = error {
                print("Error writing parent document: \(error.localizedDescription)")
            } else {
                print("Parent document written successfully!")
                
                // Step 2: Write the chat messages
                let messages = [
                    [
                        "senderID": "user1",
                        "receiverID": "user2",
                        "text": "Hello!",
                        "timestamp": Timestamp(date: Date()),
                        "participants": participants
                    ],
                    [
                        "senderID": "user2",
                        "receiverID": "user1",
                        "text": "Hi!",
                        "timestamp": Timestamp(date: Date().addingTimeInterval(60)),
                        "participants": participants
                    ]
                ]
                
                // Write messages to Firestore
                for (index, message) in messages.enumerated() {
                    db.collection("messages")
                        .document(conversationID)
                        .collection("chat")
                        .document("message\(index + 1)")
                        .setData(message) { error in
                            if let error = error {
                                print("Error writing message \(index + 1): \(error.localizedDescription)")
                            } else {
                                print("Message \(index + 1) written successfully!")
                            }
                        }
                }
            }
        }
}
