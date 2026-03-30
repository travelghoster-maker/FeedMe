import SwiftUI

struct HomeView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                // Header
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 0) {
                        Text("你的 ")
                            .font(.system(size: 26, weight: .heavy, design: .rounded))
                            .foregroundColor(Color(hex: "#1A1A2E"))
                        Text("Feed")
                            .font(.system(size: 26, weight: .heavy, design: .rounded))
                            .foregroundColor(Color(hex: "#7C5CFC"))
                    }
                    Text(state.cards.isEmpty
                         ? "还没有订阅，去「发现」页添加吧"
                         : "\(state.cards.count) 条最新内容，持续更新中")
                        .font(.system(size: 13))
                        .foregroundColor(Color(hex: "#ADB5BD"))
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .padding(.bottom, 14)

                // Filter pills
                if !state.subs.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            FilterPill(label: "全部", active: state.filter == nil, color: Color(hex: "#1A1A2E")) {
                                withAnimation(.spring(response: 0.3)) { state.filter = nil }
                            }
                            ForEach(state.subs) { sub in
                                FilterPill(
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
                        .padding(.horizontal, 16)
                        .padding(.bottom, 4)
                    }
                    .padding(.bottom, 12)
                }

                // Cards
                if state.filteredCards.isEmpty {
                    EmptyHome()
                } else {
                    LazyVStack(spacing: 0) {
                        ForEach(state.filteredCards) { card in
                            VStack(alignment: .leading, spacing: 6) {
                                // Sub label
                                HStack(spacing: 5) {
                                    Text(card.subIcon)
                                        .font(.system(size: 13))
                                    Text(card.subName)
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundColor(Color(hex: "#CED4DA"))
                                }
                                .padding(.horizontal, 16)

                                switch card.content {
                                case .app(let a):   AppCardView(card: a)
                                case .event(let e): EventCardView(card: e)
                                }
                            }
                            .padding(.bottom, 16)
                        }
                    }
                }

                Color.clear.frame(height: 20)
            }
        }
        .background(Color(hex: "#F7F8FC"))
    }
}

// MARK: - Filter Pill

struct FilterPill: View {
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
                .padding(.vertical, 6)
                .background(active ? color : Color.white)
                .overlay(
                    Capsule().stroke(active ? color : color.opacity(0.35), lineWidth: 1.5)
                )
                .clipShape(Capsule())
        }
    }
}

// MARK: - Empty State

struct EmptyHome: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        VStack(spacing: 16) {
            Text("✦")
                .font(.system(size: 56))
            Text("还没有内容")
                .font(.system(size: 20, weight: .heavy, design: .rounded))
                .foregroundColor(Color(hex: "#1A1A2E"))
            Text("去「发现」页告诉我你的兴趣\n我来帮你追踪和整理内容")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "#ADB5BD"))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
            Button {
                withAnimation { state.tab = 1 }
            } label: {
                Text("开始订阅 →")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(colors: [Color(hex: "#7C5CFC"), Color(hex: "#A78BFA")],
                                       startPoint: .leading, endPoint: .trailing)
                    )
                    .clipShape(Capsule())
            }
        }
        .padding(.top, 60)
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    HomeView().environmentObject(AppState())
}
