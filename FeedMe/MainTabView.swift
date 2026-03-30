import SwiftUI

// MARK: - AI Input Mode

enum AIInputMode {
    case none       // collapsed — just the tab bar
    case text       // expanded text input
    case voice      // long-press voice bar
}

struct MainTabView: View {
    @EnvironmentObject var state: AppState
    @StateObject private var chatVM = ChatVM()

    @State private var aiMode: AIInputMode = .none
    @State private var inputText: String = ""
    @State private var isProcessing: Bool = false
    @FocusState private var inputFocused: Bool

    var body: some View {
        ZStack(alignment: .bottom) {
            // Pages
            pageContent
                .ignoresSafeArea(edges: .bottom)

            // Toast
            toastBanner

            // Liquid Glass bottom bar — morphs based on aiMode
            bottomBar
        }
        .animation(.spring(response: 0.45, dampingFraction: 0.78), value: aiMode)
        .animation(.spring(response: 0.3), value: state.toast)
    }

    // MARK: - Page Content

    @ViewBuilder
    private var pageContent: some View {
        switch state.tab {
        case 0: HomeView()
        case 2: SubscriptionsView()
        default: HomeView()
        }
    }

    // MARK: - Toast

    @ViewBuilder
    private var toastBanner: some View {
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
                .padding(.bottom, 130)
                .zIndex(100)
        }
    }

    // MARK: - Bottom Bar (morphing)

    @ViewBuilder
    private var bottomBar: some View {
        switch aiMode {
        case .none:    tabBarCapsule
        case .text:    textInputCapsule
        case .voice:   voiceCapsule
        }
    }

    // ── 1. Normal Tab Bar ─────────────────────────────────────────

    private var tabBarCapsule: some View {
        HStack(spacing: 0) {
            // Home
            TabBtn(sfSymbol: "house.fill", label: "首页", active: state.tab == 0) {
                state.tab = 0
            }

            // AI button — center
            aiOrb

            // Subscriptions
            TabBtn(sfSymbol: "bookmark.fill", label: "订阅", active: state.tab == 2) {
                state.tab = 2
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .liquidGlassCapsule()
        .padding(.horizontal, 28)
        .padding(.bottom, 32)
        .transition(.scale(scale: 0.92).combined(with: .opacity))
    }

    // AI orb — tap = text input, long press = voice
    private var aiOrb: some View {
        Button { } label: {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#7C5CFC"), Color(hex: "#A78BFA"), Color(hex: "#C4B5FD")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 52, height: 52)
                    .shadow(color: Color(hex: "#7C5CFC").opacity(0.55), radius: 16, x: 0, y: 6)
                    .overlay(
                        Circle()
                            .strokeBorder(Color.white.opacity(0.4), lineWidth: 1.5)
                    )
                Image(systemName: "sparkles")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
        .simultaneousGesture(
            TapGesture().onEnded {
                withAnimation(.spring(response: 0.42, dampingFraction: 0.75)) {
                    aiMode = .text
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    inputFocused = true
                }
            }
        )
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.5).onEnded { _ in
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                withAnimation(.spring(response: 0.42, dampingFraction: 0.75)) {
                    aiMode = .voice
                }
            }
        )
    }

    // ── 2. Text Input Capsule ─────────────────────────────────────

    private var textInputCapsule: some View {
        HStack(spacing: 12) {
            // Dismiss
            Button {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.78)) {
                    aiMode = .none
                    inputText = ""
                    inputFocused = false
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "#ADB5BD"))
                    .frame(width: 36, height: 36)
                    .background(Color(hex: "#F0EEFF"), in: Circle())
            }
            .buttonStyle(.plain)

            // Text field
            ZStack(alignment: .leading) {
                if inputText.isEmpty {
                    Text("告诉我你想订阅什么…")
                        .font(.system(size: 15))
                        .foregroundColor(Color(hex: "#ADB5BD"))
                }
                TextField("", text: $inputText, axis: .vertical)
                    .font(.system(size: 15))
                    .foregroundColor(Color(hex: "#1A1A2E"))
                    .focused($inputFocused)
                    .lineLimit(1...4)
                    .submitLabel(.send)
                    .onSubmit { sendMessage() }
            }

            // Send / loading
            Button { sendMessage() } label: {
                ZStack {
                    Circle()
                        .fill(
                            inputText.isEmpty
                            ? Color(hex: "#E9ECEF")
                            : LinearGradient(
                                colors: [Color(hex: "#7C5CFC"), Color(hex: "#A78BFA")],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 36, height: 36)
                    if isProcessing {
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(0.75)
                    } else {
                        Image(systemName: "arrow.up")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(inputText.isEmpty ? Color(hex: "#ADB5BD") : .white)
                    }
                }
            }
            .buttonStyle(.plain)
            .disabled(inputText.isEmpty || isProcessing)
            .shadow(color: inputText.isEmpty ? .clear : Color(hex: "#7C5CFC").opacity(0.4),
                    radius: 8, x: 0, y: 3)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .liquidGlassCapsule()
        .padding(.horizontal, 16)
        .padding(.bottom, 32)
        .transition(.scale(scale: 0.92).combined(with: .opacity))
    }

    // ── 3. Voice Capsule ─────────────────────────────────────────

    private var voiceCapsule: some View {
        HStack(spacing: 16) {
            // Cancel
            Button {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.78)) {
                    aiMode = .none
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "#ADB5BD"))
                    .frame(width: 36, height: 36)
                    .background(Color(hex: "#F0EEFF"), in: Circle())
            }
            .buttonStyle(.plain)

            // Waveform visualizer (animated placeholder)
            WaveformView()
                .frame(height: 36)

            // Done / send voice
            Button {
                // TODO: wire real speech-to-text
                withAnimation(.spring(response: 0.4, dampingFraction: 0.78)) {
                    aiMode = .none
                    state.showToast("语音功能即将上线 ✨")
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "#E17055"), Color(hex: "#FF7675")],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 44, height: 44)
                        .shadow(color: Color(hex: "#E17055").opacity(0.5), radius: 12, x: 0, y: 4)
                    Image(systemName: "mic.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .liquidGlassCapsule()
        .padding(.horizontal, 16)
        .padding(.bottom, 32)
        .transition(.scale(scale: 0.92).combined(with: .opacity))
    }

    // MARK: - Send

    private func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        isProcessing = true
        inputText = ""

        // Intent matching → add subscription
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            if let template = AppData.parseIntent(text) {
                state.addSub(template)
                withAnimation(.spring(response: 0.4)) { aiMode = .none }
                state.tab = 0
            } else {
                state.showToast("暂时没认出这个类型，试试「小众App」或「深圳活动」")
                withAnimation(.spring(response: 0.4)) { aiMode = .none }
            }
            isProcessing = false
        }
    }
}

