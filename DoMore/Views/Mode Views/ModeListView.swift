//
//  EditModeView.swift
//  DoMore
//
//  Created by Zachary Farmer on 1/14/25.
//

import SwiftUI
import SwiftData
import FamilyControls
import ManagedSettings

struct ModeList: View {
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) var colorScheme
    @Query private var modes: [BlockModel]
    @State private var selectedModeId: UUID?
    @Environment(\.dismiss) private var dismiss // Applies to DetailView.
    
    private func setSelectMode(_ selectedMode: BlockModel) {
        // Deactivate all other modes
        for mode in modes {
            mode.isSelected = mode.id == selectedMode.id
            print("Active: \(mode.isActive)")
            print("Selected: \(mode.isSelected)")
            dismiss()
        }
        
        // Activate the selected mode's restrictions
        if let mode = modes.first(where: { $0.isSelected }) {
            selectMode(mode: mode)
        }
    }
    
    private func selectMode(mode: BlockModel) {
        var selection = FamilyActivitySelection()
        if let appTokensData = mode.applicationTokens {
            selection.applicationTokens = (try? JSONDecoder().decode(Set<ApplicationToken>.self, from: appTokensData)) ?? []
        }
        if let categoryTokensData = mode.categoryTokens {
            selection.categoryTokens = (try? JSONDecoder().decode(Set<ActivityCategoryToken>.self, from: categoryTokensData)) ?? []
        }
        MyModel.shared.selectionToDiscourage = selection
//        MyModel.shared.setShieldRestrictions()
    }
    
    var body: some View {
        VStack {
            if modes.isEmpty {
                VStack {
                    HStack {
                        Text("CREATE A BLOCK MODE")
                            .font(.custom("ShareTechMono-Regular", size: 20))
                        
                        Image(systemName: "arrow.up.forward")
//                            .foregroundStyle(Color.white)
                            .font(.system(size: 30))
                        
                    }
                    Text("CREATE MULTIPLE BLOCK MODES TO FIT YOUR NEEDS. SOCIAL MEDIA, GAMES, ETC.")
                        .font(.custom("ShareTechMono-Regular", size: 13))
                        .foregroundStyle(colorScheme == .light ? Color.black.opacity(0.5) : Color.white.opacity(0.5))
                }
                .padding(.horizontal)
            } else {
                ForEach(modes) { mode in
                    ModeCellView(
                        mode: mode,
                        isSelected: mode.isSelected,
                        onSelect: {
                            setSelectMode(mode)
                        }
                    )
                }
            }
        }
        .padding(.top)
    }
}

struct ModeCellView: View {
    @State private var showEditMode: Bool = false
    @State var selectedMode: BlockModel?
    var mode: BlockModel
    var isSelected: Bool
    var onSelect: () -> Void
    
    var body: some View {
        ZStack {
            // Centered text
            Text(mode.title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(25)
                .foregroundStyle(Color.white)
            
            // Right-aligned button
            HStack {
                Spacer()
                Button(action: {
                    selectedMode = mode
                    showEditMode = true
                    selectMode(mode: mode)
                }) {
                    Image(systemName: "pencil")
                        .font(.system(size: 20))
                        .bold()
                }
                .padding(.trailing)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.6))
        .cornerRadius(12)
        .shadow(radius: mode.isSelected ? 6 : 1)
        .padding(.horizontal, 30)
        .padding(.bottom)
        .popover(isPresented: $showEditMode) {
            CreateModeView(currentMode: $selectedMode)
        }
        .onTapGesture {
            selectedMode = mode
            onSelect()
        }
    }
    // Activate a mode by applying its restrictions
    private func selectMode(mode: BlockModel) {
        var selection = FamilyActivitySelection()
        if let appTokensData = mode.applicationTokens {
            selection.applicationTokens = (try? JSONDecoder().decode(Set<ApplicationToken>.self, from: appTokensData)) ?? []
        }
        if let categoryTokensData = mode.categoryTokens {
            selection.categoryTokens = (try? JSONDecoder().decode(Set<ActivityCategoryToken>.self, from: categoryTokensData)) ?? []
        }
        MyModel.shared.selectionToDiscourage = selection
        //MARK: THIS SHOULD STAY COMMENTED OUT FOR NOW.
//        MyModel.shared.setShieldRestrictions()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: BlockModel.self, configurations: config)

    for i in 1..<3 {
        let user = BlockModel(title: "Test")
        container.mainContext.insert(user)
    }

    return ModeList()
        .modelContainer(container)
}
