//
//  AuthView.swift
//  DoMore
//
//  Created by Zachary Farmer on 2/27/25.
//

import SwiftUI
import FirebaseSignInWithApple

struct AuthView: View {
    
    @Environment(\.firebaseSignInWithApple) private var firebaseSignInWithApple
    
    var body: some View {
        VStack {
            Spacer()
            
            FirebaseSignInWithAppleButton {
                FirebaseSignInWithAppleLabel(.signUp)
            }
        }
        .padding()
    }
}

#Preview {
    AuthView()
}
