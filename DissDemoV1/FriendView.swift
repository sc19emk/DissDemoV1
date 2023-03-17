//
//  FriendsPage.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 05/02/2023.
//

//import Foundation
import SwiftUI

// Friend Page Code
struct FriendView: View {
    let friend: Friend
    var body: some View {
        VStack{
            Text("Friends Page").font(.title).bold()
            Text(friend.name).font(.headline)
            HStack {
                Label("\(friend.messages.count)", systemImage: "message.fill")
            }
            Label("\(friend.number)", systemImage: "phone.arrow.down.left.fill")
        }.font(.caption)
    }
}

// used for creating the canvas

struct FriendView_Previews: PreviewProvider {
    static var friend = Friend.sampleData[0] // example data
    static var previews: some View {
        FriendView(friend: friend)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}

struct Friend {
    var name: String
    var messages: [String]
    var number: Int
}

extension Friend {
    static let sampleData: [Friend] =
    [
        Friend(name: "Friend 1", messages: ["Hello", "Goodbye"], number: 01234),
        Friend(name: "Friend 2", messages: ["HELP", "LOCATION"], number: 56789)
    ]
}
