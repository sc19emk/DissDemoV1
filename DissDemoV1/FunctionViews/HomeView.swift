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
    @State private var unopenedNotificationsCount: Int = 0 // for the notification page

    private let pages: [(String, String)] = [
        ("Account", "person.text.rectangle"),
        ("Friends", "person.2.fill"),
        ("Notifications", "phone.bubble.left.fill"),
        ("Advice", "character.book.closed.fill"),
        ("Map", "location.square"),
        ("Voice Box", "speaker.wave.2.bubble.left.fill"),
        ("Countdown", "timer.square"),
        ("Alarm", "light.beacon.max"),
        ("Quick Dial", "phone.bubble.left.fill")
    ]

    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                Text("Home")
                    .font(.system(size: 30, design: .rounded))
                    .bold()
                    .foregroundColor(Color.black)

                Divider()

                ScrollView {
                    VStack(spacing: 30) {
                        ForEach(pages, id: \.0) { (page, iconName) in
                            if page == "Quick Dial" {
                                Button {
                                    let telephone = "tel://"
                                    let emergencyNumber = dataManager.account.emergencyNumber
                                    let formattedString = telephone + emergencyNumber
                                    guard let url = URL(string: formattedString) else { return }
                                    UIApplication.shared.open(url)
                                } label: {
                                    HStack {
                                        Image(systemName: iconName)
                                            .font(.system(size: 30))
                                            .foregroundColor(iconColor(page: page))

                                        Text(page)
                                            .font(.system(size: 20, design: .rounded))
                                            .bold()
                                            .foregroundColor(Color.black)
                                    }
                                }
                            }
                            else {
                                pageView(page: page, iconName: iconName)
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationBarTitle("Home", displayMode: .inline)
            .navigationBarHidden(true)
        }
    }
    
    // returns the formatting for each page
    
    func pageView(page: String, iconName: String) -> some View {
        let content: some View = {
            HStack {
                Image(systemName: iconName)
                    .font(.system(size: 30))
                    .foregroundColor(iconColor(page: page))

                Text(page)
                    .font(.system(size: 20, design: .rounded))
                    .bold()
                    .foregroundColor(Color.black)

                // notification count bubble
                if page == "Notifications" && unopenedNotificationsCount > 0 {
                    Text("\(unopenedNotificationsCount)")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.red)
                        .clipShape(Circle())
                        .offset(x: 10, y: -10)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
        }()
        return AnyView(NavigationLink(destination: whichView(viewSelected: page)) {
            content
        }.onAppear(perform: fetchUnopenedNotificationsCount)) // fetch the unopened notifications count when the button appears
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
            case "Friends":
                return Color.blue
            case "Account":
                return Color.gray
            case "Map":
                return Color.green
            case "Advice":
                return Color.purple
            case "Voice Box":
                return Color.yellow
            case "Countdown":
                return Color.pink
            case "Quick Dial", "Alarm":
                return Color.red
            case "Notifications":
                return Color.black
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


// might need to find pixel width / height of screeen
// use to scale buttons and icons .frame(height: VARIABLE)
