import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        ZStack(alignment: .bottom) {
            contentView
            toastView
            navBar
        }
        .ignoresSafeArea(edges: .bottom)
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
    private var toastView: some View {
        if !state.toast.isEmpty {
            Text(state.toast)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 22)
                .padding(.vertical, 10)
                .background(Color(hex: "#1A1A2E"))
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.22), radius: 24, x: 0, y: 6)
                .transition(.scale(scale: 0.88).combined(with: .opacity))
                .padding(.bottom, 96)
                .zIndex(999)
        }
    }

    // MARK: - Nav Bar

    private var navBar: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 0) {
                NavItem(icon: "⊞", label: "首页",  idx: 0)
                NavItem(icon: "✦", label: "发现",  idx: 1)
                NavItem(icon: "◎", label: "订阅",  idx: 2)
            }
            .padding(.horizontal, 8)
            .frame(height: 76)
            .background(Color.white)
        }
    }
}

// MARK: - Nav Item

private struct NavItem: View {
    let icon: String
    let label: String
    let idx: Int
    @EnvironmentObject var state: AppState

    var isActive: Bool { state.tab == idx }

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3)) { state.tab = idx }
        } label: {
            VStack(spacing: 3) {
                Text(icon)
                    .font(.system(size: 22))
                    .opacity(isActive ? 1 : 0.3)
                Text(label)
                    .font(.system(size: 11, weight: isActive ? .heavy : .medium))
                    .foregroundColor(isActive ? Color(hex: "#7C5CFC") : Color(hex: "#ADB5BD"))
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 24)
            .background(isActive ? Color(hex: "#7C5CFC").opacity(0.07) : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    MainTabView().environmentObject(AppState())
}
