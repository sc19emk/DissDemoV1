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
        let username = "Emily" //change to var when taking input...
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
                        .accentColor(.black)
                    
                    Spacer()
                    
                    // link to settings page
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape.fill")
                        Text("Settings     ")
                        
                    }   .controlSize(.large)
                        .buttonStyle(.borderedProminent)
                        .padding(.trailing, 20.0)
                        .accentColor(.black)
                }
                Text("Welcome, "+username)
                    .font(.title)
                    .fontWeight(.semibold)
                
                Image("wolfimage")
                
                Spacer()
            
                HStack{
                    // link to countdown page
                    NavigationLink {
                        CountdownView()
                    } label: {
                        Image(systemName: "timer")
                        Text("Countdown")
                    }   .frame(width: 150, height: 50)
                        .background(.thinMaterial)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke (lineWidth: 2))
                        .padding()
                        .accentColor(.black)
                        .fontWeight(.bold)
                        
                    
                    Spacer()
                    
                    // link to maps page
                    NavigationLink {
                        MapView()
                    } label: {
                        Image(systemName: "map.fill")
                        Text("Map")
                    }
                    .frame(width: 150, height: 50)
                    .background(.thinMaterial)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke (lineWidth: 2))
                    .padding()
                    .accentColor(.black)
                    .fontWeight(.bold)
                }
                
                HStack{
                    // link to text to speech page
                    Spacer()
                    NavigationLink {
                        VoiceBoxView()
                    } label: {
                        Image(systemName: "ellipsis.bubble")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .accentColor(.black)
                            
                    }
                    // link to ADVICE page
                    Spacer()
                    Spacer()
                    NavigationLink {
                        AdviceView()
                    } label: {
                        Image(systemName: "newspaper")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    Spacer()
                     

                }
                HStack {
                    // link to alarm page
                    NavigationLink {
                        AlarmView()
                    } label: {
                        Image(systemName: "light.beacon.max.fill")
                        Text("Alarm             ")
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

