import SwiftUI
import SwiftData
import FamilyControls
import ManagedSettings
import ManagedSettingsUI
import FirebaseSignInWithApple
import FirebaseCore

@main
@MainActor
struct Root: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @StateObject var model = MyModel.shared
    @StateObject var store = ManagedSettingsStore()
    @StateObject var statsViewModel = StatsViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .modelContainer(appContainer)
                .environmentObject(model)
                .environmentObject(store)
                .environmentObject(statsViewModel)
                .configureFirebaseSignInWithAppleWith(firestoreUserCollectionPath: Path.FireStore.profiles)
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
        FirebaseConfiguration.shared.setLoggerLevel(.debug)
        print("Configuring Firebase...")
        FirebaseApp.configure()
        print("Firebase configured successfully")
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        return .noData
    }
}


