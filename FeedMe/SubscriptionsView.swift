import SwiftUI

struct SubscriptionsView: View {
    @EnvironmentObject var state: AppState

    var available: [SubTemplate] {
        AppData.templates.filter { t in !state.subs.contains { $0.template == t } }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                // Header
                VStack(alignment: .leading, spacing: 4) {
                    Text("我的订阅")
                        .font(.system(size: 26, weight: .heavy, design: .rounded))
                        .foregroundColor(Color(hex: "#1A1A2E"))
                    Text("\(state.subs.count) 个活跃订阅")
                        .font(.system(size: 13))
                        .foregroundColor(Color(hex: "#ADB5BD"))
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .padding(.bottom, 16)

                // Active subs
                if state.subs.isEmpty {
                    EmptySubs()
                } else {
                    ForEach(state.subs) { sub in
                        SubRow(sub: sub)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 10)
                    }
                }

                // Recommended
                if !available.isEmpty {
                    Text("💡 推荐订阅")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color(hex: "#1A1A2E"))
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                        .padding(.bottom, 12)

                    ForEach(available) { t in
                        SuggestRow(template: t)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 8)
                    }
                }

                Color.clear.frame(height: 110)
            }
        }
        .background(Color(hex: "#F7F8FC"))
    }
}

// MARK: - Sub Row

struct SubRow: View {
    let sub: UserSub
    @EnvironmentObject var state: AppState
    @State private var pressed = false

    var count: Int { state.cards.filter { $0.subKey == sub.template.id }.count }

    var body: some View {
        Button {
            state.filter = sub.template.id
            state.tab = 0
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(sub.template.color.opacity(0.12))
                        .frame(width: 54, height: 54)
                    Text(sub.template.icon)
                        .font(.system(size: 26))
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(sub.template.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(hex: "#1A1A2E"))
                    Text(sub.template.desc)
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#ADB5BD"))
                    Text("\(count) 条内容 · \(sub.template.src)")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(sub.template.color)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "#CED4DA"))
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(sub.template.color.opacity(0.15), lineWidth: 1.5))
            .shadow(color: .black.opacity(0.06), radius: 14, x: 0, y: 2)
            .scaleEffect(pressed ? 0.97 : 1)
        }
        .buttonStyle(.plain)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: 50, pressing: { pressed = $0 }, perform: {})
        .contextMenu {
            Button(role: .destructive) {
                withAnimation { state.removeSub(sub) }
            } label: {
                Label("删除订阅", systemImage: "trash")
            }
        }
    }
}

// MARK: - Suggest Row

struct SuggestRow: View {
    let template: SubTemplate
    @EnvironmentObject var state: AppState
    @State private var pressed = false

    var body: some View {
        Button {
            state.addSub(template)
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(template.color.opacity(0.12))
                        .frame(width: 42, height: 42)
                    Text(template.icon).font(.system(size: 20))
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(template.name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex: "#1A1A2E"))
                    Text(template.src)
                        .font(.system(size: 11))
                        .foregroundColor(Color(hex: "#ADB5BD"))
                }
                Spacer()
                Text("订阅")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 13)
                    .padding(.vertical, 5)
                    .background(template.color)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color(hex: "#F7F8FC"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "#F0F1F5"), lineWidth: 1))
            .scaleEffect(pressed ? 0.97 : 1)
        }
        .buttonStyle(.plain)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: 50, pressing: { pressed = $0 }, perform: {})
    }
}

// MARK: - Empty

struct EmptySubs: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        VStack(spacing: 16) {
            Text("◎").font(.system(size: 56))
            Text("还没有订阅")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(hex: "#1A1A2E"))
            Text("去「发现」页添加你感兴趣的内容")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "#ADB5BD"))
            Button {
                withAnimation { state.tab = 1 }
            } label: {
                Text("去发现 →")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 26)
                    .padding(.vertical, 11)
                    .background(LinearGradient(colors: [Color(hex: "#7C5CFC"), Color(hex: "#A78BFA")],
                                               startPoint: .leading, endPoint: .trailing))
                    .clipShape(Capsule())
            }
        }
        .padding(.top, 50)
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SubscriptionsView().environmentObject(AppState())
}
