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
    private let pages: [[String]] = [["Friends","person.2.fill"],["Account","person.text.rectangle"],["Map","location.square"],["Advice","character.book.closed.fill"],["Voice Box","speaker.wave.2.bubble.left.fill"],["Countdown","timer.square"],["Alarm","light.beacon.max"],["Quick Dial","phone.bubble.left.fill"]] // titles and related images
    private let colours: [Color] = [.white, .green, .gray, .blue, .yellow, .orange]
    @State var colourCount = 0
    private let columns = [GridItem(.flexible()), GridItem(.flexible())] // grid item columns, adaptive works in landscape too
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                RoundedRectangle(cornerRadius: 0, style: .continuous)
                    .foregroundStyle(.linearGradient(colors: [.white,.gray], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 550, height: 400)
                    .rotationEffect(.degrees(-3))
                    .offset(y: -550)
                LazyVGrid(columns: columns, spacing: 35) {
                    ForEach(pages, id: \.self) { page in
                        
                        ZStack {
//                            Rectangle()
//                                .foregroundColor(Color.white)
//                                .frame(width: 170, height: 170)
//                                .cornerRadius(30)
//                                .border(Color.gray, width: /*@START_MENU_TOKEN@*/5/*@END_MENU_TOKEN@*/)
                            
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
                                            .foregroundStyle(.linearGradient(colors: [.blue], startPoint: .top, endPoint: .bottomTrailing))
                                        Text("\(page[0])")
                                            .font(.system(size: 20, design: .rounded))
                                            .bold()
                                            .foregroundColor(.white)
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
                                            .foregroundColor(colours[colourCount])
                                        Text("\(page[0])")
                                            .font(.system(size: 20, design: .rounded))
                                            .bold()
                                            .foregroundColor(.white)
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
    }
    func whichView(viewSelected: String) -> AnyView {

        print("Recieved: \(viewSelected)")
        if viewSelected == "Friends" {
            return AnyView(FriendView())
        }
        if viewSelected == "Settings" {
            return AnyView(SettingsView())
        }
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
        HomeView().environmentObject(DataManager())
    }
}


// might need to find pixel width / height of screeen
// use to scale buttons and icons .frame(height: VARIABLE)
