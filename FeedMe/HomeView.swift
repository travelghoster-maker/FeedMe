import SwiftUI

struct HomeView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        ZStack {
            // Soft gradient background — like Nike / Dot style
            MeshBackground()
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    headerSection
                    if !state.subs.isEmpty { filterSection }
                    cardSection
                    Color.clear.frame(height: 120)
                }
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("你的")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.black.opacity(0.35))
                .padding(.top, 60)

            HStack(alignment: .lastTextBaseline, spacing: 0) {
                Text("Feed")
                    .font(.system(size: 52, weight: .heavy, design: .default))
                    .foregroundColor(.black.opacity(0.88))
                Text(".")
                    .font(.system(size: 52, weight: .heavy))
                    .foregroundColor(Color(hex: "#7C5CFC"))
            }

            if !state.cards.isEmpty {
                Text("\(state.cards.count) 条内容，持续更新中")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.black.opacity(0.3))
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
    }

    // MARK: - Filter Pills

    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                MinimalPill(label: "全部", active: state.filter == nil) {
                    withAnimation(.spring(response: 0.3)) { state.filter = nil }
                }
                ForEach(state.subs) { sub in
                    MinimalPill(
                        label: "\(sub.template.icon) \(sub.template.name)",
                        active: state.filter == sub.template.id
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            state.filter = state.filter == sub.template.id ? nil : sub.template.id
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
        }
        .padding(.bottom, 20)
    }

    // MARK: - Cards

    @ViewBuilder
    private var cardSection: some View {
        if state.filteredCards.isEmpty {
            EmptyHome()
        } else {
            LazyVStack(spacing: 16) {
                ForEach(state.filteredCards) { card in
                    VStack(alignment: .leading, spacing: 6) {
                        // Source label
                        HStack(spacing: 5) {
                            Text(card.subIcon)
                                .font(.system(size: 11))
                            Text(card.subName.uppercased())
                                .font(.system(size: 10, weight: .semibold))
                                .tracking(0.8)
                                .foregroundColor(.black.opacity(0.3))
                        }
                        .padding(.horizontal, 24)

                        switch card.content {
                        case .app(let a):   AppCardView(card: a)
                        case .event(let e): EventCardView(card: e)
                        }
                    }
                }
            }
            .padding(.top, 4)
        }
    }
}

// MARK: - Mesh Background

struct MeshBackground: View {
    var body: some View {
        ZStack {
            Color(hex: "#F5F4F0")  // warm off-white base

            // Soft color blobs
            Circle()
                .fill(Color(hex: "#C4B5FD").opacity(0.35))
                .frame(width: 320)
                .blur(radius: 80)
                .offset(x: 100, y: -200)

            Circle()
                .fill(Color(hex: "#FDE68A").opacity(0.2))
                .frame(width: 280)
                .blur(radius: 80)
                .offset(x: -120, y: 100)

            Circle()
                .fill(Color(hex: "#FBCFE8").opacity(0.25))
                .frame(width: 240)
                .blur(radius: 70)
                .offset(x: 60, y: 300)
        }
    }
}

// MARK: - Minimal Pill

struct MinimalPill: View {
    let label: String
    let active: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 13, weight: active ? .semibold : .regular))
                .foregroundColor(active ? .white : .black.opacity(0.55))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background {
                    Capsule()
                        .fill(active ? Color.black.opacity(0.88) : Color.black.opacity(0.06))
                }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Empty State

struct EmptyHome: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("还没有内容")
                    .font(.system(size: 32, weight: .heavy))
                    .foregroundColor(.black.opacity(0.85))
                Text("点击下方 AI 按钮，\n告诉我你想追踪什么。")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.black.opacity(0.4))
                    .lineSpacing(5)
            }

            Button {
                withAnimation { state.tab = 1 }
            } label: {
                Text("开始订阅")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 14)
                    .background(Color.black.opacity(0.88), in: Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 24)
        .padding(.top, 48)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    HomeView().environmentObject(AppState())
}
