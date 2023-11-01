//
//  CreateAccountView.swift
//  Let'sCook
//
//  Created by Raisa Methila on 10/13/23.
//

import SwiftUI
import Firebase

struct CreateAccount: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String? = nil
    @State private var navigate = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("Create an Account")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.purple)

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.all)
                    .autocapitalization(.none) // Disable auto-capitalization

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    if password != confirmPassword {
                        errorMessage = "Passwords do not match"
                        return
                    }

                    // Check if the email format is valid
                    if isValidEmail(email) {
                        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                            if let error = error {
                                if let errorCode = AuthErrorCode.Code(rawValue: error._code) {
                                    switch errorCode {
                                    case .emailAlreadyInUse:
                                        errorMessage = "This email has already been used to create an account."
                                    default:
                                        errorMessage = "Error: \(error.localizedDescription)"
                                    }
                                } else {
                                    errorMessage = "Error: \(error.localizedDescription)"
                                }
                                navigate = false
                            } else {
                                navigate = true
                                errorMessage = nil
                            }
                        }
                    } else {
                        errorMessage = "Invalid email format"
                    }
                }) {
                    Text("Sign Up")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .navigationDestination(isPresented: $navigate) {
                    HomePage()
                }

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
            }
            .padding()
        }
    }

    // Function to check if the email format is valid
    private func isValidEmail(_ email: String) -> Bool {
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
        return emailPredicate.evaluate(with: email)
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccount()
    }
}

