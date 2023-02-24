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
    //let theme: Theme
    var body: some View {
        var username = "Emily"
        let emergencyString = "999"
        NavigationStack {
            VStack {
                HStack{
                    // link to friends page
                    NavigationLink {
                        //FriendView()
                    } label: {
                        Image(systemName: "figure.2.arms.open")
                        Text("Friends         ")
                    }
                    .padding(20.0)
                    .controlSize(.large)
                        .buttonStyle(.borderedProminent)
                    
                    Spacer()
                    
                    // link to settings page
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape.fill")
                        Text("Settings     ")
                        
                    }.controlSize(.large)
                        .buttonStyle(.borderedProminent)
                        .padding(.trailing, 20.0)
                        .accentColor(.black)
                }
                Image("wolfimage")
                Spacer()
                Text("Welcome, "+username)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
            
                HStack{
                    // link to countdown page
                    NavigationLink {
                        CountdownView()
                    } label: {
                        Image(systemName: "timer")
                        Text("Countdown   ")
                    }.controlSize(.large)
                        .buttonStyle(.borderedProminent)
                        .padding(20.0)
                        .accentColor(.black)
                    
                    Spacer()
                    
                    // link to maps page
                    NavigationLink {
                        MapView()
                    } label: {
                        Image(systemName: "map.fill")
                        Text("Maps           ")
                    }.controlSize(.large)
                        .buttonStyle(.borderedProminent)
                        .padding(.trailing, 20.0)
                        .accentColor(.black)
                    
                }
                
                HStack{
                    // link to text to speech page
                    NavigationLink {
                        SpeechView()
                    } label: {
                        Image(systemName: "ellipsis.bubble.fill")
                        Text("Speech          ")
                    }.controlSize(.large)
                        .buttonStyle(.borderedProminent)
                        .padding(20.0)
                        .accentColor(.black)
                    
                    Spacer()
                    
                    // link to ADVICE page
                    NavigationLink {
                        AdviceView()
                    } label: {
                        Image(systemName: "newspaper.fill")
                        Text("Advice        ")
                    }.controlSize(.large)
                        .buttonStyle(.borderedProminent)
                        .padding(.trailing, 20.0)
                        .accentColor(.black)

                }
                HStack {
                    // link to alarm page
                    NavigationLink {
                        AlarmView()
                    } label: {
                        Image(systemName: "light.beacon.max.fill")
                        Text("Alarm           ")
                    }
                        .controlSize(.large)
                        .buttonStyle(.borderedProminent)
                        .padding(20.0)
                        .accentColor(.black)
                    
                    Spacer()
                    
                    // link to quick dial (stays on page)
                    Button(action: {
                        let telephone = "tel://"
                        let formattedString = telephone + emergencyString
                        guard let url = URL(string: formattedString) else { return }
                        UIApplication.shared.open(url)
                        }) {
                            Image(systemName: "phone.connection.fill")
                            Text("Quick Dial   ")
                    }
                        .controlSize(.large)
                        .buttonStyle(.borderedProminent)
                        .padding(.trailing, 20.0)
                        .accentColor(.black)
                        
                }
            }.padding()
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

