//  SwiftUIView.swift
//  Let'sCook
//  Created by Raisa Methila on 10/10/23.

import SwiftUI
import Firebase

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var loginStatus: LoginStatus = .notLogged
    @State private var errorMessage: String? = nil
    @State private var navigate = false
    
    // Enum to represent the login status.
    enum LoginStatus {
        case notLogged
        case loggedIn
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Welcome text
                Text("Welcome To Let'sCook!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.purple)
                
                // Email input box
                TextField("Email or Username", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.all)
                
                // Password input box
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                // "Log In" button
                Button(action: {
                    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                        if error != nil {
                            navigate = false // Deactivate navigation
                            errorMessage = "Incorrect email or password"
                        } else {
                            navigate = true // Activate navigation to HomePage
                            errorMessage = nil
                        }
                    }
                }) {
                    Text("Log In")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .navigationDestination(isPresented: $navigate) {
                    HomePage()
                }
                
                // Display the error message if it is not nil.
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
                
                // Display a message and a button for creating an account.
                HStack {
                    Text("Don't have an account?")
                    NavigationLink(destination: CreateAccount()) {
                        Text("Create Account")
                    }
                }
            }
            .padding()
        }
    }
}
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

