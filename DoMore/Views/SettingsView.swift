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
    @Environment(\.modelContext) private var modelContext
    @Query private var modes: [BlockModel]
    @State var showSelectPhoto: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                CircularProfileImageView(size: .xLarge)
                
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
                    model.resetDiscouragedItems()
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
                
                Button(action: {
                    BlockTimeTracker.shared.resetBlockedTime()
                    for mode in modes {
                        mode.isActive = false
                        mode.isLocked = false
                    }
                }) {
                    Text("RESET BLOCK TIME")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .background(Color.green)
                        .cornerRadius(15)
                }
                .padding(.horizontal)
            }
            
            Button(action: {
                showSelectPhoto = true
            }) {
                Text("SET PROFILE PICTURE")
                    .font(.custom("ShareTechMono-Regular", size: 18))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.white)
                    .background(Color.gray.opacity(0.6))
                    .cornerRadius(10)
                    .shadow(radius: 4)
            }
            .padding(.horizontal)
            
            Spacer()
            
            FirebaseSignOutWithAppleButton {
                FirebaseSignInWithAppleLabel(.signOut)
            }
        }
        .padding()
        .popover(isPresented: $showSelectPhoto) {
            ProfilePictureSelection()
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(UserViewModel())
}
