import SwiftUI
import Firebase

// Settings Page Code
struct SettingsView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode> // allows us to navigate back to the sign up if user deletes account
    @State private var newNumber: String = ""
    @State private var newEmergencyNumber: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                let currentUser = dataManager.account
                let username = currentUser.username
                let number = currentUser.number
                let email = currentUser.email
                let emergencyNumber = currentUser.emergencyNumber
                Text("Username: \(username) ")
                Text("Email: \(email) ")
                Text("Contact Number: \(number) ")
                Text("Emergency Number: \(emergencyNumber)")
                
                TextField("Update your number", text: $newNumber)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button {
                    updateNumber()
                } label: {
                    Text("Update your Contact Number")
                }

                
                TextField("Update emergency number", text: $newEmergencyNumber)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button {
                    updateEmergencyNumber()
                } label: {
                    Text("Update Emergency Number")
                }

                Button {
                    dataManager.signOut()
                } label: {
                    Text("Sign Out")
                }
                
                Button(action: {
                    dataManager.deleteAccount()
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Delete Account")
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    func updateNumber() {
        guard !newNumber.isEmpty else { return }

        let userId = dataManager.account.id
        print("user id is \(userId)")
        let db = Firestore.firestore() // setting up the database
        let ref = db.collection("users").document(userId)

        ref.updateData([
            "number": newNumber
        ]) { error in
            if let error = error {
                print("Error updating number: \(error)")
            } else {
                print("Account contact number successfully updated")
                dataManager.fetchAccount() // Update the account information
            }
        }
    }

    func updateEmergencyNumber() {
        guard !newEmergencyNumber.isEmpty else { return }

        let userId = dataManager.account.id
        print("user id is \(userId)")
        let db = Firestore.firestore() // setting up the database
        let ref = db.collection("users").document(userId)

        ref.updateData([
            "emergencyNumber": newEmergencyNumber
        ]) { error in
            if let error = error {
                print("Error updating emergency number: \(error)")
            } else {
                print("Emergency number successfully updated")
                dataManager.fetchAccount() // Update the account information
            }
        }
    }
}

// used for creating the canvas
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(DataManager())
    }
}
