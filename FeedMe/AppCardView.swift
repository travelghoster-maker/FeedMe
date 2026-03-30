import SwiftUI

struct AppCardView: View {
    let card: AppCard

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 14) {
                // App Icon — Liquid Glass circle
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .overlay(
                            Circle().fill(
                                LinearGradient(
                                    colors: [card.color.opacity(0.3), card.color.opacity(0.12)],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                )
                            )
                        )
                        .overlay(Circle().strokeBorder(Color.white.opacity(0.7), lineWidth: 1))
                        .frame(width: 56, height: 56)
                        .shadow(color: card.color.opacity(0.25), radius: 10, x: 0, y: 4)

                    Text(card.icon)
                        .font(.system(size: 26))
                }

                // Info
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(card.name)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(hex: "#1A1A2E"))
                            .lineLimit(1)
                        Spacer()
                        // Tag chip
                        Text(card.tag)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(card.color)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(card.color.opacity(0.12), in: Capsule())
                    }
                    Text(card.category)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(hex: "#ADB5BD"))

                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundColor(Color(hex: "#FDCB6E"))
                        Text(String(format: "%.1f", card.rating))
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color(hex: "#636E72"))
                        Text("·")
                            .foregroundColor(Color(hex: "#CED4DA"))
                        Text(card.ratingCount)
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "#ADB5BD"))
                        Spacer()
                        Text(card.price)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(card.price == "免费" ? Color(hex: "#00B894") : Color(hex: "#1A1A2E"))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)

            // Divider line
            Rectangle()
                .fill(Color(hex: "#E9ECEF").opacity(0.8))
                .frame(height: 1)
                .padding(.horizontal, 16)

            // Description
            Text(card.desc)
                .font(.system(size: 13))
                .foregroundColor(Color(hex: "#636E72"))
                .lineSpacing(5)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)

            // CTA button
            HStack {
                Spacer()
                Link(destination: URL(string: card.url)!) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.up.right.square")
                            .font(.system(size: 13, weight: .semibold))
                        Text("在 App Store 查看")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        LinearGradient(
                            colors: [card.color, card.color.opacity(0.75)],
                            startPoint: .leading, endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                    .shadow(color: card.color.opacity(0.35), radius: 10, x: 0, y: 4)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.7), Color.white.opacity(0.3)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.7), lineWidth: 1)
                )
                .shadow(color: Color(hex: "#7C5CFC").opacity(0.08), radius: 20, x: 0, y: 6)
                .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    AppCardView(card: AppCard(
        name: "Lasso", category: "效率 · 收藏",
        icon: "🔗", color: Color(hex: "#7C5CFC"),
        rating: 4.8, ratingCount: "2.1k", price: "免费", tag: "小众精品",
        desc: "极简主义书签 App，一键收藏网页、图片、文字，视觉化管理灵感库。界面干净如诗。",
        url: "https://apps.apple.com", src: "小红书精选"
    ))
    .environmentObject(AppState())
    .padding(.vertical)
    .background(Color(hex: "#F0EEFF"))
}
