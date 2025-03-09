//
//  SignInView.swift
//  DoMore
//
//  Created by Zachary Farmer on 2/26/25.
//

import SwiftUI
import FirebaseSignInWithApple

struct SignInView: View {
    
    @Environment(\.firebaseSignInWithApple) private var firebaseSignInWithApple
    
    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader {
                let size = $0.size
                
                Image(.run)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .offset(y: -90)
                    .frame(width: size.width, height: size.height)
                
            }
            .mask {
                Rectangle()
                    .fill(.linearGradient(
                        colors: [
                            .white,
                            .white,
                            .white,
                            .white.opacity(0.9),
                            .white.opacity(0.6),
                            .white.opacity(0.2),
                            .clear,
                            .clear,
                        ],
                        startPoint: .top, endPoint: .bottom))
            }
            .ignoresSafeArea()
            
            VStack(alignment: .center) {
                Text("STRIDE")
                    .font(.custom("ShareTechMono-Regular", size: 50))
                    .padding(.bottom, 15)
                
                Text("TAKE BACK YOUR TIME, ONE STEP AT A TIME")
                    .font(.custom("ShareTechMono-Regular", size: 12))
                    .padding(.bottom, 20)
                    
                FirebaseSignInWithAppleButton {
                    FirebaseSignInWithAppleLabel(.signIn)
                }
                .padding(.bottom, 10)
                
                Text("EMAIL LOGIN COMING SOON")
                    .font(.custom("ShareTechMono-Regular", size: 11))
                    .foregroundStyle(Color.gray)
                    .padding(.bottom, 30)
                
            }
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    SignInView()
}
