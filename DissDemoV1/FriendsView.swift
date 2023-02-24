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
        .foregroundColor(friend.theme.accentColor)
    }
}

// used for creating the canvas

struct FriendView_Previews: PreviewProvider {
    static var friend = Friend.sampleData[0] // example data
    static var previews: some View {
        FriendView(friend: friend)
            .background(friend.theme.mainColor)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
