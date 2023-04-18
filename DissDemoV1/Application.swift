//
//  DissDemoV1App.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 01/02/2023.
//

import SwiftUI // for user interface elements
import Firebase // for database access
import UserNotifications // to alert users when they get a message


@main
struct Application: App {
    @StateObject var dataManager = DataManager()
    init() {
        FirebaseApp.configure() // configuring firebase database access
    }
    
    var body: some Scene {
        WindowGroup {
            // check if a user is currently logged in
            if dataManager.userIsLoggedIn {
                HomeView().environmentObject(DataManager()) // if so - home pagee
            }
            else {
                SignInView().environmentObject(DataManager()) // otherwise - log in page
            }
        }
    }

}
