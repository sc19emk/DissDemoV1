//
//  DissDemoV1App.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 01/02/2023.
//

import SwiftUI
import Firebase // for database access

@main
struct Application: App {
    
    @StateObject var dataManager = DataManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            //FriendView().environmentObject(dataManager)
            LogInView().environmentObject(DataManager())
        }
    }
}
