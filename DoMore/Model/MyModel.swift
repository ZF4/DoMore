import Foundation
import FamilyControls
import ManagedSettings
import UIKit
import ManagedSettingsUI
import SwiftData

private let _MyModel = MyModel()

class MyModel: ObservableObject {
    let store = ManagedSettingsStore()
    
    @Published var selectionToDiscourage: FamilyActivitySelection
    @Published var blockState: BlockModel?
    // Update the hasActiveRestrictions computed property
    
    init() {
        selectionToDiscourage = FamilyActivitySelection()
    }
    
    class var shared: MyModel {
        return _MyModel
    }
    
    func setShieldRestrictions() {
        print("*******SHIELD IS SET********")
        store.shield.applications = selectionToDiscourage.applicationTokens.isEmpty ? nil : selectionToDiscourage.applicationTokens
        store.shield.applicationCategories = selectionToDiscourage.categoryTokens.isEmpty ? nil : ShieldSettings.ActivityCategoryPolicy.specific(selectionToDiscourage.categoryTokens)
        blockState?.isActive = true
    }
    
    func resetDiscouragedItems() {
        selectionToDiscourage = FamilyActivitySelection()
        setShieldRestrictions() // Apply the changes immediately
        blockState?.isActive = false
        }
}
