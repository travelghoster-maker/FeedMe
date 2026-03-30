import SwiftUI
import Combine

// MARK: - App State

class AppStore: ObservableObject {
    @Published var subscriptions: [Subscription] = MockData.subscriptions
    @Published var feedItems: [FeedItem] = MockData.allFeedItems
    @Published var selectedTab: Int = 0
    @Published var showCreateSubscription: Bool = false
    @Published var newSubscriptionFromChat: Subscription? = nil

    // Filter
    @Published var activeFilter: String? = nil  // nil = All

    var filteredFeedItems: [FeedItem] {
        guard let filter = activeFilter,
              let sub = subscriptions.first(where: { $0.title == filter }) else {
            return feedItems
        }
        return feedItems.filter { $0.subscriptionId == sub.id }
    }

    func addSubscription(_ sub: Subscription) {
        subscriptions.insert(sub, at: 0)
        // Simulate fetching items for new subscription
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.generateMockItemsForSubscription(sub)
        }
    }

    func removeSubscription(_ sub: Subscription) {
        subscriptions.removeAll { $0.id == sub.id }
        feedItems.removeAll { $0.subscriptionId == sub.id }
    }

    private func generateMockItemsForSubscription(_ sub: Subscription) {
        // In real app, this calls backend API
        // For demo, we just note it was added
    }
}
