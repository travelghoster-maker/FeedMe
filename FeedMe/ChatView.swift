import SwiftUI
import Combine

// MARK: - Chat View

struct ChatView: View {
    @EnvironmentObject var store: AppStore
    @StateObject private var viewModel = ChatViewModel()
    @FocusState private var isInputFocused: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()

                VStack(spacing: 0) {
                    // Messages
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(spacing: Spacing.lg) {
                                // Welcome header
                                if viewModel.messages.isEmpty {
                                    WelcomePromptView { suggestion in
                                        viewModel.inputText = suggestion
                                        isInputFocused = true
                                    }
                                    .padding(.top, Spacing.xxl)
                                }

                                ForEach(viewModel.messages) { message in
                                    MessageBubble(message: message) { sub in
                                        // User confirmed subscription
                                        store.addSubscription(sub)
                                        store.selectedTab = 0
                                    }
                                    .id(message.id)
                                }

                                if viewModel.isTyping {
                                    TypingIndicator()
                                        .id("typing")
                                }

                                Color.clear.frame(height: 1).id("bottom")
                            }
                            .padding(.horizontal, Spacing.lg)
                            .padding(.top, Spacing.lg)
                        }
                        .scrollDismissesKeyboard(.interactively)
                        .onChange(of: viewModel.messages.count) { _, _ in
                            withAnimation {
                                proxy.scrollTo("bottom", anchor: .bottom)
                            }
                        }
                        .onChange(of: viewModel.isTyping) { _, _ in
                            withAnimation {
                                proxy.scrollTo("bottom", anchor: .bottom)
                            }
                        }
                    }

                    // Input Bar
                    ChatInputBar(
                        text: $viewModel.inputText,
                        isFocused: $isInputFocused,
                        isLoading: viewModel.isTyping
                    ) {
                        viewModel.sendMessage()
                    }
                }
            }
            .navigationTitle("发现")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Chat ViewModel

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isTyping: Bool = false

    private let responses = ConversationEngine()

    func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        // Add user message
        let userMsg = ChatMessage(id: UUID(), role: .user, content: text, timestamp: Date())
        messages.append(userMsg)
        inputText = ""
        isTyping = true

        // Simulate AI response
        let intent = responses.parseIntent(text)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
            guard let self = self else { return }
            self.isTyping = false

            let (responseText, subscription) = self.responses.generateResponse(for: intent, query: text)
            var aiMsg = ChatMessage(id: UUID(), role: .assistant, content: responseText, timestamp: Date())
            aiMsg.attachedSubscription = subscription
            self.messages.append(aiMsg)
        }
    }
}

// MARK: - Conversation Engine

class ConversationEngine {
    enum Intent {
        case createAppSubscription(String)
        case createEventSubscription(String)
        case createContentSubscription(String)
        case unknown
    }

    func parseIntent(_ text: String) -> Intent {
        let lower = text.lowercased()

        // App keywords
        if lower.contains("app") || lower.contains("应用") || lower.contains("软件")
            || lower.contains("工具") || lower.contains("游戏") {
            return .createAppSubscription(text)
        }

        // Event keywords
        if lower.contains("活动") || lower.contains("展览") || lower.contains("音乐节")
            || lower.contains("市集") || lower.contains("演出") || lower.contains("骑行")
            || lower.contains("周末") || lower.contains("演唱会") {
            return .createEventSubscription(text)
        }

        // Location + activity
        let cities = ["北京", "上海", "深圳", "广州", "杭州", "成都", "武汉", "西安"]
        if cities.contains(where: { lower.contains($0) }) {
            return .createEventSubscription(text)
        }

        // Design/aesthetic
        if lower.contains("设计") || lower.contains("小众") || lower.contains("精致")
            || lower.contains("极简") {
            return .createAppSubscription(text)
        }

        return .createContentSubscription(text)
    }

