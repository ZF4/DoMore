//
//  UnlockButton.swift
//  DoMore
//
//  Created by Zachary Farmer on 2/13/25.
//

import SwiftUI

struct UnlockButton: View {
    var onSelect: () -> Void
    
    var body: some View {
        Button(action: { }) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.6))
                .frame(width: 60, height: 60)
                .overlay(
                    Button(action: { onSelect() }) {
                        ZStack {
                            image(name: "lock")
                        }
                    }
                        .buttonStyle(BaseButtonStyle())
                )
        }
    }
    
    private func image(name: String) -> some View {
        Image(systemName: name)
            .font(.system(size: 20, weight: .regular, design: .rounded))
            .foregroundColor(Color.black)
            .frame(width: 50, height: 50)
            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
            .padding(4)
    }
}

#Preview {
    UnlockButton(onSelect: {  })
}
