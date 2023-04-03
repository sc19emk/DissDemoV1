//  Account.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 17/03/2023.
//

import SwiftUI
import Firebase

// current user's account details
struct Account: Identifiable {
    var id: String // uid
    var email: String //email
    var username: String //username
    var number: String //phoneNumber
}

// the details of each of the current user's friends
struct Friend: Identifiable {
    var id: String // uid
    var username: String // username
    var number: String // phone number for contacting them
}

class DataManager: ObservableObject {
    @Published var friends: [Friend] = []
    @Published var account: Account = Account(id:"", email:"", username:"", number:"")
    @Published var userIsLoggedIn =  false
    @Published var currentUser =  ""
    
    let db = Firestore.firestore() // setting up the database
    
    func fetchAccount() {
        let user = Auth.auth().currentUser
        let id = user!.uid // getting current user id
        let email = user!.email as? String ?? "x" // getting current user id
        let ref = db.collection("users")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()

                    let currentid = data["UID"] as? String ?? "x"

                    if currentid == id {
                        let username = data["username"] as? String ?? "x"
                        let number = data["number"] as? String ?? "x"
                        let currentUser = Account(id:id, email:email, username:username, number:number)
                        self.account = currentUser
                        self.fetchFriends() // Call fetchFriends after setting the account property
                    }
                }
            }
        }
    }
    
func fetchFriends() {
        friends.removeAll() // empty any previously held contacts
        let ref = db.collection("friends") // access database table friends
        print("searching for id: \(self.account.id)")

        let query1 = ref.whereField("friend1", isEqualTo: self.account.id)
        let query2 = ref.whereField("friend2", isEqualTo: self.account.id)

        let dispatchGroup = DispatchGroup()

        // Check friend1 field
        dispatchGroup.enter()
        query1.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                print("QUERY ERROR")
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    print("found Document - adding!!! \(data)")
                    if let friend2ID = data["friend2"] as? String {
                        self.fetchFriendDetails(friendID: friend2ID)
                    }
                }
            }
            dispatchGroup.leave()
        }

        // Check friend2 field
        dispatchGroup.enter()
        query2.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                print("QUERY ERROR")
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    print("found Document - adding!!! \(data)")
                    if let friend1ID = data["friend1"] as? String {
                        self.fetchFriendDetails(friendID: friend1ID)
                    }
                }
            }
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            print("Finished fetching friends")
        }
    }
    
    func fetchFriendDetails(friendID: String) {
        print("fetching friend details for \(friendID)")
        db.collection("users").document(friendID).getDocument { snapshot, error in
            guard error == nil
            else {
                print(error!.localizedDescription)
                return
            }
        
            if let snapshot = snapshot, let data = snapshot.data() {
                let username = data["username"] as? String ?? "x"
                let number = data["number"] as? String ?? "x"
                let friend = Friend(id: friendID, username: username, number: number)
                self.friends.append(friend)
            }
        }
    }
    
    func searchUser(query: String, completion: @escaping (Friend?) -> Void) {
        let userRef = db.collection("users")
        print("Search taking place...")
        let dispatchGroup = DispatchGroup()

        // Search for user by email or username
        dispatchGroup.enter()
        userRef.whereField("username", isEqualTo: query).getDocuments { snapshot, error in
            print("Search for username: \(query)")
            
            if let error = error {
                print("Error searching for user: \(error)")
                completion(nil)
            } else if let snapshot = snapshot, !snapshot.isEmpty {
                print("Found username !!! : \(query)")
                let document = snapshot.documents.first!
                let data = document.data()
                let id = document.documentID // user id is document id
                let username = data["username"] as? String ?? "x" // username searched for
                let number = data["number"] as? String ?? "x" // phone number of account
                
                let user = Friend(id: id, username: username, number: number) // set as friend found
                completion(user) // return the user found
            } else {
                completion(nil)
            }
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            print("Finished searching for user")
        }
    }

    func addFriend(friendID: String) {
        let ref = db.collection("friends")
        let friendPair = ["friend1": self.account.id, "friend2": friendID]

        ref.addDocument(data: friendPair) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added with ID: \(ref.document().documentID)")
                self.fetchFriends()
            }
        }
    }

    
    func deleteFriend(friendID: String) {
        let ref = db.collection("friends")
        let query1 = ref.whereField("friend1", isEqualTo: self.account.id).whereField("friend2", isEqualTo: friendID)
        let query2 = ref.whereField("friend1", isEqualTo: friendID).whereField("friend2", isEqualTo: self.account.id)

        let dispatchGroup = DispatchGroup()

        // Check for friend1 == current user, friend2 == friendID
        dispatchGroup.enter()
        query1.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    document.reference.delete()
                }
            }
            dispatchGroup.leave()
        }

        // Check for friend1 == friendID, friend2 == current user
        dispatchGroup.enter()
        query2.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    document.reference.delete()
                }
            }
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            self.fetchFriends() // Update friends list after deleting the friend
        }
    }

    
    func signOut() {
        try! Auth.auth().signOut()
        currentUser = ""
        userIsLoggedIn = false
    }
    
    init() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.userIsLoggedIn = true
                self.fetchAccount()
            } else {
                self.userIsLoggedIn = false
            }
        }
    }
}
