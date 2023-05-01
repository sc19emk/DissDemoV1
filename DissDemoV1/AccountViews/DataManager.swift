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
    @Published var friends: [Friend] = [] // currrent user's friends
    @Published var account: Account = Account(id:"", email:"", username:"", number:"", emergencyNumber: "") // current user's account details
    @Published var userIsLoggedIn =  false // is a user logged in
    @Published var currentUser =  "" // what is their username
    @Published var lat: Double = 0 // used for sharing location
    @Published var long: Double = 0 // used for sharing location
    @Published var unopenedNotificationsCount:Int = 0 // number of unopened notifications for the user
    
    let db = Firestore.firestore() // setting up the database
    
    func fetchAccount() {
        // if the user is logged in ...
        if let user = Auth.auth().currentUser {
            let id = user.uid // getting current user id
            let email = user.email ?? "x" // getting current user id
            let ref = db.collection("users") // check users database
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
                            self.fetchUnopenedNotificationsCount() // fetch number of unopened notifications
                        }
                    }
                }
            }
        }
    }
    
    func fetchFriends() {
        friends.removeAll() // empty any previously held contacts
        let ref = db.collection("friends") // access database table friends
        let query1 = ref.whereField("friend1", isEqualTo: self.account.id) // check for own user id
        let query2 = ref.whereField("friend2", isEqualTo: self.account.id) // in a friend relationship
        let dispatchGroup = DispatchGroup() // used to run tasks simultaneously

        // Check friend1 field
        dispatchGroup.enter() // start dispatch group
        query1.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription) // error accessing friends databse
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    if let friend2ID = data["friend2"] as? String {
                        self.fetchFriendDetails(friendID: friend2ID) // retrieve the corresponding friend
                    }
                }
            }
            dispatchGroup.leave() // completed search
        }

        // Check friend2 field
        dispatchGroup.enter()
        query2.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription) // error accessing friends database
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    print("found Document - adding!!! \(data)")
                    if let friend1ID = data["friend1"] as? String {
                        self.fetchFriendDetails(friendID: friend1ID) // retrieve the corresponding friend
                    }
                }
            }
            dispatchGroup.leave() // leave the group as finished
        }
}
    
    // retrieves friend's details using their user id
    func fetchFriendDetails(friendID: String) {
        db.collection("users").document(friendID).getDocument { snapshot, error in // friend user account with user id of the friend
            guard error == nil
            else {
                print(error!.localizedDescription) // error accessing users database
                return
            }
            if let snapshot = snapshot, let data = snapshot.data() {
                let username = data["username"] as? String ?? "" // retrieve username
                let number = data["number"] as? String ?? "" // retrieve phone number
                let friend = Friend(id: friendID, username: username, number: number) // set these details as a friend struct
                self.friends.append(friend) // add to current user's list of friends
            }
        }
    }
    
    // returns friends username - for notifications
    func fetchFriendUsername(friendID: String, completion: @escaping (String?) -> Void) {
        db.collection("users").document(friendID).getDocument { snapshot, error in // friend user account with user id of the friend
//            guard error == nil
//            else {
//                print(error!.localizedDescription) // error accessing users database
//                completion(nil)
//                return
//            }
            if let snapshot = snapshot, let data = snapshot.data() {
                let username = data["username"] as? String ?? "" // username found - set as return data
                completion(username)
            }
            else {
                completion(nil) // if another error occurs while setting the username
            }
        }
    }
    
    // used for finding new friends to add
    func searchUser(query: String, completion: @escaping ([Friend]) -> Void) {
        let userRef = db.collection("users") // using user databse
        var results: [Friend] = [] // results found , array of friends
        userRef.getDocuments { snapshot, error in // Search for user by username
            if let error = error {
                print("Error searching for user: \(error)")
                completion([])
            } else if let snapshot = snapshot, !snapshot.isEmpty {
                let queryLowercased = query.lowercased() // lower case the entered username
                for document in snapshot.documents {
                    let data = document.data()
                    let id = document.documentID // user id is document id
                    let username = data["username"] as? String ?? "x" // username searched for
                    let number = data["number"] as? String ?? "x" // phone number of account
                    let usernameLowercased = username.lowercased() // lower case the returned username for comparison
                    // use contains to find sub strings of eneterd username
                    if usernameLowercased.contains(queryLowercased) || queryLowercased.contains(usernameLowercased) {
                        let user = Friend(id: id, username: username, number: number) // set as friend found
                        results.append(user) // add found user to results array
                    }
                }
                completion(results) // return results
            }
        }
    }

    // function allowing users to add other users as friends
    func addFriend(friendID: String) {
        let ref = db.collection("friends") // access friends database
        let friendPair = ["friend1": self.account.id, "friend2": friendID] // create new friendship using both uid's
        ref.addDocument(data: friendPair) { error in
            if let error = error {
                print("Error adding document: \(error)") // error creating the document
            } else {
                self.fetchFriends() // update current user's friends
            }
        }
    }

    // function to remove a friend
    func deleteFriend(friendID: String) {
        let ref = db.collection("friends") // access friends database
        let query1 = ref.whereField("friend1", isEqualTo: self.account.id).whereField("friend2", isEqualTo: friendID) // search for friendship
        let query2 = ref.whereField("friend1", isEqualTo: friendID).whereField("friend2", isEqualTo: self.account.id)
        let dispatchGroup = DispatchGroup() // use dispatch groups to check both fields

        // Check for friend1 == current user, friend2 == friendID
        dispatchGroup.enter()
        query1.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription) // error
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    document.reference.delete() // delete the friendship
                }
            }
            dispatchGroup.leave() // finished task
        }

        // Check for friend1 == friendID, friend2 == current user
        dispatchGroup.enter()
        query2.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)  // error
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    document.reference.delete() // delete the friendship
                }
            }
            dispatchGroup.leave() // finished task
        }
        dispatchGroup.notify(queue: .main) {
            self.fetchFriends() // Update friends list after deleting the friend
        }
    }
    
    // remove current user from auth to log out
    func signOut() {
        try! Auth.auth().signOut() // use auth pre built sign out function
        currentUser = "" // remove current user info
        userIsLoggedIn = false // no user is logged in
    }
    
    // delete current user account
    func deleteAccount() {
        guard let user = Auth.auth().currentUser
        else {
            print("Error: current user is nil") // check the user is actually logged in
            return
        }
        let userId = user.uid // set current user id
        
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
        // now delete all user information
        dispatchGroup.notify(queue: .main) {
            // Delete user data
            self.db.collection("users").document(userId).delete { error in
                if let error = error {
                    print("Error removing document: \(error)") // error
                } else {
                    // Delete Auth data
                    user.delete(completion: { error in
                        if let error = error {
                            print("Error deleting user: \(error)") // error
                        } else {
                            self.signOut() // sign out once user has been deleted
                        }
                    })
                }
            }
        }
    }
    func fetchUnopenedNotificationsCount() {
        let ref = db.collection("notifications")
        ref.whereField("uidTo", isEqualTo: account.id) // to the current user
           .whereField("opened", isEqualTo: false) // that have not been opened
           .addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription) // error handler
                    return
                }
                guard let documents = snapshot?.documents else { return } // get the matching items
                self.unopenedNotificationsCount = documents.count // count the number of matching notifications
            }
    }
    
    // setting up data manager
    init() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.userIsLoggedIn = true // a user is logged in
                self.fetchAccount() // set their details
            } else {
                self.userIsLoggedIn = false
            }
        }
    }
}
