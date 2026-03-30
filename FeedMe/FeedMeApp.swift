import SwiftUI

@main
struct FeedMeApp: App {
    @StateObject private var store = AppStore()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(store)
        }
    }
}
