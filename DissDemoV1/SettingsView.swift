//
//  SettingsView.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 03/02/2023.
//

import SwiftUI


// Settings Page Code
struct SettingsView: View {
    var body: some View {
        ZStack{
            Color.gray.ignoresSafeArea()
            VStack{
                Text("Settings Page").font(.title).bold()
                Text("Allow user to update account settings, etc")
            }
        }
        
    }
}

// used for creating the canvas

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}



