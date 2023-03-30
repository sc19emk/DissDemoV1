//
//  MapView.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 05/02/2023.
//
// SHARING LOCATION (KINDA) WORKS - BUT MAP LOCATION DOES NOT AUTO UPDATE. ALSO CRASHES PREVIEW WHEN CLICK SHARE.

import SwiftUI
import MapKit // for map view

enum defaultValues {
    static let defaultLocation = CLLocationCoordinate2D(latitude: 53.8078, longitude: -1.5550) // setting default location to University of Leeds
    static let defaultZoom = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005) // setting default zoom level to street/building level
}

// Map Page Code
struct MapView: View {
    @StateObject var map = MapModel() // creates instance and gives access
    @State var sharing = false
    @State var coordinates : (lat:Double, long: Double) = (0,0)
    var body: some View {
        ZStack {
            // displays map on user screen with user location + zoom
            Map(coordinateRegion: $map.area, showsUserLocation: true)
                .ignoresSafeArea()
                .onAppear() {
                    map.isPhoneLocationEnabled()
                }
                .accentColor(Color(.systemGreen))
            
            VStack {
                Spacer()
                // demo button for sharing user location
                Button {
                    shareLocation()
                } label: {
                    Text("Share Location")
                }.frame(width: 150, height: 50)
                    .background(.linearGradient(colors: [.green, .yellow], startPoint: .top, endPoint: .bottomTrailing))
                    .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke (lineWidth: 4))
                    .padding()
                    .accentColor(.black)
                    .fontWeight(.bold)
                // show location if sharing is true...
                if sharing == true {
                    Text("Lat: \(coordinates.lat)")
                    Text("Long: \(coordinates.long)")
                }
            }
        }
    }
    func shareLocation() {
        // to share location coordinates with friends
        sharing = true
        coordinates.lat = map.manager!.location!.coordinate.latitude
        coordinates.long = map.manager!.location!.coordinate.longitude
        print("Updating location...")
        
    }
}

// gives access to NSObject, CLLocation methods
class MapModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var share = false
    @Published var area = MKCoordinateRegion(center: defaultValues.defaultLocation, span:defaultValues.defaultZoom)
    var manager: CLLocationManager? // declare as optional service
    
    // check if phone has location services enabled
    func isPhoneLocationEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            manager = CLLocationManager() // creates location manager
            manager?.delegate = self // sets location manager as self
        }
    }
    
    // check if app has location services enabled
    func isAppLocationEnabled() {
        guard let manager = manager else {return} // gives access to location manager defined abocve
        // check auth status, switch case for each scenario
        switch manager.authorizationStatus {
            case .notDetermined:
                manager.requestWhenInUseAuthorization() // unsure if permission granted - need to ask
            
            case .restricted:
                print("Your location is restricted. Change this in your device Settings.") // let user know why they cant access
            
            case .denied:
                print("You have denied this app location access. Change this in device Settings.") // let user know why they cant access
            
            case .authorizedWhenInUse, .authorizedAlways:
                area = MKCoordinateRegion(center: manager.location!.coordinate, span:defaultValues.defaultZoom)
            
            @unknown default:
                return
                //manager?.stopUpdatingLocation()
        }
    }
//    // check to ensure still authorised every time we use the app
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        isAppLocationEnabled()
//    }
}



struct MapPage_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
