//
//  Page.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 03/02/2023.
//

import SwiftUI
import MapKit // for map view

// Friend Page Code
struct FriendPage: View {
    var body: some View {
        ZStack{
            Color.pink.ignoresSafeArea()
            Text("Friend Page")
            
        }
        
    }
}

// Map Page Code
struct MapPage: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

    var body: some View {
        ZStack{
            Color.green.ignoresSafeArea()
            VStack{
                Text("Map Page")
                Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.follow))
                    .frame(width: 400, height: 300)
            }
        }
    }
}


// SOS Page Code
struct SOSPage: View {
    var body: some View {
        ZStack{
            Color.red.ignoresSafeArea()
            VStack{
                Text("SOS Page")
                let numberString = "07984063432"
                
                Button(action: {
                    let telephone = "tel://"
                    let formattedString = telephone + numberString
                    guard let url = URL(string: formattedString) else { return }
                    UIApplication.shared.open(url)
                    }) {
                    Text(numberString)
                }
            }
        }
        
    }
}

// Settings Page Code
struct SettingsPage: View {
    var body: some View {
        ZStack{
            Color.gray.ignoresSafeArea()
            Text("Settings Page")
        }
        
    }
}

// used for creating the canvas

struct AllPage_Previews: PreviewProvider {
    static var previews: some View {
        FriendPage()
        MapPage()
        SOSPage()
        SettingsPage()
    }
}



