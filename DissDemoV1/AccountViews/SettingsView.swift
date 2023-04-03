//
//  SettingsView.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 03/02/2023.
// update to allow users to change details, and set emergency contact number

import SwiftUI
import Firebase


// Settings Page Code
struct SettingsView: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        NavigationView {
            VStack {
                let currentUser = dataManager.account
                let username = currentUser.username
                let number = currentUser.number
                let email = currentUser.email
                Text("Username: \(username) ")
                Text("Email: \(email) ")
                Text("Contact Number: \(number) ")
                Button {
                    dataManager.signOut()
                } label: {
                    Text("Sign Out")
                }

            }
        }//.navigationBarBackButtonHidden(true)
    }
}

// used for creating the canvas

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(DataManager())
    }
}



