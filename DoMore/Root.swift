

import SwiftUI
import SwiftData
import FamilyControls
import ManagedSettings
import ManagedSettingsUI

@main
struct Root: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @StateObject var model = MyModel.shared
    @StateObject var store = ManagedSettingsStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [BlockState.self])
                .environmentObject(model)
                .environmentObject(store)
        }
    }
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
