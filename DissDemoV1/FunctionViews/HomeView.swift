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
    @EnvironmentObject var dataManager: DataManager // to access database information
    @Environment(\.colorScheme) var colorScheme // changes when in dark mode
    @State private var unopenedNotificationsCount: Int = 0 // for the notification page
    @State private var showHelpPopup = false // for the information page
    // each page's name and icon
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
                    // the app's name displayed at the top
                    Text("Safely")
                        .font(.system(size: 30, design: .monospaced))
                        .bold()
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
                }
                Spacer()
                // contains each of the links to each page
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
            .navigationBarTitle("Home", displayMode: .inline) // for navigation back to the home page
            .navigationBarHidden(true)
            .overlay(
                QuestionMarkButton(showHelpPopup: $showHelpPopup) // information on how to use the app
                    .padding([.top, .trailing]),
                alignment: .topTrailing
            )
            .alert(isPresented: $showHelpPopup) {
                Alert(title: Text("Help"),
                      message: Text("Here's how to use the app:\n1. Account Page - Used to find, edit, and delete your user account details.\n2. Friend Page - Allows you to add other users of the app \n3. Notifications - A list of sent and recieved messages and alerts between you and your friends \n4. Advice - Articles with advice on keeping yourself safe \n5. Map - Enables location sharing between you and your friends \n6. Voice Box - Pre-recorded audio conversations and transcripts so you can pretend to be calling a loved one \n7. Countdown - Enable a countdown timer that you will disable if you reach your destination safely. Otherwise the alarm will go off and alert your friends. \n8. Alarm - A loud piercing alarm to attract attention \n9. Quick Dial - Pre-dial the police or your set emergency contact"),
                      dismissButton: .default(Text("Got it!")))
            }
        }.accentColor(colorScheme == .dark ? Color.white : Color.black) // the navigation button colour scheme
    }
    // defining the button / link structure to each feature
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
                // shows notification count on the notification button
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
        // quick dial dials immediatly - does not have its own page
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
            // other buttons take the user to a new view
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
    // used to return the selected view
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
    // defines the unique colour for each page
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
    // function to find how many unopened notifications the current user has
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
// the question mark button overlay for the information page
struct QuestionMarkButton: View {
    @Binding var showHelpPopup: Bool
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        Button(action: {
            showHelpPopup.toggle()
        }) {
            Image(systemName: "questionmark.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
        }
    }
}

final class NavigationStack: ObservableObject {
    @Published var viewStack: [AnyView] = []
    
    func push<Content: View>(_ view: Content) {
        withAnimation {
            viewStack.append(AnyView(view))
        }
    }
    
    func pop() {
        withAnimation {
            if !viewStack.isEmpty {
                viewStack.removeLast()
            }
        }
    }
}

struct NavigationStackView<Content: View>: View {
    @EnvironmentObject private var navigationStack: NavigationStack
    private let content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            if !navigationStack.viewStack.isEmpty {
                navigationStack.viewStack.last
            } else {
                content
                    .transition(.move(edge: .trailing))
            }
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
