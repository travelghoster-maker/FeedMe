import SwiftUI

struct ChatView: View {
    @EnvironmentObject var state: AppState
    @StateObject private var vm = ChatVM()
    @FocusState private var focused: Bool

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 2) {
                Text("✦ 发现")
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .foregroundColor(Color(hex: "#1A1A2E"))
                Text("说说你想订阅什么内容")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#ADB5BD"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
            .overlay(Divider(), alignment: .bottom)

            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(vm.messages) { msg in
                            BubbleView(msg: msg)
                                .padding(.bottom, 10)
                                .id(msg.id)
                        }
                        if vm.typing {
                            TypingDotsView()
                                .padding(.bottom, 10)
                                .id("typing")
                        }
                        Color.clear.frame(height: 110).id("bottom")
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: vm.messages.count) { _, _ in
                    withAnimation { proxy.scrollTo("bottom") }
                }
                .onChange(of: vm.typing) { _, _ in
                    withAnimation { proxy.scrollTo("bottom") }
                }
            }

            // Quick chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(["小众设计感 App", "深圳周末活动", "播客推荐", "深圳美食探店"], id: \.self) { chip in
                        Button {
                            send(chip)
                        } label: {
                            Text(chip)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Color(hex: "#7C5CFC"))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 7)
                                .background(Color.white)
                                .overlay(Capsule().stroke(Color(hex: "#E9ECF0"), lineWidth: 1.5))
                                .clipShape(Capsule())
                                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 1)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
            }
            .background(Color.white)

            // Input bar
            HStack(spacing: 10) {
                TextField("说说你想订阅什么…", text: $vm.input, axis: .vertical)
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#1A1A2E"))
                    .lineLimit(1...4)
                    .focused($focused)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 12)
                    .background(Color(hex: "#F7F8FC"))
                    .overlay(RoundedRectangle(cornerRadius: 26).stroke(Color(hex: "#E9ECF0"), lineWidth: 1.5))
                    .clipShape(RoundedRectangle(cornerRadius: 26))

                Button { send(vm.input) } label: {
                    ZStack {
                        Circle()
                            .fill(vm.input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                  ? Color(hex: "#E9ECF0")
                                  : LinearGradient(colors: [Color(hex: "#7C5CFC"), Color(hex: "#A78BFA")],
                                                   startPoint: .topLeading, endPoint: .bottomTrailing).asColor)
                            .frame(width: 46, height: 46)
                        Image(systemName: "arrow.up")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(vm.input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                             ? Color(hex: "#ADB5BD") : .white)
                    }
                }
                .disabled(vm.input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
            .padding(.bottom, 28)
            .background(Color.white)
            .overlay(Divider(), alignment: .top)
        }
        .background(Color(hex: "#F7F8FC"))
        .onReceive(vm.$newSub) { sub in
            guard let sub else { return }
            let exists = state.subs.contains { $0.template == sub }
            if !exists { state.addSub(sub) }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                state.tab = 0
            }
        }
    }

    func send(_ text: String) {
        let t = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else { return }
        let exists = AppData.parseIntent(t).map { sub in state.subs.contains { $0.template == sub } } ?? false
        vm.send(t, subExists: exists)
    }
}

// MARK: - Chat VM

class ChatVM: ObservableObject {
    @Published var messages: [ChatMessage] = [
        ChatMessage(id: UUID(), role: .assistant,
                    text: "嗨！我是你的订阅助手 ✦\n\n告诉我你想追踪什么，比如「小众设计感 App」或「深圳周末活动」，我来自动帮你收集内容，以卡片形式呈现 😊")
    ]
    @Published var input: String = ""
    @Published var typing: Bool = false
    @Published var newSub: SubTemplate? = nil

    func send(_ text: String, subExists: Bool) {
        messages.append(ChatMessage(id: UUID(), role: .user, text: text))
        input = ""
        typing = true

        let sub = AppData.parseIntent(text)
        let reply = AppData.buildReply(sub, exists: subExists)

        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 1.1...1.8)) {
            self.typing = false
            self.messages.append(ChatMessage(id: UUID(), role: .assistant, text: reply))
            if let sub, !subExists {
                self.newSub = sub
            }
        }
    }
}

// MARK: - Bubble

struct BubbleView: View {
    let msg: ChatMessage
    var isUser: Bool { msg.role == .user }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isUser { Spacer(minLength: 60) }

            if !isUser {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [Color(hex: "#7C5CFC"), Color(hex: "#A78BFA")],
                                             startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 32, height: 32)
                    Text("✦")
                        .font(.system(size: 15, weight: .heavy))
                        .foregroundColor(.white)
                }
            }

            Text(msg.text)
                .font(.system(size: 14))
                .foregroundColor(isUser ? .white : Color(hex: "#1A1A2E"))
                .lineSpacing(4)
                .padding(.horizontal, 15)
                .padding(.vertical, 11)
                .background(
                    isUser
                    ? AnyView(LinearGradient(colors: [Color(hex: "#7C5CFC"), Color(hex: "#9D7EFB")],
                                             startPoint: .topLeading, endPoint: .bottomTrailing))
                    : AnyView(Color(hex: "#ECEEF5"))
                )
                .clipShape(RoundedRectangle(cornerRadius: isUser ? 18 : 18))

            if !isUser { Spacer(minLength: 60) }
        }
    }
}

// MARK: - Typing Dots

struct TypingDotsView: View {
    @State private var phase = 0

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [Color(hex: "#7C5CFC"), Color(hex: "#A78BFA")],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 32, height: 32)
                Text("✦").font(.system(size: 15, weight: .heavy)).foregroundColor(.white)
            }

            HStack(spacing: 5) {
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .fill(Color(hex: "#ADB5BD"))
                        .frame(width: 7, height: 7)
                        .scaleEffect(phase == i ? 1.3 : 0.8)
                        .animation(.easeInOut(duration: 0.4).repeatForever().delay(Double(i) * 0.2), value: phase)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 13)
            .background(Color(hex: "#ECEEF5"))
            .clipShape(RoundedRectangle(cornerRadius: 18))

            Spacer(minLength: 60)
        }
        .onAppear {
            phase = 1
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                phase = (phase + 1) % 3
            }
        }
    }
}

// MARK: - Gradient as Color helper

extension LinearGradient {
    var asColor: Color { Color.clear } // placeholder, used via AnyView
}

#Preview {
    ChatView().environmentObject(AppState())
}
