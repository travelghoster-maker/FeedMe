import SwiftUI

// MARK: - Home View

struct HomeView: View {
    @EnvironmentObject var store: AppStore
    @State private var scrollOffset: CGFloat = 0
    @State private var showingSubscriptions = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        // Subscription Filter Chips
                        SubscriptionFilterBar()
                            .padding(.top, Spacing.sm)
                            .padding(.bottom, Spacing.lg)

                        // Feed Items
                        if store.filteredFeedItems.isEmpty {
                            EmptyFeedView()
                                .padding(.top, 60)
                        } else {
                            ForEach(store.filteredFeedItems) { item in
                                FeedCardWrapper(item: item)
                                    .padding(.horizontal, Spacing.lg)
                                    .padding(.bottom, Spacing.lg)
                            }
                        }

                        // Bottom padding for tab bar
                        Color.clear.frame(height: 80)
                    }
                }
                .scrollIndicators(.hidden)
                .refreshable {
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                }

                // Floating hint (first launch)
                FloatingHintView()
                    .padding(.bottom, 100)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("订阅")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingSubscriptions = true
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color(.secondarySystemBackground))
                                .frame(width: 34, height: 34)
                            Image(systemName: "square.stack.3d.up")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingSubscriptions) {
                SubscriptionsView()
            }
        }
    }
}

// MARK: - Subscription Filter Bar

struct SubscriptionFilterBar: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        ScrollView(.horizontal, showsScrollIndicators: false) {
            HStack(spacing: Spacing.sm) {
                FilterChip(
                    title: "全部",
                    count: store.feedItems.count,
                    isSelected: store.activeFilter == nil,
                    color: .appPrimary
                ) {
                    withAnimation(.spring(response: 0.3)) {
                        store.activeFilter = nil
                    }
                }

                ForEach(store.subscriptions) { sub in
                    FilterChip(
                        title: sub.title,
                        count: store.feedItems.filter { $0.subscriptionId == sub.id }.count,
                        isSelected: store.activeFilter == sub.title,
                        color: Color.fromHex(sub.colorHex)
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            store.activeFilter = store.activeFilter == sub.title ? nil : sub.title
                        }
                    }
                }
            }
            .padding(.horizontal, Spacing.lg)
        }
    }
}

// MARK: - Filter Chip

struct FilterChip: View {
    let title: String
    let count: Int
    let isSelected: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.xs) {
                Text(title)
                    .font(AppFont.footnote().weight(isSelected ? .semibold : .regular))
                    .lineLimit(1)

                if count > 0 {
                    Text("\(count)")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(isSelected ? .white.opacity(0.8) : color.opacity(0.8))
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .background(isSelected ? .white.opacity(0.2) : color.opacity(0.15))
                        .clipShape(Capsule())
                }
            }
            .foregroundColor(isSelected ? .white : .primary)
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.sm)
            .background(isSelected ? color : Color(.secondarySystemBackground))
            .clipShape(Capsule())
        }
        .animation(.spring(response: 0.25), value: isSelected)
    }
}

// MARK: - Feed Card Wrapper (routes to correct card type)

struct FeedCardWrapper: View {
    let item: FeedItem
    @EnvironmentObject var store: AppStore

    private var subscriptionTitle: String {
        store.subscriptions.first(where: { $0.id == item.subscriptionId })?.title ?? ""
    }

    var body: some View {
        switch item.type {
        case .app:
            AppCardView(item: item, subscriptionTitle: subscriptionTitle)
        case .event:
            EventCardView(item: item, subscriptionTitle: subscriptionTitle)
        case .content:
            // Placeholder for article cards
            Text("Article Card")
        }
    }
}

// MARK: - Empty Feed

struct EmptyFeedView: View {
    var body: some View {
        VStack(spacing: Spacing.xl) {
            Image(systemName: "tray")
                .font(.system(size: 48))
                .foregroundColor(Color(.tertiaryLabel))

            VStack(spacing: Spacing.sm) {
                Text("这里还是空的")
                    .font(AppFont.headline())
                    .foregroundColor(.secondary)

                Text("试试说「推荐几个设计感强的 App」\n或「北京本周末有什么活动」")
                    .font(AppFont.subheadline())
                    .foregroundColor(Color(.tertiaryLabel))
                    .multilineTextAlignment(.center)
            }
        }
    }
}

// MARK: - Floating Hint

struct FloatingHintView: View {
    @EnvironmentObject var store: AppStore
    @AppStorage("hasSeenHint") private var hasSeenHint = false

    var body: some View {
        if !hasSeenHint && store.subscriptions.isEmpty {
            HStack(spacing: Spacing.md) {
                Image(systemName: "sparkles")
                    .font(.system(size: 16))
                    .foregroundColor(.appPrimary)

                Text("试着告诉我你想订阅什么 ✨")
                    .font(AppFont.subheadline())
                    .foregroundColor(.primary)

                Spacer()

                Button {
                    hasSeenHint = true
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .padding(Spacing.lg)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: Radius.xl))
            .padding(.horizontal, Spacing.lg)
            .cardShadow()
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }
}