// MARK: - Tab Button

private struct TabBtn: View {
    let sfSymbol: String
    let label: String
    let active: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if active {
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "#7C5CFC"), Color(hex: "#A78BFA")],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 48, height: 28)
                            .shadow(color: Color(hex: "#7C5CFC").opacity(0.45), radius: 8, x: 0, y: 3)
                    }
                    Image(systemName: sfSymbol)
                        .font(.system(size: 15, weight: active ? .semibold : .regular))
                        .foregroundColor(active ? .white : Color(hex: "#ADB5BD"))
                        .scaleEffect(active ? 1.08 : 1.0)
                }
                .frame(width: 48, height: 28)
                Text(label)
                    .font(.system(size: 10, weight: active ? .bold : .medium))
                    .foregroundColor(active ? Color(hex: "#7C5CFC") : Color(hex: "#ADB5BD"))
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Waveform (animated)

struct WaveformView: View {
    @State private var phase: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 3) {
                ForEach(0..<18, id: \.self) { i in
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "#7C5CFC"), Color(hex: "#A78BFA")],
                                startPoint: .bottom, endPoint: .top
                            )
                        )
                        .frame(width: 3)
                        .frame(height: barHeight(i: i, geo: geo))
                        .animation(
                            .easeInOut(duration: 0.5)
                            .repeatForever()
                            .delay(Double(i) * 0.06),
                            value: phase
                        )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .onAppear { phase = 1 }
    }

    private func barHeight(i: Int, geo: GeometryProxy) -> CGFloat {
        let base: CGFloat = geo.size.height
        let wave = sin(CGFloat(i) * 0.7 + phase * .pi * 2)
        return base * (0.25 + 0.55 * abs(wave))
    }
}

// MARK: - Liquid Glass modifier

extension View {
    func liquidGlassCapsule() -> some View {
        self.background {
            Capsule()
                .fill(.ultraThinMaterial)
                .overlay(
                    Capsule().fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.6), Color.white.opacity(0.2), Color(hex: "#7C5CFC").opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                )
                .overlay(
                    Capsule().strokeBorder(
                        LinearGradient(
                            colors: [Color.white.opacity(0.9), Color.white.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
                )
                .shadow(color: Color(hex: "#7C5CFC").opacity(0.14), radius: 28, x: 0, y: 8)
                .shadow(color: .black.opacity(0.07), radius: 6, x: 0, y: 2)
        }
    }
}

#Preview {
    MainTabView().environmentObject(AppState())
}
