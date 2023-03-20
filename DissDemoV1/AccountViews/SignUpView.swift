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
    @State private var username = ""
    @State private var email = ""
    @State private var age = "" // convert to Int later
    @State private var phoneNumber = "" // convert to Int later
    @State private var password = ""
    @State private var password2 = ""
    @State private var userIsLoggedIn =  false
    
    var body: some View {
        if userIsLoggedIn {
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
                
                TextField("Age", text: $age)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: age.isEmpty) {
                        Text("Age")
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
                        LogInView()
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
                            userIsLoggedIn = true
                        }
                    }
                }
            }.ignoresSafeArea()
        }
    }
    // adds email and password into auth - need to send other details into other table
    func signUp() {
        Auth.auth().createUser(withEmail:email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
