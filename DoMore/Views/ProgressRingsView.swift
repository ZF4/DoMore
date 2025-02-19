//
//  ProgressRingsView.swift
//  DoMore
//
//  Created by Zachary Farmer on 2/1/25.
//

import SwiftUI

struct ProgressRing: View {
    var current: Double?
    var goal: Double?
    var type: ExerciseModel.ExerciseType?
    var text: String {
        if type == .steps {
            return "Steps"
        } else {
            return "Mins"
        }
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 20)
                .frame(width: 300)
            Circle()
                .trim(from: 0.0, to: CGFloat(min((current ?? 0) / (goal ?? 0), 1.0)))
                .stroke(
                      LinearGradient(
                        gradient: Gradient(colors: [Color.purple, Color.blue]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                      ),
                      style: StrokeStyle(lineWidth: 20, lineCap: .round)
                  )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: current)
                .frame(width: 300)
            
            // Progress Labels
            VStack {
                Text("\(Int(current ?? 0)) \(text)")
                    .font(.custom("ShareTechMono-Regular", size: 22))
//                    .font(.system(size: 20, weight: .medium, design: .monospaced))
                    .padding(.top)
                
                Divider()
                    .frame(width: 50)
                
                Text("Goal: \(Int(goal ?? 0))")
                    .font(.custom("ShareTechMono-Regular", size: 16))
//                    .font(.system(size: 15, weight: .light, design: .monospaced))
            }
        }
    }
}

#Preview {
    ProgressRing(current: 750, goal: 1000, type: .steps)
}
