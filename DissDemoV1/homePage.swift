//
//  ContentView.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 01/02/2023.
//

import SwiftUI
import UIKit

// User Interface Code
struct homePage: View {
    var body: some View {
        var username = "Emily"
        NavigationStack {
            VStack {
                Image("wolfimage")
                Spacer()
                Text("Welcome, "+username)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                Spacer()
            
                HStack{
                    NavigationLink {
                        MapPage()
                    } label: {
                        Image(systemName: "map.fill")
                        Text("Maps")
                    }.controlSize(.large)
                        .buttonStyle(.borderedProminent)
                        .accentColor(.green)
                    
                    NavigationLink {
                        SOSPage()
                    } label: {
                        Image(systemName: "light.beacon.max.fill")
                        Text("SOS")
                    }.controlSize(.large)
                        .buttonStyle(.borderedProminent)
                        .accentColor(.red)
                }
                HStack{
                    NavigationLink {
                        FriendPage()
                    } label: {
                        Image(systemName: "figure.2.arms.open")
                        Text("Friends")
                    }.controlSize(.large)
                        .buttonStyle(.borderedProminent)
                        .accentColor(.pink)
                    
                    NavigationLink {
                        SettingsPage()
                    } label: {
                        Image(systemName: "gearshape.fill")
                        Text("Settings")
                    }.controlSize(.large)
                        .buttonStyle(.borderedProminent)
                        .accentColor(.gray)
                }
                Spacer()
            }
        }
    }
}
    

// used for creating the canvas

struct homePageView_Previews: PreviewProvider {
    static var previews: some View {
        // create several content views to make several screens with different devices etc
        homePage()
    }
}


// might need to find pixel width / height of screeen
// use to scale buttons and icons .frame(height: VARIABLE)

