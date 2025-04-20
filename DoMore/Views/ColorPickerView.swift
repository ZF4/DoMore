//
//  ColorPicker.swift
//  DoMore
//
//  Created by Zachary Farmer on 4/17/25.
//

import SwiftUI

struct ColorPickerView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var bgColor = Color.gray
    
    var body: some View {
        VStack {
            HStack {
                ColorPicker("SELECT YOUR COLOR", selection: $bgColor)
                    .font(.custom("ShareTechMono-Regular", size: 20))
                    .padding()
            }
            .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
            .background(colorScheme == .dark ? Color.gray.opacity(0.6) : Color.white)
            .cornerRadius(10)
            .shadow(radius: 1)
            .padding(.horizontal)
        }
        .onAppear {
            if let userColor = userViewModel.currentUser?.userColor {
                bgColor = userColor
            }
        }
        .onDisappear {
            Task {
                await userViewModel.updateUserColor(bgColor)
            }
        }
    }
}


#Preview {
    ColorPickerView()
        .environmentObject(UserViewModel())
}
