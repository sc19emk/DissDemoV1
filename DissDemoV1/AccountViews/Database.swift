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

class DataManager: ObservableObject {
    @Published var contacts: [Contact] = []
    
    init() {
        fetchContacts()
    }
    
    func fetchContacts() {
        contacts.removeAll()
        let db = Firestore.firestore() // setting up the database
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
}
