import SwiftUI

struct EventCardView: View {
    let card: EventCard

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Gradient hero
            ZStack(alignment: .bottomLeading) {
                LinearGradient(
                    colors: card.gradientColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 100)
                .overlay(Color.white.opacity(0.08))

                HStack(alignment: .bottom) {
                    Text(card.emoji)
                        .font(.system(size: 40))
                    Spacer()
                    Text(card.tag)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(.white.opacity(0.2), in: Capsule())
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            }
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 20, bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0, topTrailingRadius: 20
                )
            )

            // Info
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(card.category.uppercased())
                        .font(.system(size: 10, weight: .semibold))
                        .tracking(0.8)
                        .foregroundColor(.black.opacity(0.3))
                    Text(card.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black.opacity(0.88))
                }

                // Detail pills
                VStack(alignment: .leading, spacing: 6) {
                    EvtRow(icon: "calendar", text: card.date)
                    EvtRow(icon: "mappin", text: "\(card.place)  \(card.district)")
                    EvtRow(icon: "person.2", text: card.seats)
                }

                Rectangle()
                    .fill(.black.opacity(0.05))
                    .frame(height: 1)

                Text(card.desc)
                    .font(.system(size: 13))
                    .foregroundColor(.black.opacity(0.5))
                    .lineSpacing(5)

                // Price + CTA
                HStack {
                    VStack(alignment: .leading, spacing: 1) {
                        Text("票价")
                            .font(.system(size: 11))
                            .foregroundColor(.black.opacity(0.3))
                        Text(card.price)
                            .font(.system(size: 22, weight: .heavy))
                            .foregroundColor(.black.opacity(0.88))
                    }
                    Spacer()
                    Link(destination: URL(string: card.url)!) {
                        Text("立即报名")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 22)
                            .padding(.vertical, 11)
                            .background(
                                LinearGradient(
                                    colors: card.gradientColors,
                                    startPoint: .leading, endPoint: .trailing
                                ),
                                in: Capsule()
                            )
                    }
                }
            }
            .padding(16)
        }
        .background {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white.opacity(0.75))
                .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 4)
                .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .padding(.horizontal, 20)
    }
}

struct EvtRow: View {
    let icon: String
    let text: String
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 11))
                .foregroundColor(.black.opacity(0.3))
                .frame(width: 14)
            Text(text)
                .font(.system(size: 13))
                .foregroundColor(.black.opacity(0.55))
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
        desc: "汇聚20+国际艺术家，探索科技与艺术边界。",
        url: "https://www.szmoa.org", src: "小红书"
    ))
    .padding(.vertical)
    .background(Color(hex: "#F5F4F0"))
}
