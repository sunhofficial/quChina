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
    private var papagoSevice: PapagoSevice
    private var speechSevice = SpeechRecognizer()
    private var aiService = AiService()
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
        speechSevice.$isPlaying
            .receive(on: DispatchQueue.main)
            .assign(to: &$isListening)
    }

    func startSTT(lang: LanguagesType, aimode: Bool) async throws{
        isSpeaking.toggle()
        await speechSevice.startTranscribing(lang: lang)
        if aimode == true && lang == .chinese {
            try await aiService.sendPromptToGPT(message: "\(aimessage + chineseText)")
        }
    }

    func resetSTT() async {
        await speechSevice.stopTranscribing()
    }

    func startTTS(lang: LanguagesType) {
        speechSevice.speechSentences(lang == .chinese ? chineseText : koreanText, langType: lang)
    }
    func stopTTS() {
        speechSevice.stopSpeaking()
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
