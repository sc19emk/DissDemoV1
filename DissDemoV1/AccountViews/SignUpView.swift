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

// ADD TERMS AND CONDITIONS
// add user alert when sign up fails
// duplicate text when compiled on iphone, reenter password and password 2

import SwiftUI
import Firebase

struct SignUpView: View {
    @State private var username = ""
    @State private var email = ""
    @State private var phoneNumber = "" // convert to Int later
    @State private var password = ""
    @State private var password2 = ""
    @EnvironmentObject var dataManager: DataManager
    
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
                TextField("Username", text: $username)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: username.isEmpty) {
                        Text("Username")
                            .foregroundColor(.white)
                            .bold()
                            .italic()
                    }.padding(.top)
                Rectangle()
                    .frame(width:350,height: 1)
                    .foregroundColor(.white)
                
                TextField("Email", text: $email)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: email.isEmpty) {
                        Text("Email")
                            .foregroundColor(.white)
                            .bold()
                            .italic()
                    }.padding(.top)
                Rectangle()
                    .frame(width:350,height: 1)
                    .foregroundColor(.white)
                
                TextField("Phone Number", text: $phoneNumber)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: phoneNumber.isEmpty) {
                        Text("Phone Number")
                            .foregroundColor(.white)
                            .bold()
                            .italic()
                    }.padding(.top)
                Rectangle()
                    .frame(width:350,height: 1)
                    .foregroundColor(.white)
            }
            Group {
                SecureField("Password", text:$password)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: password.isEmpty) {
                        Text("Password")
                            .foregroundColor(.white)
                            .bold()
                            .italic()
                    }.padding(.top)
                Rectangle()
                    .frame(width:350,height: 1)
                    .foregroundColor(.white)
                
                SecureField("Password2", text:$password2)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: password.isEmpty) {
                        Text("Re-enter Password")
                            .foregroundColor(.white)
                            .bold()
                            .italic()
                    }.padding(.top)
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
                Color.black
                RoundedRectangle(cornerRadius: 0, style: .continuous)
                    .foregroundStyle(.linearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 650, height: 400)
                    .rotationEffect(.degrees(-20))
                    .offset(x:-100,y: -350)
                
                VStack(spacing: 20) {
                    Spacer()
                    Spacer()
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .font(.system(size:50, weight: .bold, design: .rounded))
                    Spacer()
                    signUpForm
                    Spacer()
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
        if error != nil {
            // need to alert user why there is an error...
            print(error!)
        }
        else {
            Auth.auth().createUser(withEmail:email, password: password) { result, error2 in
                // if there is an error creating the user account
                if error2 != nil {
                    print(error2!.localizedDescription)
                }
                else {
                    let db = Firestore.firestore()
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
            return "Passwords do not match"
        }
        // is password secure enough
//        if isPasswordValid(password) == false {
//            return "Password must be 8 characters, contains a number and a special character"
//        }
        return nil
    }
//    func isPasswordValid(_ password: String) -> Bool {
//        let passwordTest = NSPredicate(format: "SELF MATCHES %@","^(?=.*[a-z])(?=.*[$@$#!%*?&]) [A-Za-z\\d$@$#!%*?&]{8,}")
//        return passwordTest.evaluate (with: password)
//    }
}
    

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView().environmentObject(DataManager())
    }
}
