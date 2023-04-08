//
//  SignUpView.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 20/03/2023.
//

//
//  SignUpView.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 17/03/2023.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    // State variables to store input and control alerts
    @State private var username = ""
    @State private var email = ""
    @State private var phoneNumber = "" // convert to Int later
    @State private var password = ""
    @State private var password2 = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var agreedToTerms = false
    @State private var showTermsAlert = false
    @EnvironmentObject var dataManager: DataManager
    
    // show home view when the user signs up
    var body: some View {
        if dataManager.userIsLoggedIn {
            HomeView()
        }
        else {
            signUpContent
        }
    }
    // form for users to enter details
    var signUpForm: some View {
        VStack {
            // groups as went over 10 items (max 10 items per object)
            Group {
                // username text field and rectangle to underline
                TextField("Username", text: $username)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .padding(.top)
                    .bold()
                    .italic()
                Rectangle()
                    .frame(width:350,height: 1)
                    .foregroundColor(.white)
                
                // email entry - must be correctly formatted
                TextField("Email", text: $email)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .padding(.top)
                    .bold()
                    .italic()
                Rectangle()
                    .frame(width:350,height: 1)
                    .foregroundColor(.white)
                
                // phone number entry
                TextField("Phone Number", text: $phoneNumber)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .padding(.top)
                    .bold()
                    .italic()
                Rectangle()
                    .frame(width:350,height: 1)
                    .foregroundColor(.white)
            }
            Group {
                // password entry - must be secure and meet criteria below
                SecureField("Password", text:$password)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .padding(.top)
                    .bold()
                    .italic()
                Rectangle()
                    .frame(width:350,height: 1)
                    .foregroundColor(.white)
                
                // check passwords match
                SecureField("Re-enter Password", text:$password2)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .padding(.top)
                    .bold()
                    .italic()
                Rectangle()
                    .frame(width:350,height: 1)
                    .foregroundColor(.white)
                
            }
        }
    }
    
    // page content , including colour scheme and sign up form
    var signUpContent: some View {
        NavigationView {
            ZStack {
                // Background color and decoration
                Color.black
                RoundedRectangle(cornerRadius: 0, style: .continuous)
                    .foregroundStyle(.linearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 650, height: 400)
                    .rotationEffect(.degrees(-20))
                    .offset(x:-100,y: -350)
                
                VStack(spacing: 20) {
                    Group {
                        Spacer()
                        Spacer()
                    }
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .font(.system(size:50, weight: .bold, design: .monospaced))
                    Spacer()
                    signUpForm
                    Spacer()
                    HStack {
                        // Checkbox
                        Button(action: {
                            agreedToTerms.toggle()
                        }) {
                            Image(systemName: agreedToTerms ? "checkmark.square" : "square")
                                .foregroundColor(.white)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // Terms and Conditions link
                        Text("I agree to the")
                            .foregroundColor(.white)
                        
                        Button(action: {
                            alertMessage = "This app will store the provided data, and any location data you chose to share."
                            showAlert = true
                        }) {
                            Text("Terms and Conditions")
                                .foregroundColor(.white)
                                .underline()
                        }
                    }
                    // register button
                    Button {
                        signUp()
                    } label: {
                        Text("Register")
                            .bold()
                            .frame(width:200, height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.linearGradient(colors: [.purple,.blue], startPoint: .topLeading, endPoint: .bottom)))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    // link back to sign in page
                    NavigationLink {
                        SignInView()
                    } label: {
                        Text("Already have an account? \nClick here to log in!")
                            .bold()
                            .font(.system(size:18, weight: .bold, design: .rounded))
                            .frame(width:300, height: 50)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                    
                }.frame(width: 350)
                    .alert(isPresented: $showAlert) {Alert(title: Text(alertMessage.contains("This app will") ? "Terms and Conditions" : "Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))}
                    .onAppear() {
                        Auth.auth().addStateDidChangeListener { auth, user in
                            if user != nil {
                                dataManager.userIsLoggedIn = true
                            }
                        }
                    }
            }.ignoresSafeArea()
        }
    }
    // adds email and password into auth - need to send other details into other table
    func signUp() {
        let error = validate() // check fields
        if let error = error {
            print(error) // print to terminal
            self.alertMessage = error // set alert message to this error
            self.showAlert = true // and show the alert
        }
        else {
            Auth.auth().createUser(withEmail:email, password: password) { result, error2 in
                // if there is an error creating the user account
                if let error2 = error2 {
                    print(error2.localizedDescription)
                    self.alertMessage = error2.localizedDescription
                    self.showAlert = true
                }
                else {
                    let db = Firestore.firestore()
                    dataManager.userIsLoggedIn = true
                    db.collection("users").document(result!.user.uid).setData([
                        "username": username,
                        "number": phoneNumber,
                        "emergencyNumber": "999", // 999 as default - can change in settings
                        "UID": result!.user.uid
                    ]) { error3 in
                        if let error3 = error3 {
                            print("Error adding document: \(error3)")
                        }
                        else {
                            print ("Document added with ID: \(result!.user.uid)")
                        }
                    }
                }
            }
        }
    }

    // returns error message if incorrect
    func validate() -> String? {
        // are fields filled in
        if username == "" || email == "" || phoneNumber == "" || password == "" || password2 == "" {
            return "Please complete all the above fields"
        }
        // do passwords match
        if password != password2 {
            return "The entered passwords do not match"
        }
        // is password secure enough
        if isPasswordValid(password) == false {
            return "Password must be 8 characters, contains a number and a special character"
        }
        
        // Check if the user agreed to terms and conditions
        if !agreedToTerms {
            return "You must agree to our terms and conditions to sign up"
        }
        return nil
    }
    func isPasswordValid(_ password: String) -> Bool {
        // one lowercase letter: (?=.*[a-z]), one digit: (?=.*\\d), one special character: (?=.*[$@$#!%*?&]), minimum length of 8 characters: [A-Za-z\\d$@$#!%*?&]{8,}
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*\\d)(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
}
    

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView().environmentObject(DataManager())
    }
}
