import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var tab: Int = 0
    @Published var subs: [UserSub] = []
    @Published var cards: [FeedCard] = []
    @Published var filter: String? = nil   // subKey
    @Published var toast: String = ""

    var filteredCards: [FeedCard] {
        guard let f = filter else { return cards }
        return cards.filter { $0.subKey == f }
    }

    func addSub(_ template: SubTemplate) {
        guard !subs.contains(where: { $0.template == template }) else { return }
        let sub = UserSub(id: UUID(), template: template, addedAt: Date())
        subs.insert(sub, at: 0)
        let newCards = (AppData.mockCards[template.id] ?? [])
        cards.insert(contentsOf: newCards, at: 0)
        showToast("已添加「\(template.name)」订阅 ✓")
    }

    func removeSub(_ sub: UserSub) {
        subs.removeAll { $0.id == sub.id }
        cards.removeAll { $0.subKey == sub.template.id }
        if filter == sub.template.id { filter = nil }
    }

    func showToast(_ msg: String) {
        toast = msg
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
            if self.toast == msg { self.toast = "" }
        }
    }
}
