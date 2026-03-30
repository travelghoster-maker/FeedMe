import SwiftUI

// MARK: - App Card (Full)

struct AppCardView: View {
    let item: FeedItem
    let subscriptionTitle: String
    @State private var isPressed = false

    private var app: AppContent? {
        if case .app(let a) = item.content { return a }
        return nil
    }

    var body: some View {
        guard let app = app else { return AnyView(EmptyView()) }
        return AnyView(
            VStack(alignment: .leading, spacing: 0) {
                // Header
                HStack(spacing: Spacing.md) {
                    // App Icon Placeholder
                    AppIconPlaceholder(name: app.name, color: .appPrimary)

                    VStack(alignment: .leading, spacing: 3) {
                        Text(app.name)
                            .font(AppFont.headline())
                            .foregroundColor(.primary)
                            .lineLimit(1)

                        Text(app.developer)
                            .font(AppFont.caption())
                            .foregroundColor(.secondary)

                        HStack(spacing: Spacing.xs) {
                            StarRatingView(rating: app.rating)
                            Text(String(format: "%.1f", app.rating))
                                .font(AppFont.caption2())
                                .foregroundColor(Color(hex: "#F59E0B"))
                            Text("(\(formatCount(app.reviewCount)))")
                                .font(AppFont.caption())
                                .foregroundColor(.secondary)
                        }
                    }

                    Spacer()

                    // Price + Get Button
                    VStack(spacing: Spacing.xs) {
                        Text(app.price)
                            .font(AppFont.caption2())
                            .foregroundColor(.secondary)

                        Button(action: { openAppStore(app.appStoreURL) }) {
                            Text("获取")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundColor(.appPrimary)
                                .frame(width: 72, height: 30)
                                .background(Color.appPrimary.opacity(0.12))
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(Spacing.lg)

                Divider()
                    .padding(.horizontal, Spacing.lg)

                // Description
                Text(app.description)
                    .font(AppFont.subheadline())
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .padding(.horizontal, Spacing.lg)
                    .padding(.vertical, Spacing.md)

                // Tags
                ScrollView(.horizontal, showsScrollIndicators: false) {
                    HStack(spacing: Spacing.sm) {
                        ForEach(app.tags, id: \.self) { tag in
                            TagChip(text: "#\(tag)", color: .appPrimary)
                        }
                    }
                    .padding(.horizontal, Spacing.lg)
                    .padding(.bottom, Spacing.lg)
                }

                // Source bar
                SourceBar(source: "来自小红书", subscriptionTitle: subscriptionTitle, publishedAt: item.publishedAt)
            }
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: Radius.xl))
            .cardShadow()
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
            .onTapGesture { openAppStore(app.appStoreURL) }
            .onLongPressGesture(minimumDuration: 0, maximumDistance: 50,
                pressing: { isPressed = $0 }, perform: {})
        )
    }

    private func openAppStore(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }

    private func formatCount(_ count: Int) -> String {
        if count >= 10000 { return "\(count / 10000)万" }
        if count >= 1000 { return "\(count / 1000)k" }
        return "\(count)"
    }
}

// MARK: - App Icon Placeholder

struct AppIconPlaceholder: View {
    let name: String
    let color: Color

    // Generate consistent gradient from name
    private var gradient: LinearGradient {
        let colors = [
            [Color(hex: "#6366F1"), Color(hex: "#8B5CF6")],
            [Color(hex: "#F59E0B"), Color(hex: "#EF4444")],
            [Color(hex: "#10B981"), Color(hex: "#06B6D4")],
            [Color(hex: "#EC4899"), Color(hex: "#8B5CF6")],
            [Color(hex: "#3B82F6"), Color(hex: "#6366F1")]
        ]
        let idx = abs(name.hashValue) % colors.count
        return LinearGradient(colors: colors[idx], startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(gradient)
                .frame(width: 60, height: 60)

            Text(String(name.prefix(1)))
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
    }
}

// MARK: - Source Bar

struct SourceBar: View {
    let source: String
    let subscriptionTitle: String
    let publishedAt: Date

    var body: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "circle.fill")
                .font(.system(size: 6))
                .foregroundColor(.appPrimary)

            Text(subscriptionTitle)
                .font(AppFont.caption2())
                .foregroundColor(.appPrimary)
                .fontWeight(.medium)

            Text("·")
                .foregroundColor(.secondary)
                .font(AppFont.caption())

            Text(source)
                .font(AppFont.caption())
                .foregroundColor(.secondary)

            Spacer()

            Text(timeAgo(publishedAt))
                .font(AppFont.caption())
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.bottom, Spacing.lg)
    }

    private func timeAgo(_ date: Date) -> String {
        let diff = Int(Date().timeIntervalSince(date))
        if diff < 3600 { return "\(diff / 60)分钟前" }
        if diff < 86400 { return "\(diff / 3600)小时前" }
        return "\(diff / 86400)天前"
    }
}

// MARK: - App Card Compact (for mixed feed)

struct AppCardCompact: View {
    let item: FeedItem
    let subscriptionTitle: String

    private var app: AppContent? {
        if case .app(let a) = item.content { return a }
        return nil
    }

    var body: some View {
        guard let app = app else { return AnyView(EmptyView()) }
        return AnyView(
            HStack(spacing: Spacing.md) {
                AppIconPlaceholder(name: app.name, color: .appPrimary)

                VStack(alignment: .leading, spacing: 4) {
                    Text(app.name)
                        .font(AppFont.headline())
                        .lineLimit(1)
                    Text(app.description)
                        .font(AppFont.subheadline())
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    HStack {
                        StarRatingView(rating: app.rating)
                        Text(String(format: "%.1f", app.rating))
                            .font(AppFont.caption2())
                            .foregroundColor(Color(hex: "#F59E0B"))
                    }
                }

                Spacer()

                VStack(spacing: 4) {
                    Text(app.price)
                        .font(AppFont.caption())
                        .foregroundColor(.secondary)
                    Button(action: {
                        if let url = URL(string: app.appStoreURL) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("获取")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.appPrimary)
                            .frame(width: 60, height: 26)
                            .background(Color.appPrimary.opacity(0.1))
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(Spacing.lg)
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
            .cardShadow()
        )
    }
}
