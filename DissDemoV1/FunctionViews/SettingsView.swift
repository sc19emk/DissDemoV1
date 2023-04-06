import SwiftUI
import Firebase

// Settings Page Code
struct SettingsView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme // changes when in dark mode
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                let currentUser = dataManager.account
                let username = currentUser.username
                let number = currentUser.number
                let email = currentUser.email
                let emergencyNumber = currentUser.emergencyNumber
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
                    userInfoText(title: "Username", value: username)
                    userInfoText(title: "Email", value: email)
                    userInfoText(title: "Contact Number", value: number)
                    userInfoText(title: "Emergency Number", value: emergencyNumber)
                    NavigationLink(destination: UpdateDetailsView()) {
                        Text("Update Details")
                            .bold()
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
                    }.padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(colorScheme == .dark ? Color(.systemGray6) :  Color.gray.opacity(0.08) )
                        .cornerRadius(10)

                    signOutAndDeleteButtons()
                }
                .padding()

                Spacer()
            }
            .navigationBarTitle("Account", displayMode: .inline)
            .navigationBarHidden(true)
        }
    }
    
    func userInfoText(title: String, value: String) -> some View {
        HStack {
            Text(title + ":")
                .bold()
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
            Text(value)
                .foregroundColor(.purple)
        }
    }

    func signOutAndDeleteButtons() -> some View {
        VStack(spacing: 30) {
            Button(action: dataManager.signOut) {
                Text("Sign Out")
                    .bold()
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
            }.padding(.vertical)
                .frame(maxWidth: .infinity)
                .background(colorScheme == .dark ? Color(.systemGray6) :  Color.gray.opacity(0.08) )
                .cornerRadius(10)

            Button(action: {
                dataManager.deleteAccount()
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Delete Account")
                    .bold()
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
            }.padding(.vertical)
                .frame(maxWidth: .infinity)
                .background(Color.purple.opacity(0.1) )
                .cornerRadius(10)
        }
    }
}

struct UpdateDetailsView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.colorScheme) var colorScheme // changes when in dark mode
    @State private var newNumber: String = ""
    @State private var newEmergencyNumber: String = ""
    
    var body: some View {
        VStack(spacing: 11) {
            VStack {
                Spacer()
                TextField("Update your number", text: $newNumber)
                    .padding()
                    .italic()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
                
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
                TextField("Update emergency number", text: $newEmergencyNumber)
                    .padding()
                    .italic()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
                
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
