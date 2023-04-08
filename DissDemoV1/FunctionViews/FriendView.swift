//  FriendsPage.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 05/02/2023.

import SwiftUI
import Firebase

// Friend Page Code
struct FriendView: View {
    @EnvironmentObject var dataManager: DataManager // for database access
    @Environment(\.colorScheme) var colorScheme // changes when in dark mode
    
    var body: some View {
        NavigationView {
            VStack {
                // page title
                HStack {
                    Image(systemName: "person.2")
                        .font(.system(size: 30))
                        .foregroundColor(Color.purple)
                    Text("Friends")
                        .font(.system(size: 30, design: .monospaced))
                        .bold()
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
                }
                // list of the current users friends
                List(dataManager.friends, id: \.id) { friend in
                    //link to more information about that friend
                    NavigationLink(destination: FriendDetailsView(friend: friend)) {
                        Text(friend.username)
                            .bold()
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
                        
                    }
                }
                // link to a new page to add new friends
                NavigationLink(destination: AddFriendView()) {
                    Text("Add Friend")
                        .bold()
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(colorScheme == .dark ? Color.purple.opacity(0.8) :  Color.purple.opacity(0.35))
                        .cornerRadius(10)
                    
                }.padding()
            }
        }
    }
}

// Friend Details Page
struct FriendDetailsView: View {
    @EnvironmentObject var dataManager: DataManager // for accessing deleting the current friend
    @Environment(\.colorScheme) var colorScheme // changes when in dark mode

    var friend: Friend
    
    var body: some View {
        VStack {
            HStack {
                Text("Username: ")
                    .bold()
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
                Text("\(friend.username)")
                    .bold()
                    .foregroundColor(Color.purple) // change text color based on the color scheme
            }
            
            HStack {
                Text("Phone Number: ")
                    .bold()
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
                Text("\(friend.number)")
                    .bold()
                    .foregroundColor(Color.purple) // change text color based on the color scheme
            }
            Button(
                action: {
                    dataManager.deleteFriend(friendID: friend.id)
                }) {
                Text("Remove Friend")
                    .bold()
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .background(colorScheme == .dark ? Color.red.opacity(0.8) :  Color.red.opacity(0.08) )
                    .cornerRadius(10)
            }
        }.padding()
        .navigationTitle("Friend Details")
    }
}


// new view for adding new friends
struct AddFriendView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.colorScheme) var colorScheme // changes when in dark mode
    @State private var searchText = "" // used for search query
    @State private var foundUsers: [Friend] = [] // found with search query
    @State private var selectedUsers: Set<String> = []  // used for adding new friends
    
    var body: some View {
        VStack {
            // text entry for entering the friend's username
            TextField("Search by username", text: $searchText)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            // performs search query
            if selectedUsers.isEmpty {
                // Search button
                Button(action: {
                    dataManager.searchUser(query: searchText, completion: { users in
                        foundUsers = users
                    })
                }) {
                    Text("Search")
                        .bold()
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(colorScheme == .dark ? Color.purple.opacity(0.8) :  Color.purple.opacity(0.35))
                        .cornerRadius(10)
                }
            } else {
                // Add button
                Button(action: {
                    for userID in selectedUsers {
                        dataManager.addFriend(friendID: userID)
                        sendAlertToFriend(friendID: userID)
                    }
                    selectedUsers.removeAll()
                }) {
                    Text("Add")
                        .bold()
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(colorScheme == .dark ? Color.green.opacity(0.8) :  Color.green.opacity(0.35))
                        .cornerRadius(10)
                }
            }
            // displays all matching users
            if foundUsers.count > 0 {
                List(foundUsers, id: \.id) { user in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(user.username)
                                .font(.headline)
                                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            
                            Checkbox(isChecked: selectedUsers.contains(user.id), onToggle: { isChecked in
                                if isChecked {
                                    selectedUsers.insert(user.id)
                                } else {
                                    selectedUsers.remove(user.id)
                                }
                            })
                        }
                    }.background(colorScheme == .dark ? Color.black : Color.white) // change background color based on the color scheme
                }.padding()
                    .listStyle(.plain)
                    .background(colorScheme == .dark ? Color.black : Color.white)
            } else {
                Text("No results found")
                    .padding()
            }
        }.padding()
        .navigationTitle("Add Friend")
    }
    // sends a notification to the person you added
    func sendAlertToFriend(friendID: String) {
        let uidFrom = dataManager.account.id // setting up the message
        let type = 4
        let contents = "You have been added as a friend."
        let uidTo = friendID
        let ref = Firestore.firestore().collection("notifications") // storing it in the database
        let data: [String: Any] = [
            "uidFrom": uidFrom,
            "uidTo": uidTo,
            "type": type,
            "opened": false,
            "contents": contents,
            "timestamp": Timestamp()
        ]
        // if any errors occured 
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
