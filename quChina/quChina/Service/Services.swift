//
//  Services.swift
//  quChina
//
//  Created by 235 on 1/26/24.
//

import Foundation

protocol ServicesType {
    var aiService: AiServiceType {get set}
    var speechRecognizer: SpeechRecognizer {get set}
    var papagoService: PapagoSeviceType {get set}
}

class Services: ServicesType {
    var aiService: AiServiceType
    var speechRecognizer: SpeechRecognizer
    var papagoService: PapagoSeviceType
    init() {
        self.aiService = AiService()
        self.speechRecognizer = SpeechRecognizer()
        self.papagoService = PapagoSevice()
    }
}
