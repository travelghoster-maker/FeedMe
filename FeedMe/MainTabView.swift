import SwiftUI

// MARK: - Main Tab View

struct MainTabView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        TabView(selection: $store.selectedTab) {
            HomeView()
                .tabItem {
                    Label("首页", systemImage: store.selectedTab == 0 ? "house.fill" : "house")
                }
                .tag(0)

            ChatView()
                .tabItem {
                    Label("发现", systemImage: store.selectedTab == 1 ? "sparkles" : "sparkle")
                }
                .tag(1)
        }
        .tint(.appPrimary)
    }
}

// MARK: - Preview

#Preview("完整 App") {
    MainTabView()
        .environmentObject(AppStore())
}
