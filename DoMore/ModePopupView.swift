//
//  BlockPopUpView.swift
//  DoMore
//
//  Created by Zachary Farmer on 1/14/25.
//

import SwiftUI

struct ModePopupView: View {
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
                        showingPopover = true
                    } label: {
                        Image(systemName: "plus")
                            .bold()
                    }
                    .tint(.gray)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("SELECT MODE")
            .popover(isPresented: $showingPopover) {
                CreateModeView()
            }
            Spacer()
        }
    }
}

#Preview {
    ModePopupView()
}
