//
//  TranslationDTO.swift
//  quChina
//
//  Created by 235 on 1/9/24.
//

import Foundation

struct TranslationDTO: Decodable {
    let message: Result
}
struct Result: Decodable {
    let result: TranslationInfo
}
struct TranslationInfo: Decodable{
    let srcLangType: String
    let tarLangType: String
    let translatedText: String
}