    func generateResponse(for intent: Intent, query: String) -> (String, Subscription?) {
        switch intent {
        case .createAppSubscription(let q):
            let title = extractTitle(from: q, type: .app)
            let sub = Subscription(
                id: UUID(),
                title: title,
                query: q,
                type: .app,
                iconName: "app.badge",
                colorHex: randomAppColor(),
                createdAt: Date(),
                itemCount: 0
            )
            let response = "好的！我帮你创建了「**\(title)**」订阅 🎉\n\n我会持续从小红书上为你发现符合这个主题的应用，找到后会出现在首页卡片里，点击就能跳转到 App Store 下载。\n\n你要一起添加到首页吗？"
            return (response, sub)

        case .createEventSubscription(let q):
            let title = extractTitle(from: q, type: .event)
            let sub = Subscription(
                id: UUID(),
                title: title,
                query: q,
                type: .event,
                iconName: "calendar.badge.clock",
                colorHex: randomEventColor(),
                createdAt: Date(),
                itemCount: 0
            )
            let response = "没问题！「**\(title)**」订阅已创建 📅\n\n我会在小红书上帮你监控这类活动，找到感兴趣的就推送到首页。每张活动卡片都可以直接点击跳转到报名页面。\n\n要添加到首页吗？"
            return (response, sub)

        case .createContentSubscription(let q):
            let title = extractTitle(from: q, type: .content)
            let sub = Subscription(
                id: UUID(),
                title: title,
                query: q,
                type: .content,
                iconName: "newspaper",
                colorHex: "#6366F1",
                createdAt: Date(),
                itemCount: 0
            )
            let response = "明白了！「**\(title)**」订阅已经创建好了 ✨\n\n我会持续为你抓取相关内容，直接展示在首页。要确认添加吗？"
            return (response, sub)

        case .unknown:
            return ("我还不太确定你想订阅什么，能告诉我更多吗？比如：\n\n• 「推荐设计感强的 iOS 工具 App」\n• 「深圳本周末有什么活动」\n• 「独立游戏推荐」", nil)
        }
    }

    private func extractTitle(from query: String, type: Subscription.SubscriptionType) -> String {
        // Simplified title extraction - real app uses LLM
        let cleaned = query
            .replacingOccurrences(of: "帮我", with: "")
            .replacingOccurrences(of: "我想", with: "")
            .replacingOccurrences(of: "订阅", with: "")
            .replacingOccurrences(of: "找", with: "")
            .replacingOccurrences(of: "推荐", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        if cleaned.count > 12 {
            return String(cleaned.prefix(12)) + "..."
        }
        return cleaned.isEmpty ? "我的订阅 #\(Int.random(in: 100...999))" : cleaned
    }

    private func randomAppColor() -> String {
        let colors = ["#6366F1", "#8B5CF6", "#3B82F6", "#10B981", "#EC4899"]
        return colors.randomElement()!
    }

    private func randomEventColor() -> String {
        let colors = ["#F59E0B", "#EF4444", "#EC4899", "#F97316"]
        return colors.randomElement()!
    }
}

// MARK: - Message Bubble

struct MessageBubble: View {
    let message: ChatMessage
    let onAddSubscription: (Subscription) -> Void
    @State private var showConfirmation = false

    var isUser: Bool { message.role == .user }

    var body: some View {
        HStack(alignment: .bottom, spacing: Spacing.sm) {
            if isUser { Spacer(minLength: 60) }

            if !isUser {
                // AI Avatar
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            colors: [.appPrimary, .appSecondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 32, height: 32)
                    Image(systemName: "sparkles")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                }
            }

            VStack(alignment: isUser ? .trailing : .leading, spacing: Spacing.sm) {
                // Text bubble
                MarkdownText(text: message.content)
                    .padding(.horizontal, Spacing.lg)
                    .padding(.vertical, Spacing.md)
                    .background(isUser ? Color.appPrimary : Color(.secondarySystemBackground))
                    .foregroundColor(isUser ? .white : .primary)
                    .clipShape(
                        RoundedRectangle(cornerRadius: Radius.xl)
                            .withCornerStyle(isUser: isUser)
                    )

                // Subscription confirmation card
                if let sub = message.attachedSubscription {
                    SubscriptionConfirmCard(subscription: sub) {
                        onAddSubscription(sub)
                        showConfirmation = true
                    }
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
                }
            }

            if !isUser { Spacer(minLength: 60) }
        }
    }
}

// MARK: - Subscription Confirm Card

struct SubscriptionConfirmCard: View {
    let subscription: Subscription
    let onConfirm: () -> Void
    @State private var isAdded = false

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack(spacing: Spacing.md) {
                ZStack {
                    Circle()
                        .fill(Color.fromHex(subscription.colorHex).opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: subscription.iconName)
                        .font(.system(size: 20))
                        .foregroundColor(Color.fromHex(subscription.colorHex))
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(subscription.title)
                        .font(AppFont.headline())
                    Text(subscription.type.label + " · 订阅")
                        .font(AppFont.caption())
                        .foregroundColor(.secondary)
                }

                Spacer()
            }

            if !isAdded {
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        isAdded = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        onConfirm()
                    }
                }) {
                    HStack(spacing: Spacing.sm) {
                        Image(systemName: "plus.circle.fill")
                        Text("添加到首页")
                    }
                    .font(AppFont.subheadline().weight(.semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.md)
                    .background(Color.fromHex(subscription.colorHex))
                    .clipShape(RoundedRectangle(cornerRadius: Radius.md))
                }
            } else {
                HStack(spacing: Spacing.sm) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.appGreen)
                    Text("已添加到首页 ✓")
                        .foregroundColor(.appGreen)
                }
                .font(AppFont.subheadline().weight(.medium))
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.md)
                .background(Color.appGreen.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: Radius.md))
            }
        }
        .padding(Spacing.lg)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: Radius.xl))
        .frame(maxWidth: 280)
    }
}

