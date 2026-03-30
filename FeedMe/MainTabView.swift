import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        ZStack(alignment: .bottom) {
            // Background gradient — Liquid Glass base
            LinearGradient(
                colors: [Color(hex: "#F0EEFF"), Color(hex: "#EBF4FF"), Color(hex: "#F7F8FC")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Page content — leave room for floating tab bar
            contentView
                .padding(.bottom, 88)

            // Toast
            toastLayer

            // Floating Liquid Glass tab bar
            floatingTabBar
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: state.tab)
        .animation(.spring(response: 0.3), value: state.toast)
    }

    // MARK: - Content

    @ViewBuilder
    private var contentView: some View {
        switch state.tab {
        case 0: HomeView()
        case 1: ChatView()
        default: SubscriptionsView()
        }
    }

    // MARK: - Toast

    @ViewBuilder
    private var toastLayer: some View {
        if !state.toast.isEmpty {
            Text(state.toast)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 22)
                .padding(.vertical, 11)
                .background(.ultraThinMaterial, in: Capsule())
                .background(Color(hex: "#1A1A2E").opacity(0.82), in: Capsule())
                .shadow(color: .black.opacity(0.18), radius: 20, x: 0, y: 6)
                .transition(.move(edge: .top).combined(with: .opacity))
                .padding(.bottom, 120)
                .zIndex(999)
        }
    }

    // MARK: - Floating Tab Bar

    private var floatingTabBar: some View {
        HStack(spacing: 0) {
            TabBarItem(sfSymbol: "house.fill",      label: "首页", idx: 0)
            TabBarItem(sfSymbol: "sparkles",         label: "发现", idx: 1)
            TabBarItem(sfSymbol: "bookmark.fill",    label: "订阅", idx: 2)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background {
            // Liquid Glass effect
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.55),
                                    Color.white.opacity(0.25),
                                    Color(hex: "#7C5CFC").opacity(0.06)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .strokeBorder(
                            LinearGradient(
                                colors: [Color.white.opacity(0.8), Color.white.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
                .shadow(color: Color(hex: "#7C5CFC").opacity(0.12), radius: 24, x: 0, y: 8)
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 20)
    }
}

// MARK: - Tab Bar Item

private struct TabBarItem: View {
    let sfSymbol: String
    let label: String
    let idx: Int
    @EnvironmentObject var state: AppState

    var isActive: Bool { state.tab == idx }

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                state.tab = idx
            }
        } label: {
            VStack(spacing: 4) {
                ZStack {
                    // Active pill background
                    if isActive {
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "#7C5CFC"), Color(hex: "#A78BFA")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 52, height: 30)
                            .shadow(color: Color(hex: "#7C5CFC").opacity(0.45), radius: 10, x: 0, y: 4)
                    }
                    Image(systemName: sfSymbol)
                        .font(.system(size: 16, weight: isActive ? .semibold : .regular))
                        .foregroundColor(isActive ? .white : Color(hex: "#ADB5BD"))
                        .scaleEffect(isActive ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3), value: isActive)
                }
                .frame(width: 52, height: 30)

                Text(label)
                    .font(.system(size: 10, weight: isActive ? .bold : .medium))
                    .foregroundColor(isActive ? Color(hex: "#7C5CFC") : Color(hex: "#ADB5BD"))
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MainTabView().environmentObject(AppState())
}
