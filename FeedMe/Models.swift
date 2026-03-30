import Foundation
import SwiftUI

// MARK: - Subscription Template

struct SubTemplate: Identifiable, Equatable {
    let id: String          // key
    let name: String
    let icon: String
    let color: Color
    let desc: String
    let src: String

    static func == (lhs: SubTemplate, rhs: SubTemplate) -> Bool { lhs.id == rhs.id }
}

// MARK: - User Subscription

struct UserSub: Identifiable {
    let id: UUID
    let template: SubTemplate
    let addedAt: Date
}

// MARK: - Card

enum CardContent {
    case app(AppCard)
    case event(EventCard)
}

struct FeedCard: Identifiable {
    let id: String
    let subKey: String
    let subName: String
    let subIcon: String
    let subColor: Color
    let content: CardContent
}

struct AppCard {
    let name: String
    let category: String
    let icon: String
    let color: Color
    let rating: Double
    let ratingCount: String
    let price: String
    let tag: String
    let desc: String
    let url: String
    let src: String
}

struct EventCard {
    let title: String
    let category: String
    let emoji: String
    let gradientColors: [Color]
    let date: String
    let time: String
    let place: String
    let district: String
    let price: String
    let seats: String
    let tag: String
    let tagColor: Color
    let desc: String
    let url: String
    let src: String
}

// MARK: - Chat

struct ChatMessage: Identifiable {
    let id: UUID
    let role: Role
    let text: String
    enum Role { case user, assistant }
}

// MARK: - Data

struct AppData {

    static let templates: [SubTemplate] = [
        SubTemplate(id: "app-design",      name: "小众设计感 App", icon: "📱", color: Color(hex: "#7C5CFC"), desc: "发掘被低估的精品应用",     src: "小红书 · App Store"),
        SubTemplate(id: "events-shenzhen", name: "深圳周末活动",   icon: "🎉", color: Color(hex: "#E17055"), desc: "每周精选活动，不错过好玩",   src: "小红书 · 大麦 · 活动行"),
        SubTemplate(id: "podcast",         name: "播客推荐",       icon: "🎙️", color: Color(hex: "#A29BFE"), desc: "高质量中文播客精选",         src: "小宇宙 · Apple Podcasts"),
        SubTemplate(id: "food-shenzhen",   name: "深圳美食探店",   icon: "🍜", color: Color(hex: "#F59F00"), desc: "隐藏宝藏餐厅，真实测评",     src: "大众点评 · 小红书"),
    ]