// MARK: - Typing Indicator

struct TypingIndicator: View {
    @State private var phase: Int = 0

    var body: some View {
        HStack(alignment: .bottom, spacing: Spacing.sm) {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [.appPrimary, .appSecondary],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ))
                    .frame(width: 32, height: 32)
                Image(systemName: "sparkles")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
            }

            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .fill(Color.secondary)
                        .frame(width: 8, height: 8)
                        .scaleEffect(phase == i ? 1.3 : 0.8)
                        .animation(
                            .easeInOut(duration: 0.4)
                                .repeatForever()
                                .delay(Double(i) * 0.15),
                            value: phase
                        )
                }
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.vertical, Spacing.md)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: Radius.xl))

            Spacer(minLength: 60)
        }
        .onAppear {
            withAnimation { phase = 1 }
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { t in
                phase = (phase + 1) % 3
            }
        }
    }
}

// MARK: - Chat Input Bar

struct ChatInputBar: View {
    @Binding var text: String
    var isFocused: FocusState<Bool>.Binding
    let isLoading: Bool
    let onSend: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: Spacing.md) {
                TextField("告诉我你想订阅什么...", text: $text, axis: .vertical)
                    .font(AppFont.body())
                    .lineLimit(1...5)
                    .focused(isFocused)
                    .padding(.horizontal, Spacing.lg)
                    .padding(.vertical, Spacing.md)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: Radius.xl))
                    .onSubmit {
                        if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            onSend()
                        }
                    }

                Button(action: onSend) {
                    ZStack {
                        Circle()
                            .fill(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading
                                  ? Color(.tertiarySystemBackground)
                                  : Color.appPrimary)
                            .frame(width: 44, height: 44)

                        Image(systemName: isLoading ? "ellipsis" : "arrow.up")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading
                                             ? Color(.tertiaryLabel)
                                             : .white)
                    }
                }
                .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)
                .animation(.spring(response: 0.25), value: text.isEmpty)
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.vertical, Spacing.sm)
            .background(Color(.systemBackground))
        }
    }
}

// MARK: - Welcome Prompts

struct WelcomePromptView: View {
    let onSelect: (String) -> Void

    let suggestions = [
        ("app.badge", "小众设计感 App", "#6366F1"),
        ("calendar.badge.clock", "深圳周末活动", "#F59E0B"),
        ("gamecontroller", "独立游戏推荐", "#10B981"),
        ("building.columns", "上海艺术展览", "#EC4899"),
        ("airplane", "小众旅行目的地", "#3B82F6"),
        ("headphones", "独立音乐新专辑", "#8B5CF6")
    ]

    var body: some View {
        VStack(spacing: Spacing.xxl) {
            // Header
            VStack(spacing: Spacing.md) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            colors: [.appPrimary, .appSecondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 64, height: 64)
                    Image(systemName: "sparkles")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.white)
                }

                Text("你好，我是 FeedMe")
                    .font(AppFont.title2())

                Text("告诉我你感兴趣的内容，\n我来帮你创建专属订阅")
                    .font(AppFont.subheadline())
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Suggestion Chips
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("你可以试试问我：")
                    .font(AppFont.footnote())
                    .foregroundColor(.secondary)
                    .padding(.leading, Spacing.xs)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Spacing.sm) {
                    ForEach(suggestions, id: \.1) { icon, text, color in
                        SuggestionChip(icon: icon, text: text, color: Color.fromHex(color)) {
                            onSelect(text)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, Spacing.sm)
    }
}

// MARK: - Suggestion Chip

struct SuggestionChip: View {
    let icon: String
    let text: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(color)
                    .frame(width: 20)

                Text(text)
                    .font(AppFont.footnote())
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(Spacing.md)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
        }
    }
}

// MARK: - Markdown Text (simplified)

struct MarkdownText: View {
    let text: String

    var body: some View {
        Text(parseMarkdown(text))
    }

    private func parseMarkdown(_ text: String) -> AttributedString {
        var result = AttributedString(text)

        // Bold: **text**
        var searchText = text
        var offset = 0
        while let range = searchText.range(of: #"\*\*(.+?)\*\*"#, options: .regularExpression) {
            let matchedText = String(searchText[range])
            let boldText = matchedText.replacingOccurrences(of: "**", with: "")
            searchText.replaceSubrange(range, with: boldText)
        }

        if let attributed = try? AttributedString(markdown: text) {
            return attributed
        }
        return AttributedString(text)
    }
}

// MARK: - Corner Style Extension

extension RoundedRectangle {
    func withCornerStyle(isUser: Bool) -> some Shape {
        return self
    }
}
