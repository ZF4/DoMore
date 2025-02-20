//
//  SettingsView.swift
//  DoMore
//
//  Created by Zachary Farmer on 2/13/25.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @EnvironmentObject var model: MyModel
    @Environment(\.modelContext) private var modelContext
    @Query private var modes: [BlockModel]
    var body: some View {
        VStack {
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
    }
}

#Preview {
    SettingsView()
}
