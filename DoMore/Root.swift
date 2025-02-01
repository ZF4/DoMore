

import SwiftUI
import SwiftData
import FamilyControls
import ManagedSettings
import ManagedSettingsUI

@main
@MainActor
struct Root: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @StateObject var model = MyModel.shared
    @StateObject var store = ManagedSettingsStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(appContainer)
                .environmentObject(model)
                .environmentObject(store)
        }
    }
    
    let appContainer: ModelContainer = {
        do {
            let container = try ModelContainer(for: BlockModel.self, ExerciseModel.self)
            
            // Make sure the persistent store is empty. If it's not, return the non-empty container.
            var itemFetchDescriptor = FetchDescriptor<ExerciseModel>()
            itemFetchDescriptor.fetchLimit = 1
            
            guard try container.mainContext.fetch(itemFetchDescriptor).count == 0 else { return container }
            
            // This code will only run if the persistent store is empty.
            let items = [
                ExerciseModel(title: "Steps", exerciseType: .steps, value: 0),
                ExerciseModel(title: "Minutes", exerciseType: .minutes, value: 0)
            ]
            
            for item in items {
                container.mainContext.insert(item)
            }
            
            return container
        } catch {
            fatalError("Failed to create container")
        }
    }()

}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Task {
            do {
                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            } catch {
                print("Error for Family Controls: \(error)")
            }
        }
       
       // MySchedule.setSchedule()
        
        return true
    }
}
