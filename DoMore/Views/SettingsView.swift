//
//  SettingsView.swift
//  DoMore
//
//  Created by Zachary Farmer on 2/13/25.
//

import SwiftUI
import SwiftData
import FirebaseSignInWithApple

struct SettingsView: View {
    @EnvironmentObject var model: MyModel
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var modelContext
    @Query private var modes: [BlockModel]
    @State var showSelectPhoto: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                CircularProfileImageView(user: userViewModel.currentUser, size: .xLarge)
                
                VStack(alignment: .leading) {
                    Text("\(userViewModel.currentUser?.username ?? "No username")")
                        .font(.custom("ShareTechMono-Regular", size: 30))
                    
                    Text("POINTS: \(userViewModel.currentUser?.points ?? 0)")
                        .font(.custom("ShareTechMono-Regular", size: 20))
                    
                    //MARK: ADD DATE JOINED ///////////////
                }
                Spacer()
            }
            .padding(.bottom, 25)
            
            if userViewModel.currentUser?.isDev == true {
                // Existing Buttons
                Button(action: {
                    model.disableShield()
                    for mode in modes {
                        mode.isActive = false
                        mode.isLocked = false
                    }
                }) {
                    Text("HARD RESET")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .background(Color.green)
                        .cornerRadius(15)
                }
                .padding(.horizontal)
            }
            //MARK: TO ADD CUSTOM IMAGE LATER ///////
//            Button(action: {
//                showSelectPhoto = true
//            }) {
//                Text("SET PROFILE PICTURE")
//                    .font(.custom("ShareTechMono-Regular", size: 18))
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .cornerRadius(10)
//                    .shadow(radius: 4)
//            }
//            .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
//            .background(colorScheme == .dark ? Color.gray.opacity(0.6) : Color.white)
//            .cornerRadius(10)
//            .shadow(radius: 1)
//            .padding(.horizontal)
            
            ColorPickerView()
            
            Spacer()
            
            if userViewModel.currentUser?.loginMethod == .apple {
                FirebaseSignOutWithAppleButton {
                    FirebaseSignInWithAppleLabel(.signOut)
                }
            } else {
                Button(action: {
                    userViewModel.signOutUser()
                }) {
                    Text("SIGN OUT")
                        .font(.custom("ShareTechMono-Regular", size: 18))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                }
                .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                .background(colorScheme == .dark ? Color.gray.opacity(0.6) : Color.white)
                .cornerRadius(10)
                .shadow(radius: 1)
                .padding(.horizontal)
            }
        }
        .padding()
        //MARK: TO ADD CUSTOM IMAGE LATER ///////
//        .popover(isPresented: $showSelectPhoto) {
//            ProfilePictureSelection()
//        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(UserViewModel())
}
