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
    @Environment(\.colorScheme) var colorScheme // changes when in dark mode
    @StateObject var map = MapModel()
    @EnvironmentObject var dataManager: DataManager // for location data management
    @State private var showingFriendsList = false // when the user shares - friends list is shown
    @State private var selectedFriends: Set<String> = [] // all the chosen friends
    @State private var coordinates: (lat: Double, long: Double) = (0, 0) // coordinate format

    var body: some View {
        ZStack {
            // setting up the map background
            Map(coordinateRegion: $map.area, showsUserLocation: true)
                .ignoresSafeArea()
                .onAppear() {
                    map.isPhoneLocationEnabled()
                }
                .accentColor(Color(.systemGreen))
            
            VStack {
                Spacer()
                // share user location button
                Button {
                    shareLocation()
                } label: {
                    Text("Share Location")
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
                        .bold()
                }.bold()
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
                    .padding()
                    .background(colorScheme == .dark ? Color.green.opacity(0.8) :  Color.green.opacity(0.8) )
                    .cornerRadius(10)
            }
        }.sheet(isPresented: $showingFriendsList) {
            FriendsSelectionView(selectedFriends: $selectedFriends) // friends selected to share location with
                .environmentObject(dataManager)
        }
    }
    // function that retrieves current co-ordinates
    func shareLocation() {
        coordinates.lat = map.manager!.location!.coordinate.latitude // get coordinates from map manager
        dataManager.lat = coordinates.lat.rounded(toPlaces: 4) // round them and submit to the data manager
        coordinates.long = map.manager!.location!.coordinate.longitude
        dataManager.long = coordinates.long.rounded(toPlaces: 4)
        showingFriendsList = true // now show friends list to select friends
    }
}

// gives access to NSObject, CLLocation methods
class MapModel: NSObject, ObservableObject, CLLocationManagerDelegate {
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
// list of the current users friends
struct FriendsSelectionView: View {
    @EnvironmentObject var dataManager: DataManager
    @Binding var selectedFriends: Set<String> // list containing the chosen friends
    @Environment(\.presentationMode) var presentationMode // allows to get selection infromation

    var body: some View {
        NavigationView {
            // for each friend
            List(dataManager.friends, id: \.id) { friend in
                HStack {
                    Text(friend.username) // display their username
                    Spacer()
                    // check if you would like to share location with
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
                        sendNotifications() // send the friend a notification
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    // sends the location in the form of a notification
    func sendNotifications() {
        let db = Firestore.firestore() // access the database
        let uidFrom = dataManager.account.id // from current user
        let contents = "lat: \(dataManager.lat), long: \(dataManager.long)" // set coordinates
        let timestamp = Timestamp(date: Date()) // at current time
        // create notification to send to each of the selected friends
        for uidTo in selectedFriends {
            let notificationData: [String: Any] = [
                "uidFrom": uidFrom,
                "uidTo": uidTo,
                "type": 2,
                "opened": false,
                "contents": contents,
                "timestamp": timestamp
            ]
            // create new record in the notification database
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
// check box srtucture to select each friend
struct Checkbox: View {
    @State private var isChecked: Bool
    let onToggle: (Bool) -> Void
    // is the box checked
    init(isChecked: Bool, onToggle: @escaping (Bool) -> Void) {
        _isChecked = State(initialValue: isChecked)
        self.onToggle = onToggle
    }
    // on checked - change appearence
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
