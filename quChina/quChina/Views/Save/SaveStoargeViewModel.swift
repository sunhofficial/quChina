//
//  SaveStoargeViewModel.swift
//  quChina
//
//  Created by 235 on 1/29/24.
//

import SwiftUI

class SaveStoargeViewModel: ObservableObject {
    @AppStorage("savedCard") var savedCard: [WordCard] = [
    ]
    private var container: DIContainer
    @Published var selectedCard: WordCard?
    init(container: DIContainer) {
        self.container = container
    }
    func readChinese(_ card: WordCard) {
        container.services.speechRecognizer.speechSentences(card.chineseText, langType: .chinese)
    }
    func eraseCard(_ id: UUID) {
        savedCard.removeAll {$0.id == id}
        selectedCard = nil
    }
    func saveCard(card: WordCard) {
        if let index = savedCard.firstIndex(where: { $0.id == card.id }) {
              savedCard[index] = card
          } else {
              savedCard.append(card)
          }
        selectedCard = nil
    }
}
