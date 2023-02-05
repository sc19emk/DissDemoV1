//
//  ContentView.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 01/02/2023.
//

import SwiftUI
import UIKit

// User Interface Code
struct HomeView: View {
    var body: some View {
        var username = "Emily"
        NavigationStack {
            VStack {
                HStack{
                    NavigationLink {
                        FriendView()
                    } label: {
                        Image(systemName: "figure.2.arms.open")
                        Text("Friends")
                    }
                    .padding(20.0)
                    .controlSize(.large)
                        .buttonStyle(.borderedProminent)
                        .accentColor(.pink)
                    Spacer()
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape.fill")
                        Text("Settings")
                        
                    }.padding(20.0)
                    .controlSize(.large)
                        .buttonStyle(.borderedProminent)
                        .accentColor(.gray)
                }
                Image("wolfimage")
                Spacer()
                Text("Welcome, "+username)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                Spacer()
            
                HStack{
                    NavigationLink {
                        CountdownView()
                    } label: {
                        Image(systemName: "timer")
                        Text("Countdown")
                    }.controlSize(.large)
                        .buttonStyle(.borderedProminent)
                        .accentColor(.blue)
                    
                    NavigationLink {
                        MapView()
                    } label: {
                        Image(systemName: "map.fill")
                        Text("Maps")
                    }.controlSize(.large)
                        .buttonStyle(.borderedProminent)
                        .accentColor(.green)
                    
                }
                
                HStack{
                    NavigationLink {
                        SpeechView()
                    } label: {
                        Image(systemName: "waveform")
                        Text("Speech")
                    }.controlSize(.large)
                        .buttonStyle(.borderedProminent)
                        .accentColor(.yellow)
                    NavigationLink {
                        AlarmView()
                    } label: {
                        Image(systemName: "light.beacon.max.fill")
                        Text("Alarm")
                    }.controlSize(.large)
                        .buttonStyle(.borderedProminent)
                        .accentColor(.purple)

                }
                NavigationLink {
                    QuickDialView()
                } label: {
                    Image(systemName: "phone.connection.fill")
                    Text("Quick Dial")
                }.controlSize(.large)
                    .buttonStyle(.borderedProminent)
                    .accentColor(.red)
                

                Spacer()
            }
        }
    }
}
    

// used for creating the canvas

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        // create several content views to make several screens with different devices etc
        HomeView()
    }
}


// might need to find pixel width / height of screeen
// use to scale buttons and icons .frame(height: VARIABLE)

