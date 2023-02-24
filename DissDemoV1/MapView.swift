//
//  MapView.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 05/02/2023.
//

import SwiftUI
import MapKit // for map view


// Map Page Code
struct MapView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

    var body: some View {
        ZStack{
            Color.green.ignoresSafeArea()
            VStack{
                Text("Map Page").font(.title).bold()
                Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.follow))
                    .frame(width: 400, height: 300)
                Text("Filter by home area / current location / search for post code shows streets where SOS have been made near you. Share with police ?? Link to crime data etc ?? POTENTIAL PRIVACY RISK? DISCUSS")
                    .multilineTextAlignment(.center)
            }
        }
    }
    func location() {
        
        
    }
}


struct MapPage_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
