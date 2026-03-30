import Foundation
import SwiftUI

// MARK: - Subscription

struct Subscription: Identifiable, Codable {
    let id: UUID
    var title: String
    var query: String
    var type: SubscriptionType
    var iconName: String
    var colorHex: String
    var createdAt: Date
    var itemCount: Int

    enum SubscriptionType: String, Codable, CaseIterable {
        case app = "app"
        case event = "event"
        case content = "content"

        var label: String {
            switch self {
            case .app: return "应用"
            case .event: return "活动"
            case .content: return "内容"
            }
        }

        var icon: String {
            switch self {
            case .app: return "app.badge"
            case .event: return "calendar.badge.clock"
            case .content: return "newspaper"
            }
        }
    }
}

// MARK: - Feed Item

struct FeedItem: Identifiable {
    let id: UUID
    let subscriptionId: UUID
    let type: Subscription.SubscriptionType
    let content: FeedContent
    let publishedAt: Date
    var isBookmarked: Bool = false
}

enum FeedContent {
    case app(AppContent)
    case event(EventContent)
    case article(ArticleContent)
}

struct AppContent {
    let name: String
    let developer: String
    let description: String
    let category: String
    let rating: Double
    let reviewCount: Int
    let price: String
    let iconURL: String
    let appStoreURL: String
    let screenshots: [String]
    let tags: [String]
}

struct EventContent {
    let title: String
    let organizer: String
    let description: String
    let date: String
    let time: String
    let location: String
    let city: String
    let price: String
    let coverURL: String
    let signupURL: String
    let tags: [String]
    let attendeeCount: Int
}

struct ArticleContent {
    let title: String
    let author: String
    let summary: String
    let coverURL: String
    let sourceURL: String
    let readTime: Int
    let tags: [String]
}

// MARK: - Chat

struct ChatMessage: Identifiable {
    let id: UUID
    let role: Role
    let content: String
    let timestamp: Date
    var attachedSubscription: Subscription?

    enum Role {
        case user
        case assistant
    }
}

// MARK: - Mock Data

struct MockData {
    static let subscriptions: [Subscription] = [
        Subscription(
            id: UUID(),
            title: "小众设计感 App",
            query: "小众设计感app",
            type: .app,
            iconName: "app.badge",
            colorHex: "#6366F1",
            createdAt: Date().addingTimeInterval(-86400 * 3),
            itemCount: 12
        ),
        Subscription(
            id: UUID(),
            title: "深圳周末活动",
            query: "深圳周末活动",
            type: .event,
            iconName: "calendar.badge.clock",
            colorHex: "#F59E0B",
            createdAt: Date().addingTimeInterval(-86400 * 1),
            itemCount: 8
        ),
        Subscription(
            id: UUID(),
            title: "独立游戏推荐",
            query: "独立游戏iOS",
            type: .app,
            iconName: "gamecontroller",
            colorHex: "#10B981",
            createdAt: Date().addingTimeInterval(-86400 * 5),
            itemCount: 15
        ),
        Subscription(
            id: UUID(),
            title: "上海艺术展览",
            query: "上海艺术展览",
            type: .event,
            iconName: "building.columns",
            colorHex: "#EC4899",
            createdAt: Date().addingTimeInterval(-86400 * 2),
            itemCount: 6
        )
    ]

