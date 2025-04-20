//
//  BackgroundComponent.swift
//  DoMore
//
//  Created by Zachary Farmer on 2/13/25.
//

import SwiftUI

public struct BackgroundComponent: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var hueRotation = false

    public init() { }

    public var body: some View {
        ZStack(alignment: .leading)  {
            RoundedRectangle(cornerRadius: 10)
                .fill(colorScheme == .dark ? Color.gray.opacity(0.6) : Color.white
//                    LinearGradient(
//                        colors: [Color.gray.opacity(0.6), Color.gray.opacity(0.6)],
//                        startPoint: .leading,
//                        endPoint: .trailing
//                    )
                )
                .shadow(radius: 1)

            Text("SLIDE TO LOCK")
                .font(.custom("ShareTechMono-Regular", size: 18))
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                .frame(maxWidth: .infinity)
        }
    }

}

#Preview {
    BackgroundComponent()
}
