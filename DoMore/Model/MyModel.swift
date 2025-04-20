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
        store.shield.applications = selectionToDiscourage.applicationTokens.isEmpty ? nil : selectionToDiscourage.applicationTokens
        store.shield.applicationCategories = selectionToDiscourage.categoryTokens.isEmpty ? nil : ShieldSettings.ActivityCategoryPolicy.specific(selectionToDiscourage.categoryTokens)
        blockState?.isActive = true
    }
    
    // Add new method to temporarily disable shield
    func disableShield() {
        store.shield.applicationCategories = nil
        store.shield.applications = nil
    }
    
    // Add new method to restore shield with existing selection
    func restoreShield() {
        store.shield.applications = selectionToDiscourage.applicationTokens.isEmpty ? nil : selectionToDiscourage.applicationTokens
        store.shield.applicationCategories = selectionToDiscourage.categoryTokens.isEmpty ? nil : ShieldSettings.ActivityCategoryPolicy.specific(selectionToDiscourage.categoryTokens)
        blockState?.isActive = false
    }
    
    //MARK: DEV ONLY. Will reset block state even if goals are not met.
//    func resetDiscouragedItems() {
//        selectionToDiscourage = FamilyActivitySelection()
//        setShieldRestrictions() // Apply the changes immediately
//        blockState?.isActive = false
//    }
}
