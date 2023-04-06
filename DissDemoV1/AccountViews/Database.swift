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
    var emergencyNumber: String // user's emergency contact number
}

// the details of each of the current user's friends - not access personal emergency num details 
struct Friend: Identifiable {
    var id: String // uid
    var username: String // username
    var number: String // phone number for contacting them
}

class DataManager: ObservableObject {
    @Published var friends: [Friend] = []
    @Published var account: Account = Account(id:"", email:"", username:"", number:"", emergencyNumber: "")
    @Published var userIsLoggedIn =  false
    @Published var currentUser =  ""
    @Published var lat: Double = 0 // used for sharing location
    @Published var long: Double = 0 // used for sharing location
    
    let db = Firestore.firestore() // setting up the database
    
    func fetchAccount() {
        let user = Auth.auth().currentUser
        let id = user!.uid // getting current user id
        let email = user!.email ?? "x" // getting current user id
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
                        let emergencyNumber = data["emergencyNumber"] as? String ?? "x"
                        let currentUser = Account(id:id, email:email, username:username, number:number, emergencyNumber:emergencyNumber)
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
    
    // does not access emergency number information
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
    
    // just returns username - for notifications
    func fetchFriendUsername(friendID: String, completion: @escaping (String?) -> Void) {
        print("fetching username for \(friendID)")
        db.collection("users").document(friendID).getDocument { snapshot, error in
            guard error == nil
            else {
                print(error!.localizedDescription)
                completion(nil)
                return
            }
            if let snapshot = snapshot, let data = snapshot.data() {
                let username = data["username"] as? String ?? "x"
                completion(username)
                print("Success \(username)")
            }
            else {
                completion(nil)
                print("fail")
            }
        }
    }
    
    func searchUser(query: String, completion: @escaping ([Friend]) -> Void) {
        let userRef = db.collection("users")
        print("Search taking place...")
        let dispatchGroup = DispatchGroup()
        
        var results: [Friend] = []

        // Search for user by email or username
        dispatchGroup.enter()
        userRef.getDocuments { snapshot, error in
            print("Search for query: \(query)")
            
            if let error = error {
                print("Error searching for user: \(error)")
                completion([])
            } else if let snapshot = snapshot, !snapshot.isEmpty {
                let queryLowercased = query.lowercased()
                
                for document in snapshot.documents {
                    let data = document.data()
                    let id = document.documentID // user id is document id
                    let username = data["username"] as? String ?? "x" // username searched for
                    let number = data["number"] as? String ?? "x" // phone number of account
                    
                    let usernameLowercased = username.lowercased()
                    
                    if usernameLowercased.contains(queryLowercased) || queryLowercased.contains(usernameLowercased) {
                        let user = Friend(id: id, username: username, number: number) // set as friend found
                        results.append(user)
                    }
                }
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            print("Finished searching for user")
            completion(results)
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
    
    func deleteAccount() {
        guard let user = Auth.auth().currentUser else {
            print("Error: current user is nil") // check the user is actually logged in again...
            return
        }
        
        let userId = user.uid
        
        // Delete friendships
        let ref = db.collection("friends")
        let query1 = ref.whereField("friend1", isEqualTo: userId)
        let query2 = ref.whereField("friend2", isEqualTo: userId)

        let dispatchGroup = DispatchGroup()

        // Delete friendships where friend1 == userId
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

        // Delete friendships where friend2 == userId
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
            // Delete user data
            self.db.collection("users").document(userId).delete { error in
                if let error = error {
                    print("Error removing document: \(error)")
                } else {
                    print("Document successfully removed!")
                    
                    // Delete Auth data
                    user.delete(completion: { error in
                        if let error = error {
                            print("Error deleting user: \(error)")
                        } else {
                            print("User successfully deleted")
                            self.signOut()
                        }
                    })
                }
            }
        }
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
