import SwiftUI
import Firebase
import MapKit // for location share notifications


struct NotificationView: View {
    @EnvironmentObject var dataManager: DataManager // to access database
    @Environment(\.colorScheme) var colorScheme // changes when in dark mode
    @State private var selectedTab = 0 // recieved or sent notifications
    @State private var notifications: [NotificationItem] = [] // holds notifaction list

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "ellipsis.message")
                    .font(.system(size: 30))
                    .foregroundColor(Color.blue)
                Text("Notifications")
                    .font(.system(size: 30, design: .monospaced))
                    .bold()
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            }
            // allows the user to move between tabs
            Picker(selection: $selectedTab, label: Text("Tabs")) {
                Text("Received").tag(0)
                Text("Sent").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())

            List {                            
                // for each notification in the database, if it is sent/received by the current user , add to the relevant tab
                ForEach(notifications.sorted(by: { $0.timestamp.compare($1.timestamp) == .orderedDescending })) { notification in                    if selectedTab == 0 && notification.uidTo == dataManager.account.id {
                        NavigationLink(destination: DetailedNotificationView(notification: notification)) {
                            NotificationRow(notification: notification)
                        }
                    } else if selectedTab == 1 && notification.uidFrom == dataManager.account.id {
                        NavigationLink(destination: DetailedNotificationView(notification: notification)) {
                            NotificationRow(notification: notification)
                        }
                    }
                }
            }
            .onAppear(perform: fetchNotifications) // loads notifications when this page is opened
        }
    }

    func fetchNotifications() {
        let ref = Firestore.firestore().collection("notifications") // access notifcation table
        ref.addSnapshotListener { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription) // error if db access didnt work
                return
            }
            if let snapshot = snapshot {
                notifications = snapshot.documents.compactMap { document -> NotificationItem? in
                    let data = document.data() // map each piece of information in the notificaiton here
                    let id = document.documentID
                    let uidFrom = data["uidFrom"] as? String ?? ""
                    let uidTo = data["uidTo"] as? String ?? ""
                    let type = data["type"] as? Int ?? 0
                    let opened = data["opened"] as? Bool ?? false
                    let contents = data["contents"] as? String ?? ""
                    let timestamp = data["timestamp"] as? Timestamp ?? Timestamp()

                    return NotificationItem(id: id, uidFrom: uidFrom, uidTo: uidTo, type: type, opened: opened, contents: contents, timestamp: timestamp)
                }
                // Update the app icon badge number - currently not working
                let unopenedCount = notifications.filter { !$0.opened && $0.uidTo == dataManager.account.id }.count
                UIApplication.shared.applicationIconBadgeNumber = unopenedCount
            }
        }
    }
    
    // formatting the date and time timestamp
    func formatDate(_ timestamp: Timestamp) -> String {
        let date = timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}

// formatting the summary view of the notitication
struct NotificationRow: View {
    var notification: NotificationItem
    @EnvironmentObject var dataManager: DataManager

    func formatDate(_ timestamp: Timestamp) -> String {
        let date = timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(getNotificationTitle(_:notification.type)) // title of the notitication
                Text(formatDate(notification.timestamp))
                    .font(.subheadline) // date notification was sent
                    .foregroundColor(.gray)
            }
            Spacer()
            if !notification.opened {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 10, height: 10)
            }
        }
    }
    func getNotificationTitle(_ type: Int) -> String {
        switch type {
        case 1:
            return "SOS Alert"
        case 2:
            return "Location Share"
        case 3:
            return "Countdown Alert"
        case 4:
            return "New Friend"
        default:
            return ""
        }
    }
}

struct DetailedNotificationView: View {
    var notification: NotificationItem
    @EnvironmentObject var dataManager: DataManager

    @State private var mapView: MapView? = nil
    @State private var otherUser: String = "" // Add this state variable to store the username

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(getNotificationTitle(notification.type))
                .font(.title)
                .foregroundColor(notification.type == 1 ? .red : .primary)
            
            Text(otherUser) // Replace `getOtherUser()` with `otherUser`
                .italic()
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text(formatDate(notification.timestamp))
                .font(.footnote)
                .foregroundColor(.gray)

            if notification.type == 2 {
                if let coordinates = getCoordinates(notification.contents) {
                    NotificationMapView(coordinates: coordinates)
                        .frame(height: 300)
                }
            } else {
                Text(notification.contents)
            }
        }.onAppear {
            setNotificationOpened(notification)
        }
        .padding()
        .navigationBarTitle("Notification Details", displayMode: .inline)
        .onAppear(perform: fetchOtherUser) // Add this line to fetch the other user when the view appears
    }

    func getNotificationTitle(_ type: Int) -> String {
        switch type {
        case 1:
            return "SOS Alert"
        case 2:
            return "Location Share"
        case 3:
            return "Countdown Alert"
        case 4:
            return "New Friend"
        default:
            return ""
        }
    }

    func fetchOtherUser() {
        let otherUserID = notification.uidTo == dataManager.account.id ? notification.uidFrom : notification.uidTo
        dataManager.fetchFriendUsername(friendID: otherUserID) { username in
            if let username = username {
                if notification.uidTo == dataManager.account.id {
                    otherUser = "From: \(username)"
                } else {
                    otherUser = "To: \(username)"
                }
            } else {
                otherUser = "Unknown user"
            }
        }
    }

    func formatDate(_ timestamp: Timestamp) -> String {
        let date = timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }

    func getCoordinates(_ contents: String) -> CLLocationCoordinate2D? {
        let components = contents.components(separatedBy: ",")
        if components.count == 2 {
            let latString = components[0].trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "lat:", with: "").trimmingCharacters(in: .whitespaces)
            let longString = components[1].trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "long:", with: "").trimmingCharacters(in: .whitespaces)

            if let lat = Double(latString), let long = Double(longString) {
                return CLLocationCoordinate2D(latitude: lat, longitude: long)
            }
        }
        return nil
    }
    func setNotificationOpened(_ notification: NotificationItem) {
        if !notification.opened {
            let ref = Firestore.firestore().collection("notifications") // for user's unopened notifications
            ref.document(notification.id).updateData(["opened": true])
        }
    }
    
}

struct NotificationItem: Identifiable {
    var id: String
    var uidFrom: String
    var uidTo: String
    var type: Int
    var opened: Bool
    var contents: String
    var timestamp: Timestamp
}
struct NotificationMapView: UIViewRepresentable {
    var coordinates: CLLocationCoordinate2D
    var span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.mapType = .standard // add this line to show street and building details
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        let region = MKCoordinateRegion(center: coordinates, span: span)
        uiView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        uiView.addAnnotation(annotation)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: NotificationMapView

        init(_ parent: NotificationMapView) {
            self.parent = parent
        }
    }
}


struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView().environmentObject(DataManager())
    }
}

struct DetailedNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedNotificationView(notification: NotificationItem(id: "1", uidFrom: "user1", uidTo: "user2", type: 1, opened: false, contents: "Sample notification", timestamp: Timestamp()))
    }
}
