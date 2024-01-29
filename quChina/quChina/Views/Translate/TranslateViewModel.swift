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
    @Published var aimessage: String = ""
    @Published var isSpeaking: Bool = false
    @Published var isListening: Bool = false
    @AppStorage("savedCard") var savecards:  [WordCard] = []
    private var container: DIContainer

    private var subscriptions = Set<AnyCancellable>()
    init(container: DIContainer) {
        self.container = container
        container.services.speechRecognizer.$koreanTranscript
            .receive(on: DispatchQueue.main)
            .assign(to: &$koreanText)
        container.services.speechRecognizer.$chinesetranscript
            .receive(on: DispatchQueue.main)
            .assign(to: &$chineseText)
        container.services.speechRecognizer.$isSpeeaking
            .receive(on: DispatchQueue.main)
            .assign(to: &$isSpeaking)
        container.services.speechRecognizer.$isPlaying
            .receive(on: DispatchQueue.main)
            .assign(to: &$isListening)
    }

    func startSTT(lang: LanguagesType, aimode: Bool) async throws{
        isSpeaking.toggle()
        await container.services.speechRecognizer.startTranscribing(lang: lang)
        if aimode == true && lang == .chinese {
            try await container.services.aiService.sendPromptToGPT(message: "\(aimessage + chineseText)")
        }
    }

    func resetSTT() async {
        await container.services.speechRecognizer.stopTranscribing()
    }

    func startTTS(lang: LanguagesType) {
        container.services.speechRecognizer.speechSentences(lang == .chinese ? chineseText : koreanText, langType: lang)
    }
    func stopTTS() {
        container.services.speechRecognizer.stopSpeaking()
    }

    func translateKorean() {
        container.services.papagoService.postTranslation(source: "ko", target: "zh-CN", text: koreanText)
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] chinese in
                self?.chineseText = chinese
            }.store(in: &subscriptions)
    }
    func translateChinese() {
        container.services.papagoService.postTranslation(source: "zh-CN", target: "ko", text: chineseText)
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] korean in
                self?.koreanText = korean
            }.store(in: &subscriptions)
    }
    func save() {
        savecards.append(.init(id: .init(), chineseText: chineseText, koreanText: koreanText))
    }
}
