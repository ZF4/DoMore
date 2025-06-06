//
//  OnboardView.swift
//  DoMore
//
//  Created by Zachary Farmer on 2/27/25.
//

import SwiftUI

struct OnboardView: View {
    @EnvironmentObject private var userViewModel: UserViewModel
    @AppStorage("didOnboard") private var didOnboard: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    @State private var username = ""
    @State private var isCheckingUsername = false
    @State private var usernameError: String?
    @State private var isUsernameValid = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("SET A USERNAME. THIS WILL BE USED FOR OUR COMMUNITY BOARD.")
                    .font(.custom("ShareTechMono-Regular", size: 20))
                
                TextField("cool username", text: $username)
                    .textFieldStyle(OutlinedTextFieldStyle(icon: Image(systemName: "at")))
                    .padding(.bottom, 5)
                    .keyboardType(.alphabet)
                    .textCase(.lowercase)
                    .onChange(of: username) { oldValue, newValue in
                        validateUsername()
                    }
                
                if let error = usernameError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.custom("ShareTechMono-Regular", size: 12))
                }
                
                Text("WE DO NOT STORE YOUR NAME. THIS IS THE ONLY WAY YOU WILL BE IDENTIFIED.")
                    .font(.custom("ShareTechMono-Regular", size: 12))
                
                Button(action: {
                    Task {
                        await saveUsername()
                    }
                }) {
                    if isCheckingUsername {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Text("SET USERNAME")
                            .font(.custom("ShareTechMono-Regular", size: 14))
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                .background(colorScheme == .dark ? Color.black : Color.white)
                .cornerRadius(10)
                .shadow(color: colorScheme == .dark ? Color.white : Color.gray, radius: 1)
                .disabled(!isUsernameValid || isCheckingUsername)
                .padding(.top, 10)
            }
            .padding()
            .navigationDestination(isPresented: .init(
                get: { didOnboard },
                set: { _ in }
            )) {
                ContentView()
                    .navigationBarBackButtonHidden()
            }
        }
    }
    
    private func validateUsername() {
        // Reset states
        usernameError = nil
        isUsernameValid = false
        
        // Basic validation
        guard username.count >= 3 else {
            usernameError = "Username must be at least 3 characters"
            return
        }
        
        guard username.count <= 15 else {
            usernameError = "Username must be less than 15 characters"
            return
        }
        
        guard username.matches(of: /^[a-zA-Z0-9._]+$/).count > 0 else {
            usernameError = "Username can only contain letters, numbers, dots, and underscores"
            return
        }
        
        isUsernameValid = true
    }
    
    private func saveUsername() async {
        isCheckingUsername = true
        defer { isCheckingUsername = false }
        
        do {
            let isAvailable = try await userViewModel.checkUsernameAvailable(username)
            if isAvailable {
                userViewModel.createNewUser(username: username.lowercased())
                didOnboard = true
            } else {
                usernameError = "Username is already taken"
                isUsernameValid = false
            }
        } catch {
            usernameError = "Error checking username availability"
            isUsernameValid = false
        }
    }
}

struct OutlinedTextFieldStyle: TextFieldStyle {
    @Environment(\.colorScheme) var colorScheme
    @State var icon: Image?
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            if icon != nil {
                icon
                    .foregroundColor(colorScheme == .dark ? .gray : .black)
            }
            configuration
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(Color(UIColor.black), lineWidth: 2)
        }
    }
}

#Preview {
    OnboardView()
}
