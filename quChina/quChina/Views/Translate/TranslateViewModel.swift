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
    @Published var isSpeaking: Bool = false
    private var papagoSevice: PapagoSevice
    private var speechSevice = SpeechRecognizer()
    private var subscriptions = Set<AnyCancellable>()
    init(papagoSevice: PapagoSevice) {
        self.papagoSevice = papagoSevice
        speechSevice.$koreanTranscript
            .receive(on: DispatchQueue.main)
            .assign(to: &$koreanText)
        speechSevice.$chinesetranscript
            .receive(on: DispatchQueue.main)
            .assign(to: &$chineseText)
        speechSevice.$isSpeeaking
            .receive(on: DispatchQueue.main)
            .assign(to: &$isSpeaking)
    }

    func startSTT(lang: LanguagesType) async {
        isSpeaking.toggle()
        await speechSevice.startTranscribing(lang: lang)
    }

    func resetSTT() async {
        await speechSevice.stopTranscribing()
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
