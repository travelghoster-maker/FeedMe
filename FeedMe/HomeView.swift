import SwiftUI

struct HomeView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                headerSection
                if !state.subs.isEmpty { filterSection }
                cardSection
                Color.clear.frame(height: 16)
            }
        }
        .background(Color.clear)
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text("你的 ")
                    .font(.system(size: 28, weight: .heavy, design: .rounded))
                    .foregroundColor(Color(hex: "#1A1A2E"))
                Text("Feed")
                    .font(.system(size: 28, weight: .heavy, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "#7C5CFC"), Color(hex: "#A78BFA")],
                            startPoint: .leading, endPoint: .trailing
                        )
                    )
                Spacer()
                // Refresh indicator chip
                HStack(spacing: 5) {
                    Circle()
                        .fill(Color(hex: "#00B894"))
                        .frame(width: 6, height: 6)
                    Text("实时更新")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Color(hex: "#00B894"))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color(hex: "#00B894").opacity(0.1), in: Capsule())
            }
            Text(state.cards.isEmpty
                 ? "还没有订阅，去「发现」页添加吧"
                 : "\(state.cards.count) 条内容，持续更新中")
                .font(.system(size: 13))
                .foregroundColor(Color(hex: "#ADB5BD"))
        }
        .padding(.horizontal, 20)
        .padding(.top, 56)
        .padding(.bottom, 16)
    }

    // MARK: - Filter Pills

    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                LiquidPill(label: "全部", active: state.filter == nil, color: Color(hex: "#1A1A2E")) {
                    withAnimation(.spring(response: 0.3)) { state.filter = nil }
                }
                ForEach(state.subs) { sub in
                    LiquidPill(
                        label: "\(sub.template.icon) \(sub.template.name)",
                        active: state.filter == sub.template.id,
                        color: sub.template.color
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            state.filter = state.filter == sub.template.id ? nil : sub.template.id
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 4)
        }
        .padding(.bottom, 16)
    }

    // MARK: - Cards

    @ViewBuilder
    private var cardSection: some View {
        if state.filteredCards.isEmpty {
            EmptyHome()
        } else {
            LazyVStack(spacing: 0) {
                ForEach(state.filteredCards) { card in
                    VStack(alignment: .leading, spacing: 6) {
                        // Source label
                        HStack(spacing: 5) {
                            Text(card.subIcon)
                                .font(.system(size: 12))
                            Text(card.subName)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(Color(hex: "#ADB5BD"))
                        }
                        .padding(.horizontal, 20)

                        switch card.content {
                        case .app(let a):   AppCardView(card: a)
                        case .event(let e): EventCardView(card: e)
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

// MARK: - Liquid Glass Pill

struct LiquidPill: View {
    let label: String
    let active: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(active ? .white : color)
                .padding(.horizontal, 16)
                .padding(.vertical, 7)
                .background {
                    if active {
                        Capsule()
                            .fill(color)
                            .shadow(color: color.opacity(0.4), radius: 8, x: 0, y: 4)
                    } else {
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .overlay(
                                Capsule()
                                    .fill(color.opacity(0.08))
                            )
                            .overlay(
                                Capsule()
                                    .strokeBorder(color.opacity(0.25), lineWidth: 1)
                            )
                    }
                }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Empty State

struct EmptyHome: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        VStack(spacing: 20) {
            // Liquid glass icon card
            ZStack {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "#7C5CFC").opacity(0.15), Color(hex: "#A78BFA").opacity(0.08)],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                )
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .strokeBorder(Color.white.opacity(0.6), lineWidth: 1)
                    )
                    .frame(width: 88, height: 88)
                    .shadow(color: Color(hex: "#7C5CFC").opacity(0.2), radius: 20, x: 0, y: 8)

                Image(systemName: "sparkles")
                    .font(.system(size: 36, weight: .light))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "#7C5CFC"), Color(hex: "#A78BFA")],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
            }

            VStack(spacing: 8) {
                Text("还没有内容")
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .foregroundColor(Color(hex: "#1A1A2E"))
                Text("去「发现」页告诉我你的兴趣\n我来帮你追踪和整理内容")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#ADB5BD"))
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
            }

            Button {
                withAnimation { state.tab = 1 }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 14, weight: .semibold))
                    Text("开始订阅")
                        .font(.system(size: 15, weight: .bold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        colors: [Color(hex: "#7C5CFC"), Color(hex: "#A78BFA")],
                        startPoint: .leading, endPoint: .trailing
                    )
                )
                .clipShape(Capsule())
                .shadow(color: Color(hex: "#7C5CFC").opacity(0.4), radius: 16, x: 0, y: 6)
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 60)
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    HomeView().environmentObject(AppState())
}
