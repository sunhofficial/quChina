//
//  TranslateViewModel.swift
//  quChina
//
//  Created by 235 on 1/7/24.
//

import SwiftUI
import Combine
class TranslateViewModel: ObservableObject {
    @Published var koreanText: String = ""
    @Published var chineseText: String = ""
    private var papagoSevice: PapagoSevice
    private var subscriptions = Set<AnyCancellable>()
    init(papagoSevice: PapagoSevice) {
        self.papagoSevice = papagoSevice
    }

    func translateKorean() {
        papagoSevice.postTranslation(source: "ko", target: "zh-CN", text: koreanText)
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] chinese in
                self?.chineseText = chinese
            }.store(in: &subscriptions)
    }
    func translateChinese() {
        papagoSevice.postTranslation(source: "zh-CN", target: "ko", text: chineseText)
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] korean in
                self?.koreanText = korean
            }.store(in: &subscriptions)
    }
}
