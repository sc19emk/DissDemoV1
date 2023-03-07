//
//  MapView.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 05/02/2023.
//

import SwiftUI
import MapKit // for map view

enum defaultValues {
    static let defaultLocation = CLLocationCoordinate2D(latitude: 53.8078, longitude: -1.5550)
    static let defaultZoom = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
}

// Map Page Code
struct MapView: View {
    @StateObject private var mapModel = MapViewModel() // creates instance and gives access
    var body: some View {
        
        ZStack {
            
            Map(coordinateRegion: $mapModel.region, showsUserLocation: true)
                .ignoresSafeArea()
                .onAppear() {
                    mapModel.isPhoneLocationEnabled()
                }
            .accentColor(Color(.systemGreen))
            
            VStack {
                Spacer()
                Button {
                    return
                } label: {
                    Text("Share Location")
                }.frame(width: 150, height: 50)
                    .background(.thinMaterial)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke (lineWidth: 2))
                    .padding()
                    .accentColor(.black)
                    .fontWeight(.bold)

            }
        }
    }
}


struct MapPage_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

// gives access to NSObject, CLLocation methods
final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var region = MKCoordinateRegion(center: defaultValues.defaultLocation, span:defaultValues.defaultZoom)

    var locationManager: CLLocationManager? // optional service
    
    func isPhoneLocationEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager() // creates location manager
            locationManager?.delegate = self
        }
        else {
            print("Location not enabled")
        }
    }
    private func isAppLocationEnabled() {
        guard let locationManager = locationManager else {return} // gives access to location manager defined abocve
        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization() // need to ask for permission
            
            case .restricted:
                print("Your location is restricted, change this in your Apple Settings.")
            
            case .denied:
                print("You have denied this app location access. Change this in Apple Settings.")
            
            case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span:defaultValues.defaultZoom)
            
            @unknown default:
                break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        isAppLocationEnabled()
    }
}