    static let mockCards: [String: [FeedCard]] = [
        "app-design": [
            FeedCard(id: "a1", subKey: "app-design", subName: "小众设计感 App", subIcon: "📱", subColor: Color(hex: "#7C5CFC"), content: .app(AppCard(
                name: "Lasso", category: "效率 · 收藏",
                icon: "🔗", color: Color(hex: "#7C5CFC"),
                rating: 4.8, ratingCount: "2.1k", price: "免费", tag: "小众精品",
                desc: "极简主义书签 App，一键收藏网页、图片、文字，视觉化管理灵感库。界面干净如诗。",
                url: "https://apps.apple.com/app/lasso/id1465982600", src: "小红书精选"
            ))),
            FeedCard(id: "a2", subKey: "app-design", subName: "小众设计感 App", subIcon: "📱", subColor: Color(hex: "#7C5CFC"), content: .app(AppCard(
                name: "Mela — Recipe Manager", category: "美食 · 生活",
                icon: "🍎", color: Color(hex: "#E07055"),
                rating: 4.9, ratingCount: "5.6k", price: "¥18", tag: "苹果设计奖",
                desc: "设计感爆表的食谱 App，支持从任意网页一键导入食谱，排版精美如杂志。",
                url: "https://apps.apple.com/app/mela-recipe-manager/id1548466041", src: "小红书精选"
            ))),
            FeedCard(id: "a3", subKey: "app-design", subName: "小众设计感 App", subIcon: "📱", subColor: Color(hex: "#7C5CFC"), content: .app(AppCard(
                name: "Reeder 5", category: "阅读 · RSS",
                icon: "📖", color: Color(hex: "#1AAB6D"),
                rating: 4.8, ratingCount: "8.2k", price: "¥30", tag: "App Store 精选",
                desc: "RSS 阅读器天花板，极简优雅，沉浸式阅读体验，支持多种订阅来源。",
                url: "https://apps.apple.com/app/reeder-5/id1529445840", src: "小红书精选"
            ))),
            FeedCard(id: "a4", subKey: "app-design", subName: "小众设计感 App", subIcon: "📱", subColor: Color(hex: "#7C5CFC"), content: .app(AppCard(
                name: "Things 3", category: "效率 · GTD",
                icon: "✅", color: Color(hex: "#0984E3"),
                rating: 4.8, ratingCount: "12k", price: "¥98", tag: "苹果设计奖",
                desc: "荣获两届苹果设计奖的 GTD 应用，让任务管理变得赏心悦目，强迫症福音。",
                url: "https://apps.apple.com/app/things-3/id904237743", src: "小红书精选"
            ))),
        ],
        "events-shenzhen": [
            FeedCard(id: "e1", subKey: "events-shenzhen", subName: "深圳周末活动", subIcon: "🎉", subColor: Color(hex: "#E17055"), content: .event(EventCard(
                title: "深圳艺术周 2026", category: "艺术展览", emoji: "🎨",
                gradientColors: [Color(hex: "#667eea"), Color(hex: "#764ba2")],
                date: "4月3日 — 4月10日", time: "10:00 – 20:00",
                place: "坪山美术馆", district: "坪山区",
                price: "免费", seats: "每日限500人",
                tag: "热门", tagColor: Color(hex: "#E17055"),
                desc: "汇聚20+ 国际艺术家，探索科技与艺术边界，深圳最具影响力的当代艺术年度盛宴。",
                url: "https://www.szmoa.org", src: "小红书 · 深圳本地活动"
            ))),
            FeedCard(id: "e2", subKey: "events-shenzhen", subName: "深圳周末活动", subIcon: "🎉", subColor: Color(hex: "#E17055"), content: .event(EventCard(
                title: "ING 爵士音乐节", category: "音乐演出", emoji: "🎷",
                gradientColors: [Color(hex: "#f093fb"), Color(hex: "#f5576c")],
                date: "4月5日（周六）", time: "18:00 – 22:00",
                place: "蛇口海上世界广场", district: "南山区",
                price: "¥168 起", seats: "剩余少量",
                tag: "即将售罄", tagColor: Color(hex: "#FF6B6B"),
                desc: "20 组爵士乐队轮番登台，海边微风中感受正宗爵士魅力，含餐饮消费券。",
                url: "https://www.damai.cn", src: "大麦 · 小红书"
            ))),
            FeedCard(id: "e3", subKey: "events-shenzhen", subName: "深圳周末活动", subIcon: "🎉", subColor: Color(hex: "#E17055"), content: .event(EventCard(
                title: "深港城市建筑双年展", category: "设计展览", emoji: "🏛️",
                gradientColors: [Color(hex: "#4facfe"), Color(hex: "#00f2fe")],
                date: "4月1日 — 5月31日", time: "周二至周日 10:00–18:00",
                place: "南头古城", district: "南山区",
                price: "¥60", seats: "可预约",
                tag: "强烈推荐", tagColor: Color(hex: "#00B894"),
                desc: "UABB 深港城市建筑双年展，探讨城市未来与人居环境，多件大型装置艺术首次亮相深圳。",
                url: "https://www.uabb.org", src: "小红书 · 深圳本地活动"
            ))),
            FeedCard(id: "e4", subKey: "events-shenzhen", subName: "深圳周末活动", subIcon: "🎉", subColor: Color(hex: "#E17055"), content: .event(EventCard(
                title: "七娘山户外徒步 周末特供", category: "户外运动", emoji: "🏔️",
                gradientColors: [Color(hex: "#43e97b"), Color(hex: "#38f9d7")],
                date: "4月6日（周日）", time: "07:30 出发",
                place: "七娘山地质公园", district: "大鹏新区",
                price: "¥98/人", seats: "还剩 12 位",
                tag: "即将满员", tagColor: Color(hex: "#FDCB6E"),
                desc: "专业领队带队，全程约 12 km，沿途可见深圳最美海岸线，含轻量级保险和能量补给。",
                url: "https://www.xiaohongshu.com", src: "小红书 · 深圳户外"
            ))),
        ],
        "podcast": [
            FeedCard(id: "p1", subKey: "podcast", subName: "播客推荐", subIcon: "🎙️", subColor: Color(hex: "#A29BFE"), content: .app(AppCard(
                name: "内核恐慌", category: "科技播客",
                icon: "🎙️", color: Color(hex: "#6C5CE7"),
                rating: 4.9, ratingCount: "3.2k", price: "免费", tag: "强烈推荐",
                desc: "两位独立开发者深度聊科技动态，幽默轻松，最新一期「AI 时代的独立开发者」。",
                url: "https://podcasts.apple.com", src: "小宇宙精选"
            ))),
            FeedCard(id: "p2", subKey: "podcast", subName: "播客推荐", subIcon: "🎙️", subColor: Color(hex: "#A29BFE"), content: .app(AppCard(
                name: "硬地骇客", category: "创业 · 产品",
                icon: "🚀", color: Color(hex: "#E17055"),
                rating: 4.8, ratingCount: "2.8k", price: "免费", tag: "创业必听",
                desc: "聊产品、设计、创业，接地气不灌鸡汤，每期都有干货。",
                url: "https://podcasts.apple.com", src: "小宇宙精选"
            ))),
        ],
        "food-shenzhen": [
            FeedCard(id: "f1", subKey: "food-shenzhen", subName: "深圳美食探店", subIcon: "🍜", subColor: Color(hex: "#F59F00"), content: .app(AppCard(
                name: "本来不该有这家店", category: "创意料理 · 福田",
                icon: "🍜", color: Color(hex: "#FDCB6E"),
                rating: 4.8, ratingCount: "2.3k", price: "人均 ¥180", tag: "宝藏隐店",
                desc: "藏在城中村的宝藏餐厅，主厨曾获米其林一星，食材讲究，每天限量 30 份。",
                url: "https://dianping.com", src: "大众点评 · 小红书"
            ))),
            FeedCard(id: "f2", subKey: "food-shenzhen", subName: "深圳美食探店", subIcon: "🍜", subColor: Color(hex: "#F59F00"), content: .app(AppCard(
                name: "喫茶 Mori", category: "日式喫茶 · 南山",
                icon: "☕", color: Color(hex: "#A0522D"),
                rating: 4.9, ratingCount: "1.1k", price: "人均 ¥80", tag: "治愈系",
                desc: "深圳最接近京都感的喫茶店，手冲咖啡 + 铜锣烧，空间安静极了，不适合打卡拍照。",
                url: "https://dianping.com", src: "小红书精选"
            ))),
        ],
    ]

