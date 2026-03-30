import SwiftUI

enum AIInputMode { case none, text, voice }

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
            Group {
                switch state.tab {
                case 0: HomeView()
                case 2: SubscriptionsView()
                default: HomeView()
                }
            }
            .ignoresSafeArea(edges: .bottom)

            // Tap outside to dismiss
            if aiMode != .none {
                Color.clear
                    .contentShape(Rectangle())
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            aiMode = .none
                            inputText = ""
                            inputFocused = false
                        }
                    }
                    .zIndex(1)
            }

            // Bottom UI
            VStack(spacing: 0) {
                // Toast
                if !state.toast.isEmpty {
                    Text(state.toast)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.black.opacity(0.82), in: Capsule())
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 10)
                }

                // Bottom bar
                switch aiMode {
                case .none:  tabBar
                case .text:  textBar
                case .voice: voiceBar
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.78), value: aiMode)
            .animation(.spring(response: 0.3), value: state.toast)
            .zIndex(10)
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
    }

    // MARK: - Tab Bar (Dot-style: "+ 首页  ✦  订阅  🎤")

    private var tabBar: some View {
        HStack(spacing: 0) {
            // Home
            tabBtn(icon: "house", label: "首页", active: state.tab == 0) {
                withAnimation(.spring(response: 0.3)) { state.tab = 0 }
            }

            // AI orb — center, slightly larger
            aiOrbBtn
                .frame(maxWidth: .infinity)

            // Subscriptions
            tabBtn(icon: "bookmark", label: "订阅", active: state.tab == 2) {
                withAnimation(.spring(response: 0.3)) { state.tab = 2 }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 10)
        .background {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.black.opacity(0.88))
                .shadow(color: .black.opacity(0.25), radius: 24, x: 0, y: 8)
        }
        .transition(.scale(scale: 0.95).combined(with: .opacity))
    }

    private func tabBtn(icon: String, label: String, active: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 3) {
                Image(systemName: active ? "\(icon).fill" : icon)
                    .font(.system(size: 18, weight: active ? .semibold : .regular))
                    .foregroundColor(active ? .white : .white.opacity(0.4))
                Text(label)
                    .font(.system(size: 10, weight: active ? .semibold : .regular))
                    .foregroundColor(active ? .white : .white.opacity(0.4))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
        }
        .buttonStyle(.plain)
    }

    private var aiOrbBtn: some View {
        ZStack {
            // Glow ring
            Circle()
                .fill(Color(hex: "#7C5CFC").opacity(0.3))
                .frame(width: 58, height: 58)
                .blur(radius: 8)

            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "#A78BFA"), Color(hex: "#7C5CFC"), Color(hex: "#6D28D9")],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
                .frame(width: 50, height: 50)
                .overlay(Circle().strokeBorder(.white.opacity(0.25), lineWidth: 1))

            Image(systemName: "sparkles")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
        }
        .simultaneousGesture(
            TapGesture().onEnded {
                withAnimation(.spring(response: 0.42, dampingFraction: 0.75)) { aiMode = .text }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { inputFocused = true }
            }
        )
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.45).onEnded { _ in
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                withAnimation(.spring(response: 0.42, dampingFraction: 0.75)) { aiMode = .voice }
            }
        )
    }

    // MARK: - Text Input Bar (Dot-style)

    private var textBar: some View {
        HStack(spacing: 12) {
            // Dismiss X
            Button {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    aiMode = .none; inputText = ""; inputFocused = false
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.black.opacity(0.4))
                    .frame(width: 32, height: 32)
                    .background(Color.black.opacity(0.06), in: Circle())
            }
            .buttonStyle(.plain)

            // Field
            ZStack(alignment: .leading) {
                if inputText.isEmpty {
                    Text("想订阅什么？")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.black.opacity(0.3))
                }
                TextField("", text: $inputText, axis: .vertical)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.black.opacity(0.88))
                    .focused($inputFocused)
                    .lineLimit(1...3)
                    .submitLabel(.send)
                    .onSubmit { sendMessage() }
            }

            // Send
            Button { sendMessage() } label: {
                ZStack {
                    Circle()
                        .fill(inputText.isEmpty
                              ? Color.black.opacity(0.08)
                              : Color.black.opacity(0.88))
                        .frame(width: 34, height: 34)
                    if isProcessing {
                        ProgressView().tint(.white).scaleEffect(0.7)
                    } else {
                        Image(systemName: "arrow.up")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(inputText.isEmpty ? .black.opacity(0.3) : .white)
                    }
                }
            }
            .buttonStyle(.plain)
            .disabled(inputText.isEmpty || isProcessing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color(hex: "#F5F4F0"))
                .shadow(color: .black.opacity(0.12), radius: 20, x: 0, y: 6)
        }
        .transition(.scale(scale: 0.95).combined(with: .opacity))
    }

    // MARK: - Voice Bar

    private var voiceBar: some View {
        HStack(spacing: 16) {
            Button {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { aiMode = .none }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.black.opacity(0.4))
                    .frame(width: 32, height: 32)
                    .background(Color.black.opacity(0.06), in: Circle())
            }
            .buttonStyle(.plain)

            // Waveform
            WaveformView()
                .frame(height: 32)

            // Mic button
            Button {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    aiMode = .none
                    state.showToast("语音功能即将上线 ✨")
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.black.opacity(0.88))
                        .frame(width: 44, height: 44)
                    Image(systemName: "mic.fill")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color(hex: "#F5F4F0"))
                .shadow(color: .black.opacity(0.12), radius: 20, x: 0, y: 6)
        }
        .transition(.scale(scale: 0.95).combined(with: .opacity))
    }

    // MARK: - Send logic

    private func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        isProcessing = true
        inputText = ""
        inputFocused = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            if let template = AppData.parseIntent(text) {
                state.addSub(template)
                withAnimation(.spring(response: 0.4)) { aiMode = .none }
                state.tab = 0
            } else {
                state.showToast("试试「小众App」「深圳活动」「播客」")
                withAnimation(.spring(response: 0.4)) { aiMode = .none }
            }
            isProcessing = false
        }
    }
}

// MARK: - Waveform

struct WaveformView: View {
    @State private var animating = false

    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<16, id: \.self) { i in
                Capsule()
                    .fill(Color.black.opacity(0.5))
                    .frame(width: 2.5)
                    .frame(height: animating
                           ? CGFloat.random(in: 6...28)
                           : CGFloat([6, 14, 20, 10, 24, 8, 18, 12].randomElement()!))
                    .animation(
                        .easeInOut(duration: Double.random(in: 0.3...0.6))
                        .repeatForever(autoreverses: true)
                        .delay(Double(i) * 0.05),
                        value: animating
                    )
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear { animating = true }
    }
}

#Preview {
    MainTabView().environmentObject(AppState())
}
