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
    @State private var email = ""
    @State private var password = ""
    @State private var userIsLoggedIn =  false
    
    var body: some View {
        if userIsLoggedIn {
            HomeView()
        }
        else {
            logInContent
        }
    }
    
    var logInContent: some View {
        
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
                    Text("Welcome")
                        .foregroundColor(.white)
                        .font(.system(size:50, weight: .bold, design: .rounded))
                    Spacer()
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
                        
                        SecureField("Password", text:$password)
                            .foregroundColor(.white)
                            .textFieldStyle(.plain)
                            .placeholder(when: password.isEmpty) {
                                Text("Password")
                                    .foregroundColor(.white)
                                    .bold()
                                    .italic()
                            }
                        
                        Rectangle()
                            .frame(width:350,height: 1)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    Button {
                        logIn()
                    } label: {
                        Text("Log In")
                            .bold()
                            .frame(width:200, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.linearGradient(colors: [.purple,.blue], startPoint: .topLeading, endPoint: .bottom)))
                            .foregroundColor(.white)
                    }.padding(.top)
                    
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

    func logIn() {
        Auth.auth().signIn(withEmail:email, password:password) { result, error in
            if error != nil {
                print(error!.localizedDescription) // creates new user
            }
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}


// from <website>
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
