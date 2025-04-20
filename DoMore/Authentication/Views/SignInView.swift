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
    @Environment(\.colorScheme) var colorScheme
    @State var showMobeSignIn: Bool = false
    
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
                .padding(.bottom, 20)
                
                
                Button {
                    showMobeSignIn.toggle()
                } label: {
                    Text("MOBILE SIGN IN")
                        .font(.custom("ShareTechMono-Regular", size: 12))
                        .padding()
                        .frame(maxWidth: 150)
                        .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                        .background(colorScheme == .dark ? Color.black : Color.white)
                        .cornerRadius(10)
                        .shadow(color: colorScheme == .dark ? Color.white : Color.gray, radius: 1)
                }
            }
            .padding(.bottom, 20)
        }
        .popover(isPresented: $showMobeSignIn) {
            MobileSignInView()
                .presentationBackground(.ultraThinMaterial)
        }
    }
}

#Preview {
    SignInView()
}
