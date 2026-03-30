import SwiftUI

// MARK: - Event Card (Full)

struct EventCardView: View {
    let item: FeedItem
    let subscriptionTitle: String
    @State private var isPressed = false

    private var event: EventContent? {
        if case .event(let e) = item.content { return e }
        return nil
    }

    var body: some View {
        guard let event = event else { return AnyView(EmptyView()) }
        return AnyView(
            VStack(alignment: .leading, spacing: 0) {
                // Cover Image Area
                EventCoverView(event: event)

                // Content
                VStack(alignment: .leading, spacing: Spacing.md) {
                    // Title
                    Text(event.title)
                        .font(AppFont.title3())
                        .foregroundColor(.primary)

                    // Meta info
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        EventMetaRow(icon: "calendar", text: "\(event.date)  \(event.time)")
                        EventMetaRow(icon: "mappin.and.ellipse", text: event.location)
                        EventMetaRow(icon: "person.2", text: "\(event.attendeeCount) 人感兴趣")
                    }

                    // Description
                    Text(event.description)
                        .font(AppFont.subheadline())
                        .foregroundColor(.secondary)
                        .lineLimit(3)

                    // Tags
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: Spacing.sm) {
                            ForEach(event.tags, id: \.self) { tag in
                                TagChip(text: "#\(tag)", color: Color(hex: "#F59E0B"))
                            }
                        }
                    }

                    // CTA
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("票价")
                                .font(AppFont.caption())
                                .foregroundColor(.secondary)
                            Text(event.price)
                                .font(AppFont.headline())
                                .foregroundColor(event.price == "免费" ? .appGreen : .primary)
                        }

                        Spacer()

                        Button(action: { openURL(event.signupURL) }) {
                            HStack(spacing: Spacing.xs) {
                                Text("立即报名")
                                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 13, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, Spacing.xl)
                            .padding(.vertical, Spacing.md)
                            .background(
                                LinearGradient(
                                    colors: [Color(hex: "#F59E0B"), Color(hex: "#EF4444")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(Capsule())
                        }
                    }
                }
                .padding(Spacing.lg)

                SourceBar(source: "来自小红书", subscriptionTitle: subscriptionTitle, publishedAt: item.publishedAt)
            }
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: Radius.xl))
            .cardShadow()
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        )
    }

    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Event Cover

struct EventCoverView: View {
    let event: EventContent

    private var gradient: LinearGradient {
        LinearGradient(
            colors: [Color(hex: "#F59E0B").opacity(0.8), Color(hex: "#EF4444").opacity(0.9)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background gradient (real app would use AsyncImage)
            Rectangle()
                .fill(gradient)
                .frame(height: 160)
                .overlay(
                    // Decorative pattern
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.05))
                            .frame(width: 200, height: 200)
                            .offset(x: 80, y: -50)
                        Circle()
                            .fill(.white.opacity(0.05))
                            .frame(width: 140, height: 140)
                            .offset(x: -30, y: 40)
                    }
                )

            // Date Badge
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "calendar.circle.fill")
                        .font(.system(size: 14))
                    Text(event.date)
                        .font(AppFont.footnote().weight(.semibold))
                }
                .foregroundColor(.white)

                HStack(spacing: Spacing.xs) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 12))
                    Text(event.time)
                        .font(AppFont.caption())
                }
                .foregroundColor(.white.opacity(0.85))
            }
            .padding(Spacing.md)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: Radius.md))
            .padding(Spacing.md)

            // City Badge
            HStack {
                Spacer()
                Text(event.city)
                    .font(AppFont.caption2())
                    .foregroundColor(.white)
                    .padding(.horizontal, Spacing.sm)
                    .padding(.vertical, Spacing.xs)
                    .background(.black.opacity(0.3))
                    .clipShape(Capsule())
                    .padding(Spacing.md)
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .frame(height: 160)
        .clipped()
    }
}

// MARK: - Preview

#Preview("活动卡片") {
    ScrollView {
        EventCardView(
            item: MockData.eventItems[0],
            subscriptionTitle: "深圳周末活动"
        )
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}

// MARK: - Event Meta Row

struct EventMetaRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundColor(Color(hex: "#F59E0B"))
                .frame(width: 18)

            Text(text)
                .font(AppFont.subheadline())
                .foregroundColor(.secondary)
        }
    }
}
