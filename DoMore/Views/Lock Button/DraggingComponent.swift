//
// 21/06/2022
//
// Created by: Valerie Abelovska
// Copyright © GoodRequest s.r.o. All rights reserved.

import SwiftUI
import CoreHaptics

public struct DraggingComponent: View {
    
    @Binding var isUnlocked: Bool
    let isLoading: Bool
    let maxWidth: CGFloat
    
    @State private var width = CGFloat(50)
    private  let minWidth = CGFloat(50)
    
    public init(isUnlocked: Binding<Bool>, isLoading: Bool, maxWidth: CGFloat) {
        _isUnlocked = isUnlocked
        self.isLoading = isLoading
        self.maxWidth = maxWidth
    }
    
    public var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.black)
            .opacity(width / maxWidth)
            .frame(width: width)
            .overlay(
                Button(action: { }) {
                    ZStack {
                        image(name: "lock.open", isShown: isUnlocked)
                        progressView(isShown: isLoading)
                        image(name: "lock", isShown: !isUnlocked && !isLoading)
                    }
                    .animation(.easeIn(duration: 0.35).delay(0.55), value: !isUnlocked && !isLoading)
                }
                    .buttonStyle(BaseButtonStyle())
                    .disabled(!isUnlocked || isLoading),
                alignment: .trailing
            )
        
            .simultaneousGesture(
                DragGesture()
                    .onChanged { value in
                        guard isUnlocked else { return }
                        if value.translation.width > 0 {
                            width = min(max(value.translation.width + minWidth, minWidth), maxWidth)
                        }
                    }
                    .onEnded { value in
                        guard isUnlocked else { return }
                        if width < maxWidth {
                            width = minWidth
                            UINotificationFeedbackGenerator().notificationOccurred(.warning)
                        } else {
                            UINotificationFeedbackGenerator().notificationOccurred(.success)
                            withAnimation(.spring().delay(0.5)) {
                                isUnlocked = false
                            }
                        }
                    }
            )
            .animation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 0), value: width)
        
    }
    
    private func image(name: String, isShown: Bool) -> some View {
        Image(systemName: name)
            .font(.system(size: 20, weight: .regular, design: .rounded))
            .foregroundColor(Color.black)
            .frame(width: 42, height: 50)
            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
            .padding(4)
            .opacity(isShown ? 1 : 0)
            .scaleEffect(isShown ? 1 : 0.01)
    }
    
    private func progressView(isShown: Bool) -> some View {
        ProgressView()
            .progressViewStyle(.circular)
            .tint(.white)
            .opacity(isShown ? 1 : 0)
            .scaleEffect(isShown ? 1 : 0.01)
    }
    
}

#Preview {
    LockButton(onSelect: { })
}

