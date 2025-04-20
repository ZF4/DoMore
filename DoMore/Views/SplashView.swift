//
//  SplashView.swift
//  DoMore
//
//  Created by Zachary Farmer on 3/15/25.
//

import SwiftUI

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.primary.colorInvert().ignoresSafeArea()
            
            VStack {
                Text("STRIDE")
                    .font(.custom("ShareTechMono-Regular", size: 50))
                    .padding(.top)
                
                ProgressView()
                    .padding(.top, 20)
            }
        }
    }
}

#Preview {
    SplashView()
}
