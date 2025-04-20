//
//  CreateModeView.swift
//  DoMore
//
//  Created by Zachary Farmer on 1/14/25.
//

import SwiftUI
import FamilyControls
import SwiftData
//MARK: Need to delete modes, and be able to import a mode to edit. Also need to click a mode and make that the current block selection. Work on UI.

struct CreateModeView: View {
    @EnvironmentObject var model: MyModel
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var modeTitle: String = ""
    @State var showDelete: Bool = false
    @State var modeTitleAlreadyExists: Bool = false
    @State var isDiscouragedPresented: Bool = false
    @Binding var currentMode: BlockModel?

    var body: some View {
        NavigationStack {
            ScrollView {
                mainContent
            }
            Spacer()
        }
    }
    
    // Break down the main content into a computed property
    private var mainContent: some View {
        VStack(spacing: 20) {
            nameSection
            selectAppsSection
            doneButton
        }
        .padding(.top)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.bottom)
        .toolbar {
            if showDelete {
                ToolbarItem(placement: .topBarTrailing) {
                    deleteButton
                }
            }
            ToolbarItem(placement: .topBarLeading) {
                dismissButton
            }
        }
        .navigationBarTitleDisplayMode(.inline)
//        .navigationTitle("EDIT MODE")
        .onAppear {
            if let currentMode {
                modeTitle = currentMode.title
                showDelete = true
            }
        }
        .alert("Mode name already exists", isPresented: $modeTitleAlreadyExists) {
            Button("Okay") {
                modeTitleAlreadyExists = false
            }
        } message: {
            Text("Please choose a different name for your mode.")
        }
    }
    
    // Break down into smaller view components
    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("NAME")
                .font(.custom("ShareTechMono-Regular", size: 15))
                .foregroundColor(.gray)
            
            TextField("Mode name", text: $modeTitle)                .font(.custom("ShareTechMono-Regular", size: 15))
                .padding()
                .background(colorScheme == .dark ? Color.gray.opacity(0.6) : Color.white)
                .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                .cornerRadius(10)
                .shadow(radius: 1)
        }
        .padding(.horizontal)
    }
    
    private var selectAppsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("SELECT APPS")
                .font(.custom("ShareTechMono-Regular", size: 15))
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            
            appSelectionButton
        }
        .padding(.horizontal)
    }
    
    private var appSelectionButton: some View {
        Button(action: { isDiscouragedPresented = true }) {
            HStack {
                appSelectionInfo
                Spacer()
                editButton
            }
            .padding()
            .background(colorScheme == .dark ? Color.gray.opacity(0.6) : Color.white)
            .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
            .cornerRadius(10)
            .shadow(radius: 1)
        }
        .familyActivityPicker(isPresented: $isDiscouragedPresented, selection: $model.selectionToDiscourage)
    }
    
    private var appSelectionInfo: some View {
        VStack(alignment: .leading) {
            Text("\(model.selectionToDiscourage.applicationTokens.count)  Apps Selected")
                .font(.custom("ShareTechMono-Regular", size: 15))
                .bold()
            Text("\(model.selectionToDiscourage.categoryTokens.count)  Categories Selected")
                .font(.custom("ShareTechMono-Regular", size: 15))
                .bold()
        }
    }
    
    private var editButton: some View {
        Image(systemName: "pencil")
            .font(.system(size: 20))
            .bold()
            .foregroundColor(.white)
    }
    
    private var doneButton: some View {
        Button(action: {
            guard !modeTitle.isEmpty else { return }
            addMode(title: modeTitle, selection: model.selectionToDiscourage)
            modeTitle = ""
        }) {
            Text("DONE")
                .font(.custom("ShareTechMono-Regular", size: 15))
                .frame(maxWidth: .infinity)
                .padding()
        }
        .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
        .background(colorScheme == .dark ? Color.gray.opacity(0.6) : Color.white)
        .cornerRadius(10)
        .shadow(radius: 1)
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
    
    private var deleteButton: some View {
        Button {
            deleteMode(modeTitle)
        } label: {
            Image(systemName: "trash")
                .bold()
        }
        .tint(.gray)
    }
    
    private var dismissButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .bold()
        }
        .tint(.gray)
    }
    
    private func deleteMode(_ modeToDelete: String) {
        // Find and delete the mode with matching name
        if let modeToRemove = try? modelContext.fetch(FetchDescriptor<BlockModel>())
            .first(where: { $0.title == modeToDelete }) {
            modelContext.delete(modeToRemove)
        }
    }
    
    private func addMode(title: String, selection: FamilyActivitySelection) {
        if let currentMode {
            print("Is current mode selected")
            currentMode.title = modeTitle
            currentMode.applicationTokens = try? JSONEncoder().encode(selection.applicationTokens)
            currentMode.categoryTokens = try? JSONEncoder().encode(selection.categoryTokens)
            
            dismiss()
        } else {
            if (try? modelContext.fetch(FetchDescriptor<BlockModel>())
                .first(where: { $0.title == title })) != nil {
                modeTitleAlreadyExists = true
            } else {
                let mode = BlockModel(title: title,
                                     applicationTokens: try? JSONEncoder().encode(selection.applicationTokens),
                                     categoryTokens: try? JSONEncoder().encode(selection.categoryTokens))
                modelContext.insert(mode) // Save mode to the context
                try? modelContext.save() // Persist to storage
                
                dismiss()
            }
        }
    }
}

#Preview {
    CreateModeView(currentMode: .constant(BlockModel(title: "test")))
        .environmentObject(MyModel())
        .modelContainer(for: BlockModel.self, inMemory: true)
}
