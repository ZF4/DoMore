//
//  EditModeView.swift
//  DoMore
//
//  Created by Zachary Farmer on 1/14/25.
//

import SwiftUI

struct ModeList: View {
    var body: some View {
        VStack {
            ModeEditView()
            ModeEditView()
        }
        .padding(.top)
    }
}

struct ModeEditView: View {
    var isSelected = true
    var body: some View {
        ZStack {
            // Centered text
            Text("SOCIAL BLOCK")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(25)
            
            // Right-aligned button
            HStack {
                Spacer()
                Button(action: {
                    
                }) {
                    Image(systemName: "pencil")
                        .font(.system(size: 20))
                        .bold()
                        .foregroundColor(.gray)
                }
                .padding(.trailing)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: isSelected ? 6 : 1)
        .padding(.horizontal, 30)
        .padding(.bottom)
    }
}

#Preview {
    ModeList()
}
