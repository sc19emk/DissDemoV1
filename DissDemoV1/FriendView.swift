//
//  FriendsPage.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 05/02/2023.
//

//import Foundation
import SwiftUI
import Firebase

// Friend Page Code
struct FriendView: View {
    @EnvironmentObject var dataManager: DataManager
    var body: some View {
        NavigationView {
            List(dataManager.contacts, id: \.id) { contact in
                Text(contact.id)
            }.navigationTitle("Contacts")
        }
    }
}

// used for creating the canvas

struct FriendView_Previews: PreviewProvider {
    static var previews: some View {
        FriendView()
            .environmentObject(DataManager())
    }
}
