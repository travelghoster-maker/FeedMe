import SwiftUI

struct EventCardView: View {
    let card: EventCard

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Hero banner — Liquid Glass gradient
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 0)
                    .fill(
                        LinearGradient(
                            colors: card.gradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 120)
                    .overlay(
                        // Frosted glass shimmer
                        LinearGradient(
                            colors: [Color.white.opacity(0.25), Color.clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                // Emoji + tag row
                HStack(alignment: .bottom) {
                    Text(card.emoji)
                        .font(.system(size: 48))
                        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                    Spacer()
                    Text(card.tag)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(card.tagColor, in: Capsule())
                        .shadow(color: card.tagColor.opacity(0.5), radius: 8, x: 0, y: 3)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 14)
            }
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 24, bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0, topTrailingRadius: 24
                )
            )

            // Info block
            VStack(alignment: .leading, spacing: 10) {
                // Title
                Text(card.title)
                    .font(.system(size: 17, weight: .heavy, design: .rounded))
                    .foregroundColor(Color(hex: "#1A1A2E"))

                // Category badge
                Text(card.category)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(card.gradientColors.first ?? .purple)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background((card.gradientColors.first ?? .purple).opacity(0.12), in: Capsule())

                // Detail rows
                VStack(alignment: .leading, spacing: 7) {
                    EventDetailRow(icon: "calendar", text: card.date)
                    EventDetailRow(icon: "clock", text: card.time)
                    EventDetailRow(icon: "mappin.and.ellipse", text: "\(card.place)  ·  \(card.district)")
                    EventDetailRow(icon: "person.2", text: card.seats)
                }

                // Divider
                Rectangle()
                    .fill(Color(hex: "#E9ECEF").opacity(0.8))
                    .frame(height: 1)

                // Description
                Text(card.desc)
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "#636E72"))
                    .lineSpacing(5)

                // Price + CTA
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("票价")
                            .font(.system(size: 11))
                            .foregroundColor(Color(hex: "#ADB5BD"))
                        Text(card.price)
                            .font(.system(size: 20, weight: .heavy, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: card.gradientColors,
                                    startPoint: .leading, endPoint: .trailing
                                )
                            )
                    }
                    Spacer()
                    Link(destination: URL(string: card.url)!) {
                        HStack(spacing: 6) {
                            Image(systemName: "ticket.fill")
                                .font(.system(size: 13, weight: .semibold))
                            Text("立即报名")
                                .font(.system(size: 13, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 22)
                        .padding(.vertical, 11)
                        .background(
                            LinearGradient(
                                colors: card.gradientColors,
                                startPoint: .leading, endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                        .shadow(color: (card.gradientColors.first ?? .purple).opacity(0.4), radius: 12, x: 0, y: 5)
                    }
                }
            }
            .padding(16)
        }
        .background {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.65), Color.white.opacity(0.25)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.65), lineWidth: 1)
                )
                .shadow(color: (card.gradientColors.first ?? .purple).opacity(0.12), radius: 20, x: 0, y: 6)
                .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding(.horizontal, 20)
    }
}

// MARK: - Detail Row

struct EventDetailRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(Color(hex: "#7C5CFC"))
                .frame(width: 16)
            Text(text)
                .font(.system(size: 13))
                .foregroundColor(Color(hex: "#495057"))
        }
    }
}

#Preview {
    EventCardView(card: EventCard(
        title: "深圳艺术周 2026", category: "艺术展览", emoji: "🎨",
        gradientColors: [Color(hex: "#667eea"), Color(hex: "#764ba2")],
        date: "4月3日 — 4月10日", time: "10:00 – 20:00",
        place: "坪山美术馆", district: "坪山区",
        price: "免费", seats: "每日限500人",
        tag: "热门", tagColor: Color(hex: "#E17055"),
        desc: "汇聚20+国际艺术家，探索科技与艺术边界，深圳最具影响力的当代艺术年度盛宴。",
        url: "https://www.szmoa.org", src: "小红书"
    ))
    .environmentObject(AppState())
    .padding(.vertical)
    .background(Color(hex: "#F0EEFF"))
}
