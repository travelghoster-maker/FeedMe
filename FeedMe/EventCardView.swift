import SwiftUI

struct EventCardView: View {
    let card: EventCard
    @State private var pressed = false

    var body: some View {
        Button {
            if let url = URL(string: card.url) { UIApplication.shared.open(url) }
        } label: {
            VStack(spacing: 0) {
                // Gradient header
                ZStack(alignment: .topTrailing) {
                    LinearGradient(colors: card.gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing)

                    // Tag badge
                    Text(card.tag)
                        .font(.system(size: 10, weight: .heavy))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 3)
                        .background(card.tagColor)
                        .clipShape(Capsule())
                        .padding(12)

                    VStack(alignment: .leading, spacing: 3) {
                        Spacer()
                        Text(card.emoji)
                            .font(.system(size: 38))
                            .padding(.bottom, 8)
                        Text(card.title)
                            .font(.system(size: 18, weight: .heavy))
                            .foregroundColor(.white)
                        Text(card.category)
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                }
                .frame(height: 150)

                // Body
                VStack(alignment: .leading, spacing: 10) {
                    // Meta grid
                    HStack(spacing: 8) {
                        MetaBox(label: "📅 时间", main: card.date, sub: card.time)
                        MetaBox(label: "📍 地点", main: card.place, sub: card.district)
                    }

                    // Desc
                    Text(card.desc)
                        .font(.system(size: 13))
                        .foregroundColor(Color(hex: "#6C757D"))
                        .lineSpacing(4)

                    // Footer
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(card.price)
                                .font(.system(size: 17, weight: .heavy))
                                .foregroundColor(Color(hex: "#1A1A2E"))
                            Text(card.seats)
                                .font(.system(size: 11))
                                .foregroundColor(Color(hex: "#ADB5BD"))
                        }
                        Spacer()
                        Text("立即报名 ↗")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 22)
                            .padding(.vertical, 9)
                            .background(
                                LinearGradient(colors: [Color(hex: "#7C5CFC"), Color(hex: "#A78BFA")],
                                               startPoint: .leading, endPoint: .trailing)
                            )
                            .clipShape(Capsule())
                    }
                }
                .padding(14)
                .background(Color.white)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.11), radius: 24, x: 0, y: 4)
            .scaleEffect(pressed ? 0.97 : 1)
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: 50, pressing: { pressed = $0 }, perform: {})
    }
}

// MARK: - Meta Box

struct MetaBox: View {
    let label: String
    let main: String
    let sub: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(Color(hex: "#CED4DA"))
            Text(main)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(Color(hex: "#1A1A2E"))
                .lineLimit(1)
            Text(sub)
                .font(.system(size: 11))
                .foregroundColor(Color(hex: "#ADB5BD"))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 9)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "#F7F8FC"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    ScrollView {
        EventCardView(card: AppData.mockCards["events-shenzhen"]!.compactMap {
            if case .event(let e) = $0.content { return e } else { return nil }
        }.first!)
        .padding(.vertical, 8)
    }
    .background(Color(hex: "#F7F8FC"))
}
