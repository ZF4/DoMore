//
//  MainView.swift
//  DoMore
//
//  Created by Zachary Farmer on 2/27/25.
//

import SwiftUI
import FirebaseSignInWithApple

struct MainView: View {
    
    @Environment(\.firebaseSignInWithApple) private var firebaseSignInWithApple
    @AppStorage("didOnboard") private var didOnboard: Bool = false
    @StateObject private var userViewModel = UserViewModel()
    
    var body: some View {
        Group {
            switch firebaseSignInWithApple.state {
            case .loading, .authenticating:
                SplashView()
            case .notAuthenticated:
                SignInView()
            case .authenticated:
                if userViewModel.isLoading {
                    SplashView()
                } else if userViewModel.isExistingUser {
                    ContentView()
                        .environmentObject(userViewModel)
                        .onAppear {
                            userViewModel.observeUserPoints()
                        }
                } else {
                    OnboardView()
                        .environmentObject(userViewModel)
                }
            }
        }
        .onChange(of: firebaseSignInWithApple.state) { oldValue, newValue in
            print("Firebase Sign-In with Apple state changed from \(oldValue) to \(newValue)")
            if newValue == .authenticated {
                Task {
                    await userViewModel.checkExistingUser()
                    await userViewModel.createOrUpdateUser()
                    await MainActor.run {
                        userViewModel.isLoading = false
                    }
                }
            }
        }
    }
}

#Preview {
    MainView()
}
