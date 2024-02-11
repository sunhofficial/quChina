//
//  LangagueType.swift
//  quChina
//
//  Created by 235 on 1/25/24.
//

import Foundation
enum LanguagesType: String {
    case korean = "Korean"
    case chinese = "Chinese"
    var langFlag: String {
        switch self {
        case .chinese:
            "Chinese 🇨🇳"
        case .korean:
            "Korean 🇰🇷"
        }
    }
    var placeholderString: String {
        switch self {
        case .korean:
            "번역하고 싶은 글자를 입력해주세요"
        case .chinese:
            "중국어를 입력해주세요"
        }
    }
    var papagosourceString: String {
        switch self {
        case .korean:
            "ko"
        case .chinese:
            "zh-CN"
        }
    }
}
