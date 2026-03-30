import SwiftUI

@main
struct FeedMeApp: App {
    @StateObject private var state = AppState()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(state)
        }
    }
}
