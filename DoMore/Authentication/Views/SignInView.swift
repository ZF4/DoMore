//
//  SignInView.swift
//  DoMore
//
//  Created by Zachary Farmer on 2/26/25.
//

import SwiftUI

struct SignInView: View {
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
        }
    }
}

#Preview {
    SignInView()
}