    // MARK: - Default (pre-seeded) data

    static let defaultSubs: [UserSub] = [
        UserSub(id: UUID(), template: templates[0], addedAt: Date()),
        UserSub(id: UUID(), template: templates[1], addedAt: Date()),
    ]

    static let defaultCards: [FeedCard] = {
        var all: [FeedCard] = []
        all += mockCards["app-design"] ?? []
        all += mockCards["events-shenzhen"] ?? []
        return all
    }()

    // MARK: - Intent Parser
    static func parseIntent(_ text: String) -> SubTemplate? {
        let t = text.lowercased()
        if t.contains("app") || t.contains("应用") || t.contains("软件") || t.contains("小众") || t.contains("设计感") {
            return templates[0]
        }
        if t.contains("活动") || t.contains("周末") || t.contains("展览") || t.contains("演出") || t.contains("深圳") {
            return templates[1]
        }
        if t.contains("播客") || t.contains("podcast") || t.contains("音频") {
            return templates[2]
        }
        if t.contains("美食") || t.contains("餐厅") || t.contains("探店") || t.contains("咖啡") || t.contains("吃") {
            return templates[3]
        }
        return nil
    }

    static func buildReply(_ sub: SubTemplate?, exists: Bool) -> String {
        guard let sub = sub else {
            return "暂时没认出这个类型 😅\n\n可以试试：\n· 小众设计感 App\n· 深圳周末活动\n· 播客推荐\n· 深圳美食探店"
        }
        if exists {
            return "「\(sub.name)」已经在你的订阅里啦 ✓\n\n首页已经有最新内容，去看看吧 👇"
        }
        return "好的！正在为你创建订阅 ✨\n\n📌 已添加「\(sub.name)」\n🔍 数据来源：\(sub.src)\n\n内容已经整理好了，去首页查看最新卡片 👇"
    }
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
}
