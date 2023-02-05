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
    var body: some View {
        ZStack{
            Color.pink.ignoresSafeArea()
            VStack{
                Text("Friends Page").font(.title).bold()
                Text("Allow user to add/remove friends - see alerts / send GPS messages?")
                    .multilineTextAlignment(.center)
            }
            
        }
        
    }
}

// used for creating the canvas

struct FriendView_Previews: PreviewProvider {
    static var previews: some View {
        FriendView()
    }
}
