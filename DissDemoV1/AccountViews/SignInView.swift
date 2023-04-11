//
//  LogInView.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 17/03/2023.
//

import SwiftUI
import Firebase

//need to stop "back" from stacking

struct SignInView: View {
    @State private var email = "" // email entered by the user
    @State private var password = "" // password entered by the user
    @EnvironmentObject var dataManager: DataManager // checking details in the databse
    @State private var showAlert = false // used to display error loggin in warnings to user
    @State private var alertMessage = "" // content in the alert message
    
    var body: some View {
        // is the user logged in yet
        if dataManager.userIsLoggedIn {
            HomeView() // take them to home screen
        }
        else {
            logInContent // if not show log in content
        }
    }
    
    var logInContent: some View {
        NavigationView {
            ZStack {
                // for homepage styling
                Color.black
                RoundedRectangle(cornerRadius: 0, style: .continuous)
                    .foregroundStyle(.linearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 650, height: 400)
                    .rotationEffect(.degrees(-20))
                    .offset(x:-100,y: -350)
                
                VStack(spacing: 20) {
                    Group {
                        Spacer()
                        // title
                        Text("Safely")
                            .foregroundColor(.white)
                            .font(.system(size:50, weight: .bold, design: .monospaced))
                        Spacer()
                        // email entry
                        TextField("", text: $email)
                            .foregroundColor(.white)
                            .textFieldStyle(.plain)
                            .padding(.top)
                            .placeholder(when: email.isEmpty, alignment: .leading) {
                                Text("Email").foregroundColor(.white).italic()
                            }
                        // underline
                        Rectangle()
                            .frame(width:350,height: 1)
                            .foregroundColor(.white)
                        // password entry
                        SecureField("", text:$password)
                            .foregroundColor(.white)
                            .textFieldStyle(.plain)
                            .placeholder(when: password.isEmpty, alignment: .leading) {
                                Text("Password").foregroundColor(.white).italic()
                            }
                        // underline
                        Rectangle()
                            .frame(width:350,height: 1)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    Button {
                        logIn()
                    } label: {
                        // log in button
                        Text("Log In")
                            .bold()
                            .frame(width:200, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.linearGradient(colors: [.purple,.blue], startPoint: .topLeading, endPoint: .bottom)))
                            .foregroundColor(.white)
                    }.padding(.top)
                    
                    // if a new user - move to sign up page
                    NavigationLink {
                        SignUpView()
                    } label: {
                        Text("New? Click here to Sign Up ")
                            .bold()
                            .font(.system(size:18, weight: .bold, design: .rounded))
                            .frame(width:300, height: 40)
                            .foregroundColor(.white)
                    }.padding(.top)
                    Spacer()
                    
                }
                    .frame(width: 350)
                    .alert(isPresented: $showAlert) {
                                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                            }
                    .onAppear() {
                        // register the logged in user with firebase
                        Auth.auth().addStateDidChangeListener { auth, user in
                        }
                    }
            }.ignoresSafeArea()
        }.navigationBarBackButtonHidden(true)
    }
    // check user credentials in fire Auth database
    func logIn() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error.localizedDescription)
                self.alertMessage = error.localizedDescription
                self.showAlert = true
            } else {
                // Update userIsLoggedIn state
                dataManager.userIsLoggedIn = true
            }
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool, // if the placeholder should be shown
        alignment: Alignment = .leading, // alignment
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0) // opacity used to show / hide the text
            self
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView().environmentObject(DataManager())
    }
}
