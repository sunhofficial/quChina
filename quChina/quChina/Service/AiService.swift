//
//  AiService.swift
//  quChina
//
//  Created by 235 on 1/21/24.
//

import SwiftUI

import OpenAI

protocol AiServiceType {
    func generateURLPostRequest(prompt: String) throws -> URLRequest
    func sendPromptToGPT(message: String) async throws

}
class AiService: AiServiceType {
    let openAiURL = URL(string: "https://api.openai.com/v1/chat/completions")!
    func generateURLPostRequest(prompt: String) throws -> URLRequest {
        var request = URLRequest(url: openAiURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(Bundle.main.aiKey)", forHTTPHeaderField: "Authorization")
        let systemMessage = GPTMessage(role: "system", content: "나는 한국어를 할수 있고 중국어를 못하는 한국인이야.그런데 이번에 중국여행을 오게 되었어. 그래서 맛집에서 주문할때나 길찾기 할때 사람들에게 물어보는거 포함해서 다양한 회화에 어려움을 겪고 있어. 내가 원하는 상황과 상대방의 중국어를 줄꺼야. 그러면 너가 그것의 반응이나 다음 대화까지 만들어서 보여줘 한국어랑 중국어 전부")
        let userMessage = GPTMessage(role: "user", content: prompt)
        let payload = GPTRequest(model: "gpt-3.5-turbo", messages: [systemMessage,userMessage])
        let jsonData = try JSONEncoder().encode(payload)
        request.httpBody = jsonData
        return request
    }

    func sendPromptToGPT(message: String) async throws {
        let urlRequest = try generateURLPostRequest(prompt: message)
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        print(String(data: data, encoding: .utf8)!)
    }



}
