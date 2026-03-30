import SwiftUI

// MARK: - Subscriptions Management View

struct SubscriptionsView: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.dismiss) var dismiss
    @State private var editMode: EditMode = .inactive
    @State private var showingDeleteAlert = false
    @State private var subscriptionToDelete: Subscription? = nil

    var body: some View {
        NavigationStack {
            List {
                // Stats header
                Section {
                    SubscriptionStatsCard(subscriptions: store.subscriptions)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }

                // Subscriptions
                Section {
                    ForEach(store.subscriptions) { sub in
                        SubscriptionRow(subscription: sub) {
                            subscriptionToDelete = sub
                            showingDeleteAlert = true
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: Spacing.lg, bottom: 0, trailing: Spacing.lg))
                        .listRowBackground(Color(.secondarySystemBackground))
                    }
                } header: {
                    Text("我的订阅  \(store.subscriptions.count)")
                        .font(AppFont.footnote())
                        .foregroundColor(.secondary)
                        .textCase(nil)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("订阅管理")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("完成") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(editMode.isEditing ? "完成" : "编辑") {
                        withAnimation {
                            editMode = editMode.isEditing ? .inactive : .active
                        }
                    }
                }
            }
            .environment(\.editMode, $editMode)
            .alert("删除订阅", isPresented: $showingDeleteAlert) {
                Button("删除", role: .destructive) {
                    if let sub = subscriptionToDelete {
                        withAnimation {
                            store.removeSubscription(sub)
                        }
                    }
                }
                Button("取消", role: .cancel) {}
            } message: {
                Text("删除后，该订阅的所有内容也会从首页移除。")
            }
        }
    }
}

// MARK: - Preview

#Preview("订阅管理") {
    SubscriptionsView()
        .environmentObject(AppStore())
}

// MARK: - Stats Card

struct SubscriptionStatsCard: View {
    let subscriptions: [Subscription]

    private var totalItems: Int {
        subscriptions.reduce(0) { $0 + $1.itemCount }
    }

    private var appCount: Int {
        subscriptions.filter { $0.type == .app }.count
    }

    private var eventCount: Int {
        subscriptions.filter { $0.type == .event }.count
    }

    var body: some View {
        HStack(spacing: 0) {
            StatItem(value: "\(subscriptions.count)", label: "订阅", color: .appPrimary)
            Divider().frame(height: 40)
            StatItem(value: "\(appCount)", label: "应用", color: Color(hex: "#6366F1"))
            Divider().frame(height: 40)
            StatItem(value: "\(eventCount)", label: "活动", color: Color(hex: "#F59E0B"))
            Divider().frame(height: 40)
            StatItem(value: "\(totalItems)", label: "已发现", color: .appGreen)
        }
        .padding(Spacing.lg)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: Radius.xl))
        .padding(Spacing.lg)
    }
}

struct StatItem: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(color)
            Text(label)
                .font(AppFont.caption())
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Subscription Row

struct SubscriptionRow: View {
    let subscription: Subscription
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: Spacing.md) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.fromHex(subscription.colorHex).opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: subscription.iconName)
                    .font(.system(size: 20))
                    .foregroundColor(Color.fromHex(subscription.colorHex))
            }

            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(subscription.title)
                    .font(AppFont.headline())
                    .lineLimit(1)

                HStack(spacing: Spacing.sm) {
                    Label(subscription.type.label, systemImage: subscription.type.icon)
                        .font(AppFont.caption())
                        .foregroundColor(.secondary)

                    Text("·")
                        .foregroundColor(.secondary)

                    Text(subscription.query)
                        .font(AppFont.caption())
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            // Item count badge
            VStack(spacing: 2) {
                Text("\(subscription.itemCount)")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(Color.fromHex(subscription.colorHex))
                Text("条")
                    .font(AppFont.caption2())
                    .foregroundColor(.secondary)
            }

            // Delete
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .font(.system(size: 15))
                    .foregroundColor(.red.opacity(0.7))
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, Spacing.md)
    }
}
