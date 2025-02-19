//
//  BackgroundComponent.swift
//  DoMore
//
//  Created by Zachary Farmer on 2/13/25.
//

import SwiftUI

public struct BackgroundComponent: View {

    @State private var hueRotation = false

    public init() { }

    public var body: some View {
        ZStack(alignment: .leading)  {
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    LinearGradient(
                        colors: [Color.gray.opacity(0.6), Color.gray.opacity(0.6)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(radius: 4)

            Text("SLIDE TO LOCK")
                .font(.custom("VT323-Regular", size: 18))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
    }

}

#Preview {
    BackgroundComponent()
}
