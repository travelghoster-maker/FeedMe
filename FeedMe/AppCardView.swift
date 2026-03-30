import SwiftUI

struct AppCardView: View {
    let card: AppCard
    @State private var pressed = false

    var ctaLabel: String {
        switch card.price {
        case "免费": return "免费下载 ↗"
        case "免费内购": return "免费获取 ↗"
        default:
            if card.price.contains("人均") { return "查看地图 ↗" }
            return "\(card.price) ↗"
        }
    }

    var body: some View {
        Button {
            if let url = URL(string: card.url) { UIApplication.shared.open(url) }
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                // Top row
                HStack(alignment: .top, spacing: 14) {
                    // Icon
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(card.color.opacity(0.12))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(card.color.opacity(0.18), lineWidth: 1.5))
                            .frame(width: 62, height: 62)
                        Text(card.icon)
                            .font(.system(size: 28))
                    }

                    // Meta
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(alignment: .center, spacing: 8) {
                            Text(card.name)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(Color(hex: "#1A1A2E"))
                                .lineLimit(1)
                            Spacer()
                            Text(card.tag)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(card.color)
                                .padding(.horizontal, 9)
                                .padding(.vertical, 2)
                                .background(card.color.opacity(0.12))
                                .clipShape(Capsule())
                        }
                        Text(card.category)
                            .font(.system(size: 11))
                            .foregroundColor(Color(hex: "#ADB5BD"))
                            .padding(.bottom, 3)
                        StarsView(rating: card.rating, count: card.ratingCount)
                    }
                }
                .padding(.bottom, 11)

                // Desc
                Text(card.desc)
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "#6C757D"))
                    .lineSpacing(4)
                    .padding(.bottom, 12)

                // Footer
                HStack {
                    Text("📌 \(card.src)")
                        .font(.system(size: 11))
                        .foregroundColor(Color(hex: "#CED4DA"))
                    Spacer()
                    Text(ctaLabel)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 8)
                        .background(card.color)
                        .clipShape(Capsule())
                }
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(hex: "#F0F1F5"), lineWidth: 1))
            .shadow(color: .black.opacity(0.07), radius: 18, x: 0, y: 2)
            .scaleEffect(pressed ? 0.97 : 1)
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: 50, pressing: { pressed = $0 }, perform: {})
    }
}

// MARK: - Stars

struct StarsView: View {
    let rating: Double
    let count: String

    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<5, id: \.self) { i in
                Image(systemName: Double(i) + 1 <= rating ? "star.fill" : "star")
                    .font(.system(size: 11))
                    .foregroundColor(Double(i) + 1 <= rating ? Color(hex: "#F59F00") : Color(hex: "#ddd"))
            }
            Text(String(format: "%.1f", rating))
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(hex: "#F59F00"))
            Text("(\(count))")
                .font(.system(size: 11))
                .foregroundColor(Color(hex: "#ADB5BD"))
        }
    }
}

#Preview {
    ScrollView {
        AppCardView(card: AppData.mockCards["app-design"]!.compactMap {
            if case .app(let a) = $0.content { return a } else { return nil }
        }.first!)
        .padding(.vertical, 8)
    }
    .background(Color(hex: "#F7F8FC"))
}
