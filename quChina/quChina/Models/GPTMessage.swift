//
//  GPTRequestModel.swift
//  quChina
//
//  Created by 235 on 1/22/24.
//

import Foundation
struct GPTMessage: Encodable {
    let role: String
    let content: String
}
struct GPTRequest: Encodable {
    let model: String
    let messages: [GPTMessage]
}
