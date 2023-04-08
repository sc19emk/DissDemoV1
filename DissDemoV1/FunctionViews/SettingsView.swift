import SwiftUI
import Firebase

// Settings Page Code
struct SettingsView: View {
    @EnvironmentObject var dataManager: DataManager // for accessing user info
    @Environment(\.presentationMode) var presentationMode // retrieves current presentation mode
    @Environment(\.colorScheme) var colorScheme // changes when in dark mode
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                let currentUser = dataManager.account // defining the current user
                let username = currentUser.username // getting their details
                let number = currentUser.number
                let email = currentUser.email
                let emergencyNumber = currentUser.emergencyNumber
                // page's title
                HStack {
                    Image(systemName: "person.text.rectangle")
                        .font(.system(size: 30))
                        .foregroundColor(Color.purple)
                    Text("Account")
                        .font(.system(size: 30, design: .monospaced))
                        .bold()
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
                }
                Spacer()
                VStack(spacing: 30) {
                    // displaying user details
                    userInfoText(title: "Username", value: username)
                    userInfoText(title: "Email", value: email)
                    userInfoText(title: "Contact Number", value: number)
                    userInfoText(title: "Emergency Number", value: emergencyNumber)
                    // link to change details
                    NavigationLink(destination: UpdateDetailsView()) {
                        Text("Update Details")
                            .bold()
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
                    }.padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(colorScheme == .dark ? Color(.systemGray6) :  Color.gray.opacity(0.08) )
                        .cornerRadius(10)
                    // access to sign out and delete buttons
                    signOutAndDeleteButtons()
                }
                .padding()

                Spacer()
            }
            .navigationBarTitle("Account", displayMode: .inline)
            .navigationBarHidden(true)
        }
    }
    // displaying the user info text fields
    func userInfoText(title: String, value: String) -> some View {
        HStack {
            Text(title + ":")
                .bold()
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
            Text(value)
                .foregroundColor(.purple)
        }
    }
    // functionality for signing out and deleting accounts
    func signOutAndDeleteButtons() -> some View {
        VStack(spacing: 30) {
            // logs the current user out and returns them to the sign in page
            Button(action: dataManager.signOut) {
                Text("Sign Out")
                    .bold()
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
            }.padding(.vertical)
                .frame(maxWidth: .infinity)
                .background(colorScheme == .dark ? Color(.systemGray6) :  Color.gray.opacity(0.08) )
                .cornerRadius(10)

            Button(action: {
                dataManager.deleteAccount() // removes all account and accosiated information from the database
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Delete Account")
                    .bold()
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
            }.padding(.vertical)
                .frame(maxWidth: .infinity)
                .background(colorScheme == .dark ? Color.red.opacity(0.6) :  Color.red.opacity(0.5) ) // red delete button to show destructuve action
                .cornerRadius(10)
        }
    }
}
// new page to update accoutn details
struct UpdateDetailsView: View {
    @EnvironmentObject var dataManager: DataManager // accessing database
    @Environment(\.colorScheme) var colorScheme // changes when in dark mode
    @State private var newNumber: String = "" // for changing number
    @State private var newEmergencyNumber: String = "" // for changing emergency contact
    
    var body: some View {
        VStack(spacing: 11) {
            VStack {
                Spacer()
                // text field for updating the user's own phone number
                TextField("Update your number", text: $newNumber)
                    .padding()
                    .italic()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
                // button for updating the user's own phone number
                Button(action: updateNumber) {
                    Text("Update your Contact Number")
                        .bold()
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
                }.padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .background(colorScheme == .dark ? Color(.systemGray6) :  Color.gray.opacity(0.08) )
                    .cornerRadius(10)
            }
            VStack {
                Spacer()
                // text field for updating the user's emergency phone number
                TextField("Update emergency number", text: $newEmergencyNumber)
                    .padding()
                    .italic()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
                // button for updating the user's emergency phone number
                Button(action: updateEmergencyNumber) {
                    Text("Update Emergency Number")
                        .bold()
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
                }.padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .background(colorScheme == .dark ? Color(.systemGray6) :  Color.gray.opacity(0.08) )
                    .cornerRadius(10)
                Spacer()
            }
        }
        .padding()
        .navigationBarTitle("Update Details", displayMode: .inline)
    }
    // function to replace the user's phone number in the database
    func updateNumber() {
        guard !newNumber.isEmpty else { return }
        // accessing user details
        let userId = dataManager.account.id
        print("user id is \(userId)")
        let db = Firestore.firestore() // setting up the database
        let ref = db.collection("users").document(userId) // finding the user's record in the database
        // updating the number field
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
    // function to replace the user's emergency number in the database
    func updateEmergencyNumber() {
        guard !newEmergencyNumber.isEmpty else { return } // protecting against empty emergency number field
        let userId = dataManager.account.id
        print("user id is \(userId)")
        let db = Firestore.firestore() // setting up the database
        let ref = db.collection("users").document(userId) // finding the user's record in the database
        // replacing the field in the databse
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