    static let appItems: [FeedItem] = [
        FeedItem(
            id: UUID(),
            subscriptionId: subscriptions[0].id,
            type: .app,
            content: .app(AppContent(
                name: "Mela – Recipe Manager",
                developer: "Falk Löffler",
                description: "极简食谱管理工具，界面干净到让人上瘾。无广告、无订阅、买断制。支持从网页一键导入食谱，排版令人心旷神怡。",
                category: "美食佳饮",
                rating: 4.9,
                reviewCount: 3241,
                price: "¥18",
                iconURL: "mela_icon",
                appStoreURL: "https://apps.apple.com/app/mela-recipe-manager/id1548466041",
                screenshots: [],
                tags: ["极简", "买断制", "食谱", "无广告"]
            )),
            publishedAt: Date().addingTimeInterval(-3600 * 2)
        ),
        FeedItem(
            id: UUID(),
            subscriptionId: subscriptions[0].id,
            type: .app,
            content: .app(AppContent(
                name: "Camo",
                developer: "Reincubate",
                description: "把 iPhone 变成专业级网络摄像头，画质碾压大多数独立摄像头。设计师必备，视频通话直接上档次。",
                category: "摄影与录像",
                rating: 4.7,
                reviewCount: 8820,
                price: "免费",
                iconURL: "camo_icon",
                appStoreURL: "https://apps.apple.com/app/camo/id1514199900",
                screenshots: [],
                tags: ["效率", "摄像头", "设计感", "专业"]
            )),
            publishedAt: Date().addingTimeInterval(-3600 * 5)
        ),
        FeedItem(
            id: UUID(),
            subscriptionId: subscriptions[0].id,
            type: .app,
            content: .app(AppContent(
                name: "Pockity",
                developer: "Realmac Software",
                description: "本地优先的个人预算 App，数据完全私有。暗色主题配色极其精致，交互动效流畅。买断制，良心定价。",
                category: "财务",
                rating: 4.8,
                reviewCount: 1560,
                price: "¥30",
                iconURL: "pockity_icon",
                appStoreURL: "https://apps.apple.com/app/pockity/id1600527007",
                screenshots: [],
                tags: ["买断制", "财务", "本地优先", "暗色"]
            )),
            publishedAt: Date().addingTimeInterval(-3600 * 8)
        )
    ]

    static let eventItems: [FeedItem] = [
        FeedItem(
            id: UUID(),
            subscriptionId: subscriptions[1].id,
            type: .event,
            content: .event(EventContent(
                title: "深圳湾公园·星空音乐节",
                organizer: "深圳湾文化发展中心",
                description: "在深圳湾公园草坪，伴着星空听现场音乐。本次邀请了5组独立乐队，涵盖民谣、爵士、电子等风格。带上野餐垫，躺着听歌。",
                date: "4月5日（周六）",
                time: "18:00 - 22:00",
                location: "深圳湾公园 南广场草坪",
                city: "深圳",
                price: "¥68 起",
                coverURL: "event_music",
                signupURL: "https://www.xiaohongshu.com",
                tags: ["音乐", "户外", "夜场", "独立音乐"],
                attendeeCount: 342
            )),
            publishedAt: Date().addingTimeInterval(-3600 * 1)
        ),
        FeedItem(
            id: UUID(),
            subscriptionId: subscriptions[1].id,
            type: .event,
            content: .event(EventContent(
                title: "创客集市 · 手作与设计市集",
                organizer: "南山区文化馆",
                description: "超过80家独立设计师摆摊，涵盖陶瓷、皮具、插画、独立音乐等品类。免费入场，带现金支持独立设计师。",
                date: "4月6日（周日）",
                time: "10:00 - 18:00",
                location: "深圳设计互联 D&D 广场",
                city: "深圳",
                price: "免费",
                coverURL: "event_market",
                signupURL: "https://www.xiaohongshu.com",
                tags: ["市集", "手作", "免费", "设计"],
                attendeeCount: 1205
            )),
            publishedAt: Date().addingTimeInterval(-3600 * 3)
        ),
        FeedItem(
            id: UUID(),
            subscriptionId: subscriptions[1].id,
            type: .event,
            content: .event(EventContent(
                title: "周末骑行 · 大鹏半岛环线",
                organizer: "深圳骑行俱乐部",
                description: "全程约65公里，沿海公路风景绝美。有领队全程陪同，提供补给站。适合有一定基础的骑行爱好者，提前报名可租借公路车。",
                date: "4月5日（周六）",
                time: "07:00 出发",
                location: "大鹏新区坝光村集合",
                city: "深圳",
                price: "¥30（含租车 ¥120）",
                coverURL: "event_cycling",
                signupURL: "https://www.xiaohongshu.com",
                tags: ["骑行", "户外", "大鹏", "海景"],
                attendeeCount: 56
            )),
            publishedAt: Date().addingTimeInterval(-3600 * 6)
        )
    ]

    static var allFeedItems: [FeedItem] {
        (appItems + eventItems).sorted { $0.publishedAt > $1.publishedAt }
    }
}
