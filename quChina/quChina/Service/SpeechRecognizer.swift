//
//  SpeechRecognizer.swift
//  quChina
//
//  Created by 235 on 1/11/24.
//

import Foundation
import AVFoundation
import Speech
import SwiftUI


/// A helper for transcribing speech to text using SFSpeechRecognizer and AVAudioEngine.
final class SpeechRecognizer: ObservableObject {
    enum RecognizerError: Error {
        case nilRecognizer
        case notAuthorizedToRecognize
        case notPermittedToRecord
        case recognizerIsUnavailable

        var message: String {
            switch self {
            case .nilRecognizer: return "Can't initialize speech recognizer"
            case .notAuthorizedToRecognize: return "Not authorized to recognize speech"
            case .notPermittedToRecord: return "Not permitted to record audio"
            case .recognizerIsUnavailable: return "Recognizer is unavailable"
            }
        }
    }

    @Published var koreanTranscript: String = ""
    @Published var chinesetranscript: String = ""
    @Published var isSpeeaking: Bool = false
    private let audioEngine: AVAudioEngine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private var recognizer: SFSpeechRecognizer?
    private var currentlanguage: LanguagesType = .korean
    private var langRecognizer: SFSpeechRecognizer {
        currentlanguage == .chinese ?  SFSpeechRecognizer(locale: Locale(identifier: "zh-Hans-CN"))! : SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))!
    }
//    private let koreanRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))!
//    private let chineseRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-Hans-CN"))!

    /**
     Initializes a new speech recognizer. If this is the first time you've used the class, it
     requests access to the speech recognizer and the microphone.
     */
    init() {
        Task {
            do {
                guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
                    throw RecognizerError.notAuthorizedToRecognize
                }
                guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
                    throw RecognizerError.notPermittedToRecord
                }
            } catch {
                transcribe(error)
            }
        }
        do {
            try prepareAudioSession()
        } catch {
            transcribe(error)
        }
    }

    @MainActor func startTranscribing(lang : LanguagesType) {
        Task {
            reset()
            await changelang(lang: lang)
            await transcribe()
        }
    }

    @MainActor func resetTranscript() {
            reset()
    }
    
    func changelang(lang: LanguagesType) async{
        currentlanguage = lang
    }

    @MainActor func stopTranscribing() {
        Task {
            audioEngine.stop
        }
    }

    private func transcribe() async {
        do {
            prepareRequest()
            prepareInputNode()
            try startAudioEngine()
            guard let request = request else {return}
            self.task = langRecognizer.recognitionTask(with: request, resultHandler: { [weak self] result, error in
                self?.recognitionHandler(result: result, error: error)})
        } catch {
            self.reset()
            self.transcribe(error)
        }
    }

    /// Reset the speech recognizer.
    private func reset()  {
        task?.cancel()
        request = nil
        task = nil
    }
    private func startAudioEngine() throws {
        audioEngine.prepare()
        try audioEngine.start()
    }

    private func prepareInputNode() {
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.request?.append(buffer)
        }
    }
    private func prepareRequest() {
        request = SFSpeechAudioBufferRecognitionRequest()
        guard let request else {return}
        request.shouldReportPartialResults = true
        request.addsPunctuation = true
    }

    private func prepareAudioSession() throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    }

    nonisolated private func recognitionHandler(result: SFSpeechRecognitionResult?, error: Error?) {
        let receivedFinalResult = result?.isFinal ?? false
        let receivedError = error != nil

        if receivedFinalResult || receivedError {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }

        if let result {
            transcribe(result.bestTranscription.formattedString)
        }
    }


    nonisolated private func transcribe(_ message: String) {
        Task { @MainActor in
            switch currentlanguage {
            case .korean:
                koreanTranscript = message
            case .chinese:
                chinesetranscript = message
            }

        }
    }
    nonisolated private func transcribe(_ error: Error) {
        var errorMessage = ""
        if let error = error as? RecognizerError {
            errorMessage += error.message
        } else {
            errorMessage += error.localizedDescription
        }
        Task { @MainActor [errorMessage] in
            koreanTranscript = "<< \(errorMessage) >>"
        }
    }
}


extension SFSpeechRecognizer {
    static func hasAuthorizationToRecognize() async -> Bool {
        await withCheckedContinuation { continuation in
            requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
}


extension AVAudioSession {
    func hasPermissionToRecord() async -> Bool {
        await withCheckedContinuation { continuation in
            requestRecordPermission { authorized in
                continuation.resume(returning: authorized)
            }
        }
    }
}
