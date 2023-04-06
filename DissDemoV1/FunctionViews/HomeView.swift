//
//  ContentView.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 01/02/2023.
//

import SwiftUI
import UIKit
import FirebaseFirestore

struct HomeView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.colorScheme) var colorScheme // changes when in dark mode
    @State private var unopenedNotificationsCount: Int = 0 // for the notification page

    private let pages: [(String, String)] = [
            ("Account", "person.text.rectangle"),
            ("Friends", "person.2"),
            ("Notifications", "ellipsis.message"),
            ("Advice", "character.book.closed"),
            ("Map", "map"),
            ("Voice Box", "waveform.circle"),
            ("Countdown", "timer.square"),
            ("Alarm", "light.beacon.max"),
            ("Quick Dial", "phone.arrow.up.right"),
        ]

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                HStack {
                    Text("Safely")
                        .font(.system(size: 30, design: .monospaced))
                        .bold()
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
                }
                Spacer()
                
                ScrollView {
                    VStack(spacing: 11) {
                        ForEach(pages, id: \.0) { (page, iconName) in
                            pageElement(page: page, iconName: iconName)
                        }
                    }
                    .padding()
                }

                Spacer()
            }
            .navigationBarTitle("Home", displayMode: .inline)
            .navigationBarHidden(true)
        }.accentColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
    }

    func pageElement(page: String, iconName: String) -> some View {
        let content: some View = {
            HStack {
                Image(systemName: iconName)
                    .font(.system(size: 30))
                    .foregroundColor(iconColor(page: page))
                
                Text(page)
                    .font(.system(size: 20, design: .rounded))
                    .bold()
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // Update text color based on the color scheme
                
                if page == "Notifications" && unopenedNotificationsCount > 0 {
                    Text("\(unopenedNotificationsCount)")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .offset(x: 10, y: -10)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
        }()

        if page == "Quick Dial" {
            return AnyView(
                Button {
                    let telephone = "tel://"
                    let emergencyNumber = dataManager.account.emergencyNumber
                    let formattedString = telephone + emergencyNumber
                    guard let url = URL(string: formattedString) else { return }
                    UIApplication.shared.open(url)
                } label: {
                    content
                }.padding(.vertical)
                .background(colorScheme == .dark ? Color(.systemGray6) : Color.white)
                .cornerRadius(10)
                .shadow(color: iconColor(page: page).opacity(0.3), radius: 5, x: 0, y: 5)
            )
        } else {
            return AnyView(
                NavigationLink(destination: whichView(viewSelected: page)) {
                    content
                }.onAppear(perform: fetchUnopenedNotificationsCount) // fetch the unopened notifications count when the button appears
                    .padding(.vertical)
                    .background(colorScheme == .dark ? Color(.systemGray6) : Color.white ) //alternate colour scheme for buttons
                    
                    .cornerRadius(10)
                    .shadow(color: iconColor(page: page).opacity(0.4), radius: 5, x: 1, y: 5)
                )
            }
        }
    
    func whichView(viewSelected: String) -> AnyView {
        switch viewSelected {
        case "Friends":
            return AnyView(FriendView())
        case "Account":
            return AnyView(SettingsView())
        case "Map":
            return AnyView(MapView())
        case "Advice":
            return AnyView(AdviceView())
        case "Voice Box":
            return AnyView(VoiceBoxView())
        case "Countdown":
            return AnyView(CountdownView(dataManager: dataManager))
        case "Alarm":
            return AnyView(AlarmView())
        case "Notifications":
            return AnyView(NotificationView())
        default:
            return AnyView(EmptyView())
        }
    }
    func iconColor(page: String) -> Color {
        switch page {
        case "Account":
            return Color.purple
        case "Friends":
            return Color.indigo
        case "Notifications":
            return Color.blue
        case "Advice":
            return Color.mint
        case "Map":
            return Color.green
        case "Voice Box":
            return Color.yellow
        case "Countdown":
            return Color.orange
        case "Quick Dial":
            return Color.red
        case "Alarm":
            return Color.pink
        default:
            return Color.black
        }
    }
    func fetchUnopenedNotificationsCount() {
        let ref = Firestore.firestore().collection("notifications")
        ref.whereField("uidTo", isEqualTo: dataManager.account.id).whereField("opened", isEqualTo: false).addSnapshotListener { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            unopenedNotificationsCount = snapshot?.documents.count ?? 0
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
