import SwiftUI

struct AppCardView: View {
    let card: AppCard

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Top row
            HStack(alignment: .center, spacing: 14) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(card.color.opacity(0.15))
                        .frame(width: 52, height: 52)
                    Text(card.icon)
                        .font(.system(size: 24))
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(card.name)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black.opacity(0.88))
                    Text(card.category)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.black.opacity(0.35))
                }

                Spacer()

                // Price button
                Link(destination: URL(string: card.url)!) {
                    Text(card.price == "免费" ? "获取" : card.price)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(card.color)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 7)
                        .background(card.color.opacity(0.12), in: Capsule())
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 18)
            .padding(.bottom, 14)

            // Divider
            Rectangle()
                .fill(.black.opacity(0.05))
                .frame(height: 1)
                .padding(.horizontal, 18)

            // Description
            Text(card.desc)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.black.opacity(0.55))
                .lineSpacing(5)
                .padding(.horizontal, 18)
                .padding(.top, 12)
                .padding(.bottom, 6)

            // Footer
            HStack(spacing: 6) {
                Image(systemName: "star.fill")
                    .font(.system(size: 10))
                    .foregroundColor(Color(hex: "#F59F00"))
                Text(String(format: "%.1f", card.rating))
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.black.opacity(0.4))
                Text("·  \(card.ratingCount) 评分")
                    .font(.system(size: 12))
                    .foregroundColor(.black.opacity(0.3))
                Spacer()
                Text(card.tag)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(card.color.opacity(0.8))
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 16)
        }
        .background {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white.opacity(0.75))
                .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 4)
                .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 1)
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
    .padding(.vertical)
    .background(Color(hex: "#F5F4F0"))
}
