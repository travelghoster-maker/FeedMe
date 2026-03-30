import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        ZStack(alignment: .bottom) {
            // Content
            Group {
                switch state.tab {
                case 0: HomeView()
                case 1: ChatView()
                case 2: SubscriptionsView()
                default: HomeView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Toast
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

            // Bottom nav
            VStack(spacing: 0) {
                Divider()
                HStack(spacing: 0) {
                    ForEach([
                        (0, "⊞", "首页"),
                        (1, "✦", "发现"),
                        (2, "◎", "订阅"),
                    ], id: \.0) { idx, icon, label in
                        Button {
                            withAnimation(.spring(response: 0.3)) { state.tab = idx }
                        } label: {
                            VStack(spacing: 3) {
                                Text(icon)
                                    .font(.system(size: 22))
                                    .opacity(state.tab == idx ? 1 : 0.3)
                                Text(label)
                                    .font(.system(size: 11, weight: state.tab == idx ? .heavy : .medium))
                                    .foregroundColor(state.tab == idx ? Color(hex: "#7C5CFC") : Color(hex: "#ADB5BD"))
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 24)
                            .background(state.tab == idx ? Color(hex: "#7C5CFC").opacity(0.07) : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 8)
                .frame(height: 76)
                .background(Color.white)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .animation(.spring(response: 0.3), value: state.toast)
    }
}

#Preview {
    MainTabView().environmentObject(AppState())
}
