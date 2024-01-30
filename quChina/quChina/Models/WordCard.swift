//
//  SaveWord.swift
//  quChina
//
//  Created by 235 on 1/29/24.
//

import Foundation
struct WordCard: Hashable, Codable,Identifiable {
    var id: UUID
    var chineseText: String
    var koreanText: String
    mutating func updateCard(chineseText: String, koreantext: String) {
        self.chineseText = chineseText
        self.koreanText = koreantext
    }
}
