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
    var viewSelected: String = ""
    let emergencyString = "999"
    private let pages: [[String]] = [["Map","location.square"],["Advice","character.book.closed.fill"],["Voice Box","speaker.wave.2.bubble.left.fill"],["Countdown","timer.square"],["Alarm","light.beacon.max"],["Quick Dial","phone.bubble.left.fill"]] // titles and related images
    private let columns = [GridItem(.adaptive(minimum: 170))] // grid item columns, adaptive works in landscape too
    var body: some View {
        NavigationView {
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(pages, id: \.self) { page in
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color.white)
                            .frame(width: 170, height: 170)
                            .cornerRadius(30)
                            .border(Color.gray, width: /*@START_MENU_TOKEN@*/5/*@END_MENU_TOKEN@*/)
                        if "\(page[0])" == "Quick Dial" {
                            // link to quick dial (stays on page)
                            Button(action: {
                                let telephone = "tel://"
                                let formattedString = telephone + emergencyString
                                guard let url = URL(string: formattedString) else { return }
                                UIApplication.shared.open(url)
                                }) { VStack {
                                    // same formatting as below...
                                    Image(systemName: "\(page[1])")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: 100, maxHeight: 100)
                                    Text("\(page[0])")
                                        .font(.system(size: 20, design: .rounded))
                                        .bold()
                                    }
                                }
                        }
                        else {
                            // all other buttons go to a new view
                            NavigationLink {
                                whichView(viewSelected: "\(page[0])")
                            } label: {
                                VStack {
                                    Image(systemName: "\(page[1])")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: 100, maxHeight: 100)
                                    Text("\(page[0])")
                                        .font(.system(size: 20, design: .rounded))
                                        .bold()
                                }
                            }
                        }
                    }
                }
                
            }
        .navigationTitle("Home")
        .padding()
        }
    }
    func whichView(viewSelected: String) -> AnyView {
        print("Recieved: \(viewSelected)")
        if viewSelected == "Map" {
            return AnyView(MapView())
        }
        if viewSelected == "Advice" {
            return AnyView(AdviceView())
        }
        if viewSelected == "Voice Box" {
            return AnyView(VoiceBoxView())
        }
        if viewSelected == "Countdown" {
            return AnyView(CountdownView())
        }
        if viewSelected == "Alarm" {
            return AnyView(AlarmView())
        }
        if viewSelected == "Quick Dial" {
            return AnyView(CountdownView())
        }
        else {
            return AnyView(SettingsView())
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
