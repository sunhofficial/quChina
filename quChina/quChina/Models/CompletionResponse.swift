//
//  CompletionResponse.swift
//  quChina
//
//  Created by 235 on 1/21/24.
//

import Foundation
import OpenAI

struct CompletionsResult: Codable, Equatable {
    public struct Choice: Codable, Equatable {
        public let text: String
        public let index: Int
    }    
    public struct Usage: Codable, Equatable {
        public let promptTokens: Int
        public let completionTokens: Int
        public let totalTokens: Int
    }

    public let id: String
    public let object: String
    public let created: TimeInterval
    public let model: Model
    public let choices: [Choice]
    public let usage: Usage
}
