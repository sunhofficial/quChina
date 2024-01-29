//
//  SaveStoargeViewModel.swift
//  quChina
//
//  Created by 235 on 1/29/24.
//

import SwiftUI

class SaveStoargeViewModel: ObservableObject {
    @AppStorage("savedCard") var savedCard: [WordCard] = [
        .init(id: .init(), chineseText: "hiuhi", koreanText: "hih"),
        .init(id: .init(), chineseText: "xihuan", koreanText: "hih"),
        .init(id: .init(), chineseText: "andil", koreanText: "hih"),
        .init(id: .init(), chineseText: "hoiut", koreanText: "hih"),
        .init(id: .init(), chineseText: "fuck", koreanText: "hih"),
        .init(id: .init(), chineseText: "fuckyou", koreanText: "hih")
    ]
    private var container: DIContainer
    @Published var selectedCard: WordCard?
    init(container: DIContainer) {
        self.container = container
    }
    func readChinese(_ card: WordCard) {
        container.services.speechRecognizer.speechSentences(card.chineseText, langType: .chinese)
    }
}
