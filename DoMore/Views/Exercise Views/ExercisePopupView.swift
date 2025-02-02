//
//  ExercisePopUpView.swift
//  DoMore
//
//  Created by Zachary Farmer on 1/14/25.
//

import SwiftUI
import FamilyControls

struct ExercisePopupView: View {
    @EnvironmentObject var model: MyModel
    @State private var addNewMode: Bool = false
    @State private var showingPopover = false
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    ExerciseListView()
                }
            }
            .toolbar {
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button {
////                        unselectModes()
//                        showingPopover = true
//                    } label: {
//                        Image(systemName: "plus")
//                            .bold()
//                    }
//                    .tint(.gray)
//                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("GOALS")
            .popover(isPresented: $showingPopover) {
                CreateExerciseView(currentGoal: .constant(nil))
            }
            Spacer()
            
        }
    }
//    private func unselectModes() {
//        model.resetDiscouragedItems()
//    }
}

#Preview {
    ExercisePopupView()
}
