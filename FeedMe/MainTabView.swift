import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        // Native TabView handles safe area / content height correctly
        TabView(selection: $state.tab) {
            HomeView()
                .tag(0)
            ChatView()
                .tag(1)
            SubscriptionsView()
                .tag(2)
        }
        // Hide the default system tab bar
        .tabViewStyle(.page(indexDisplayMode: .never))
        // Overlay our Liquid Glass bar on top
        .overlay(alignment: .bottom) {
            VStack(spacing: 0) {
                // Toast
                if !state.toast.isEmpty {
                    Text(state.toast)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 22)
                        .padding(.vertical, 11)
                        .background(.ultraThinMaterial, in: Capsule())
                        .background(Color(hex: "#1A1A2E").opacity(0.82), in: Capsule())
                        .shadow(color: .black.opacity(0.18), radius: 20, x: 0, y: 6)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 12)
                }
                floatingTabBar
            }
            .animation(.spring(response: 0.3), value: state.toast)
            .animation(.spring(response: 0.35, dampingFraction: 0.75), value: state.tab)
        }
        .ignoresSafeArea(edges: .bottom)
    }

    // MARK: - Floating Tab Bar

    private var floatingTabBar: some View {
        HStack(spacing: 0) {
            TabBarBtn(sfSymbol: "house.fill",   label: "首页", idx: 0)
            TabBarBtn(sfSymbol: "sparkles",      label: "发现", idx: 1)
            TabBarBtn(sfSymbol: "bookmark.fill", label: "订阅", idx: 2)
        }
        .padding(.horizontal, 12)
        .padding(.top, 10)
        .padding(.bottom, 10)
        .background {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.6),
                                    Color.white.opacity(0.25),
                                    Color(hex: "#7C5CFC").opacity(0.06),
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
                                colors: [Color.white.opacity(0.85), Color.white.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
                .shadow(color: Color(hex: "#7C5CFC").opacity(0.15), radius: 24, x: 0, y: 8)
                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
        }
        .padding(.horizontal, 28)
        .padding(.bottom, 28)     // safe area buffer
    }
}

// MARK: - Tab Button

private struct TabBarBtn: View {
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
                            .shadow(color: Color(hex: "#7C5CFC").opacity(0.5), radius: 10, x: 0, y: 4)
                    }
                    Image(systemName: sfSymbol)
                        .font(.system(size: 16, weight: isActive ? .semibold : .regular))
                        .foregroundColor(isActive ? .white : Color(hex: "#ADB5BD"))
                        .scaleEffect(isActive ? 1.1 : 1.0)
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
