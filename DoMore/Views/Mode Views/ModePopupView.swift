//
//  BlockPopUpView.swift
//  DoMore
//
//  Created by Zachary Farmer on 1/14/25.
//

import SwiftUI
import FamilyControls

struct ModePopupView: View {
    @EnvironmentObject var model: MyModel
    @State private var addNewMode: Bool = false
    @State private var showingPopover = false
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    ModeList()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        unselectModes()
                        showingPopover = true
                    } label: {
                        Image(systemName: "plus")
                            .bold()
                    }
                    .tint(.gray)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("MODES")
            .popover(isPresented: $showingPopover) {
                CreateModeView(currentMode: .constant(nil))
            }
            Spacer()
            
        }
    }
    private func unselectModes() {
        model.disableShield()
    }
}

#Preview {
    ModePopupView()
}
