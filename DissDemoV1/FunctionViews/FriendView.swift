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
    @Environment(\.colorScheme) var colorScheme // changes when in dark mode
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "person.2")
                        .font(.system(size: 30))
                        .foregroundColor(Color.purple)
                    Text("Friends")
                        .font(.system(size: 30, design: .monospaced))
                        .bold()
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
                }
                
                List(dataManager.friends, id: \.id) { friend in
                    NavigationLink(destination: FriendDetailsView(friend: friend)) {
                        Text(friend.username)
                            .bold()
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
                        
                    }
                }
                
                NavigationLink(destination: AddFriendView()) {
                    Text("Add Friend")
                        .bold()
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(colorScheme == .dark ? Color.purple.opacity(0.8) :  Color.purple.opacity(0.08) )
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


// for adding new friends
struct AddFriendView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.colorScheme) var colorScheme // changes when in dark mode
    @State private var searchText = ""
    @State private var foundUsers: [Friend] = []
    
    var body: some View {
        VStack {
            TextField("Search by username", text: $searchText)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
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
                    .background(colorScheme == .dark ? Color.purple.opacity(0.8) :  Color.purple.opacity(0.08) )
                    .cornerRadius(10)
            }
            
            if foundUsers.count > 0 {
                List(foundUsers, id: \.id) { user in
                    VStack(alignment: .leading) {
                        Text(user.username)
                            .font(.headline)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
                        Text(user.number)
                            .font(.subheadline)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
                    }.scrollContentBackground(.hidden) // removes background colour from scroll
                        .foregroundColor(.white)
                    .onTapGesture {
                        dataManager.addFriend(friendID: user.id)
                        sendAlertToFriend(friendID: user.id)
                    }
                }.padding()
            } else {
                Text("No results found")
                    .padding()
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
