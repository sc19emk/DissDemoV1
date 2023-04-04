//
//  MapView.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 05/02/2023.
//

import SwiftUI
import MapKit // for map view
import FirebaseFirestore

enum defaultValues {
    static let defaultLocation = CLLocationCoordinate2D(latitude: 53.8078, longitude: -1.5550) // setting default location to University of Leeds
    static let defaultZoom = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005) // setting default zoom level to street/building level
}

struct MapView: View {
    @StateObject var map = MapModel()
    @EnvironmentObject var dataManager: DataManager
    @State private var sharing = false
    @State private var showingFriendsList = false
    @State private var selectedFriends: Set<String> = []
    @State private var coordinates: (lat: Double, long: Double) = (0, 0)

    var body: some View {
        ZStack {
            Map(coordinateRegion: $map.area, showsUserLocation: true)
                .ignoresSafeArea()
                .onAppear() {
                    map.isPhoneLocationEnabled()
                }
                .accentColor(Color(.systemGreen))

            VStack {
                Spacer()
                Button {
                    shareLocation()
                } label: {
                    Text("Share Location")
                }.frame(width: 150, height: 50)
                    .background(.linearGradient(colors: [.green, .yellow], startPoint: .top, endPoint: .bottomTrailing))
                    .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 4))
                    .padding()
                    .accentColor(.black)
                    .fontWeight(.bold)

                if sharing {
                    Text("Lat: \(coordinates.lat)")
                    Text("Long: \(coordinates.long)")
                }
            }
        }.sheet(isPresented: $showingFriendsList) {
            FriendsSelectionView(selectedFriends: $selectedFriends)
                .environmentObject(dataManager)
        }
    }

    func shareLocation() {
        sharing = true
        coordinates.lat = map.manager!.location!.coordinate.latitude
        dataManager.lat = coordinates.lat.rounded(toPlaces: 4)
        coordinates.long = map.manager!.location!.coordinate.longitude
        dataManager.long = coordinates.long.rounded(toPlaces: 4)
        print("Updating location...")
        showingFriendsList = true
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
}

struct FriendsSelectionView: View {
    @EnvironmentObject var dataManager: DataManager
    @Binding var selectedFriends: Set<String>
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            List(dataManager.friends, id: \.id) { friend in
                HStack {
                    Text(friend.username)
                    Spacer()
                    Checkbox(isChecked: selectedFriends.contains(friend.id), onToggle: { isChecked in
                        if isChecked {
                            selectedFriends.insert(friend.id)
                        } else {
                            selectedFriends.remove(friend.id)
                        }
                    })
                }
            }
            .navigationTitle("Select Friends")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        sendNotifications()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }

    func sendNotifications() {
        let db = Firestore.firestore()
        let uidFrom = dataManager.account.id
        let contents = "lat: \(dataManager.lat), long: \(dataManager.long)"
        let timestamp = Timestamp(date: Date())

        for uidTo in selectedFriends {
            let notificationData: [String: Any] = [
                "uidFrom": uidFrom,
                "uidTo": uidTo,
                "type": 2,
                "opened": false,
                "contents": contents,
                "timestamp": timestamp
            ]

            db.collection("notifications").addDocument(data: notificationData) { error in
                if let error = error {
                    print("Error sending notification: \(error)")
                } else {
                    print("Notification sent successfully")
                }
            }
        }
    }
}

struct Checkbox: View {
    @State private var isChecked: Bool
    let onToggle: (Bool) -> Void

    init(isChecked: Bool, onToggle: @escaping (Bool) -> Void) {
        _isChecked = State(initialValue: isChecked)
        self.onToggle = onToggle
    }

    var body: some View {
        Button(action: {
            isChecked.toggle()
            onToggle(isChecked)
        }) {
            Image(systemName: isChecked ? "checkmark.square" : "square")
                .foregroundColor(isChecked ? .blue : .gray)
        }
    }
}

// allows us to round the co-ordinates , as cannot share too precise values
extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

struct MapPage_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
