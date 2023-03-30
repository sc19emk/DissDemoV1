//
//  Account.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 17/03/2023.
//

import SwiftUI
import Firebase

struct Contact: Identifiable {
    var id: String // user id??
    var friends: [String] // user id of friends
}

struct Account: Identifiable {
    var id: String // uid
    var email: String //email
    var username: String //username
    var number: String //phoneNumber
}

class DataManager: ObservableObject {
    @Published var contacts: [Contact] = []
    @Published var account: Account = Account(id:"", email:"", username:"", number:"")
    @Published var userIsLoggedIn =  false
    @Published var currentUser =  ""
    
    let db = Firestore.firestore() // setting up the database
    
    func fetchAccount() {
        let user = Auth.auth().currentUser
        let id = user!.uid // getting current user id
        print("current user \(id)")
        let email = user!.email as? String ?? "x" // getting current user id
        let ref = db.collection("users")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                // looping too much ...
                for document in snapshot.documents {
                    let data = document.data()
                    print("Current data: \(data)")
                    
                    let currentid = data["UID"] as? String ?? "x"// set as string, unless empty, which sets to ""
                    print(currentid)
                    
                    if currentid == id {
                        print("yayyy im a genius")
                        let username = data["username"] as? String ?? "x"
                        let number = data["number"] as? String ?? "x"
                        let currentUser = Account(id:id, email:email, username:username, number:number)
                        self.account = currentUser
                    }
                }
            }
        }
    }
    
    func fetchContacts() {
        contacts.removeAll()
        let ref = db.collection("Contacts")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let id = data["id"] as? String ?? ""// set as string, unless empty, which sets to ""
                    let friends = data["friends"] as? [String] ?? [""] // set as string, unless empty, which sets to ""
                    let contact = Contact(id: id, friends: friends)
                    self.contacts.append(contact)
                }
            }
        }
    }
    init() {
        fetchAccount()
        fetchContacts()
    }
    
}
