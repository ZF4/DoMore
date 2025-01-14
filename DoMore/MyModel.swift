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
    @Published var selectionToEncourage: FamilyActivitySelection
    @Published var blockState: BlockState?
    
    init() {
        selectionToDiscourage = FamilyActivitySelection()
        selectionToEncourage = FamilyActivitySelection()
    
    }
    
    class var shared: MyModel {
        return _MyModel
    }
    
    func setShieldRestrictions() {
        store.shield.applications = selectionToDiscourage.applicationTokens.isEmpty ? nil : selectionToDiscourage.applicationTokens
        store.shield.applicationCategories = selectionToDiscourage.categoryTokens.isEmpty ? nil : ShieldSettings.ActivityCategoryPolicy.specific(selectionToDiscourage.categoryTokens)
        
        // Apply the application configuration as needed
    }
    
    func resetDiscouragedItems() {
            selectionToDiscourage = FamilyActivitySelection()
            setShieldRestrictions() // Apply the changes immediately
        }
}
