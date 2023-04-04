//  FriendsPage.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 05/02/2023.
// able to add friends multiple times
// able to add self
// case sensitive
// doesnt find similar names 

import SwiftUI
import Firebase

// Friend Page Code
struct FriendView: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        NavigationView {
            VStack {
                List(dataManager.friends, id: \.id) { friend in
                    NavigationLink(destination: FriendDetailsView(friend: friend)) {
                        Text(friend.username)
                    }
                }.navigationTitle("Contacts")
                
                NavigationLink(destination: AddFriendView()) {
                    Text("Add Friend")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }.padding()
            }
        }
    }
}

// Friend Details Page
struct FriendDetailsView: View {
    @EnvironmentObject var dataManager: DataManager // for accessing deleting the current friend
    var friend: Friend
    
    var body: some View {
        VStack {
            Text("Username: \(friend.username)")
            Text("Phone number: \(friend.number)")
            Button(
                action: {
                    dataManager.deleteFriend(friendID: friend.id)
                }) {
                Text("Remove Friend")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
        }.padding()
        .navigationTitle("Friend Details")
    }
}

// for adding new friends
struct AddFriendView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var searchText = ""
    @State private var foundUser: Friend? = nil
    
    var body: some View {
        VStack {
            TextField("Search by username", text: $searchText)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            Button(action: {
                dataManager.searchUser(query: searchText, completion: { user in
                    foundUser = user
                })
            }) {
                Text("Search")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            if let user = foundUser {
                VStack {
                    Text("Username: \(user.username)")
                    Text("Number: \(user.number)")
                    
                    Button(action: {
                        dataManager.addFriend(friendID: user.id)
                        sendAlertToFriend(friendID: user.id)
                    }) {
                        Text("Add Friend")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }.padding()
            }
        }.padding()
        .navigationTitle("Add Friend")
    }
    
    func sendAlertToFriend(friendID: String) {
        let uidFrom = dataManager.account.id
        let type = 4
        let contents = "You have been added as a friend."
        let uidTo = friendID
        let ref = Firestore.firestore().collection("notifications")
        let data: [String: Any] = [
            "uidFrom": uidFrom,
            "uidTo": uidTo,
            "type": type,
            "opened": false,
            "contents": contents,
            "timestamp": Timestamp()
        ]

        ref.addDocument(data: data) { error in
            if let error = error {
                print("Error sending notification: \(error.localizedDescription)")
            } else {
                print("Notification sent to friend: \(uidTo)")
            }
        }
    }
}



// used for creating the canvas

struct FriendView_Previews: PreviewProvider {
    static var previews: some View {
        FriendView().environmentObject(DataManager())
    }
}
