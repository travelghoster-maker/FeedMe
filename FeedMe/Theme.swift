import SwiftUI

// MARK: - Color Theme

extension Color {
    static let feedBackground = Color("FeedBackground")

    // Named colors fallback
    static let appPrimary = Color(hex: "#6366F1")     // Indigo
    static let appSecondary = Color(hex: "#8B5CF6")   // Violet
    static let appAccent = Color(hex: "#F59E0B")      // Amber
    static let appGreen = Color(hex: "#10B981")
    static let appPink = Color(hex: "#EC4899")

    static let cardBackground = Color(.systemBackground)
    static let subtleBackground = Color(.secondarySystemBackground)
    static let tertiaryBackground = Color(.tertiarySystemBackground)

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    static func fromHex(_ hex: String) -> Color {
        Color(hex: hex)
    }
}

// MARK: - Typography

struct AppFont {
    static func largeTitle() -> Font { .system(size: 34, weight: .bold, design: .rounded) }
    static func title1() -> Font { .system(size: 28, weight: .bold, design: .rounded) }
    static func title2() -> Font { .system(size: 22, weight: .bold, design: .rounded) }
    static func title3() -> Font { .system(size: 20, weight: .semibold, design: .rounded) }
    static func headline() -> Font { .system(size: 17, weight: .semibold, design: .rounded) }
    static func body() -> Font { .system(size: 17, weight: .regular, design: .default) }
    static func callout() -> Font { .system(size: 16, weight: .regular, design: .default) }
    static func subheadline() -> Font { .system(size: 15, weight: .regular, design: .default) }
    static func footnote() -> Font { .system(size: 13, weight: .regular, design: .default) }
    static func caption() -> Font { .system(size: 12, weight: .regular, design: .default) }
    static func caption2() -> Font { .system(size: 11, weight: .medium, design: .rounded) }
}

// MARK: - Spacing

struct Spacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
    static let xxxl: CGFloat = 32
}

// MARK: - Corner Radius

struct Radius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
    static let full: CGFloat = 999
}

// MARK: - Shadows

extension View {
    func cardShadow() -> some View {
        self.shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
            .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
    }

    func subtleShadow() -> some View {
        self.shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }
}

// MARK: - Star Rating View

struct StarRatingView: View {
    let rating: Double
    let size: CGFloat

    init(rating: Double, size: CGFloat = 12) {
        self.rating = rating
        self.size = size
    }

    var body: some View {
        HStack(spacing: 1) {
            ForEach(0..<5, id: \.self) { index in
                Image(systemName: starName(for: index))
                    .font(.system(size: size))
                    .foregroundColor(Color(hex: "#F59E0B"))
            }
        }
    }

    private func starName(for index: Int) -> String {
        let threshold = Double(index) + 1
        if rating >= threshold { return "star.fill" }
        else if rating >= threshold - 0.5 { return "star.leadinghalf.filled" }
        else { return "star" }
    }
}

// MARK: - Tag Chip

struct TagChip: View {
    let text: String
    var color: Color = Color.appPrimary

    var body: some View {
        Text(text)
            .font(AppFont.caption2())
            .foregroundColor(color)
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, Spacing.xs)
            .background(color.opacity(0.1))
            .clipShape(Capsule())
    }
}

// MARK: - Pill Button

struct PillButton: View {
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFont.footnote().weight(.semibold))
                .foregroundColor(.white)
                .padding(.horizontal, Spacing.lg)
                .padding(.vertical, Spacing.sm)
                .background(color)
                .clipShape(Capsule())
        }
    }
}
