//
//  ContentView.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 01/02/2023.
//

import SwiftUI
import UIKit

// User Interface Code
struct ContentView: View {
    var username = "Emily"
    @State var userSelect = ""
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Image("wolfimage")
                Spacer()
                Text("Welcome "+username)
                Spacer()
                HStack() {
                    Spacer()
                    Button(
                        action: {
                            print("Home")
                            userSelect = "house.fill"
                        },
                        label: {
                            Image(systemName: "house.fill")
                        }).buttonStyle(.borderedProminent).controlSize(.large)
                    Spacer()
                    Button(
                        action: {
                            print("Settings")
                            userSelect = "gearshape.fill"
                        },
                        label: {
                                Image(systemName: "gearshape.fill")
                        }).buttonStyle(.borderedProminent).controlSize(.large)
                    Spacer()
                }
                Spacer()
                HStack() {
                    Spacer()
                    Button(
                        action: {
                            print("Friends")
                            userSelect = "figure.2.arms.open"
                        },
                        label: {
                            Image(systemName: "figure.2.arms.open")
                        }).buttonStyle(.borderedProminent).controlSize(.large)
                    Spacer()
                    Button(
                        action: {
                            print("Maps")
                            userSelect = "map.fill"
                        },
                        label: {
                            Image(systemName: "map.fill")
                        }).buttonStyle(.borderedProminent).controlSize(.large)
                    Spacer()
                }
                Spacer()
                Image(systemName:userSelect)
            }
        }
    }
}
    

// used for creating the canvas

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        // create several content views to make several screens with different devices etc
        ContentView()
    }
}
