//
//  PapagoSevice.swift
//  quChina
//
//  Created by 235 on 1/8/24.
//

import SwiftUI
import Combine

protocol PapagoSeviceType {
    func postTranslation(source: String, target: String, text: String) -> AnyPublisher<String, NetworkError>
}
class PapagoSevice : PapagoSeviceType {
    let url =  URL(string: "https://naveropenapi.apigw.ntruss.com/nmt/v1/translation")
    func postTranslation(source: String, target: String, text: String) -> AnyPublisher<String, NetworkError> {
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue(Bundle.main.papagoIdKey[0], forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        request.setValue(Bundle.main.papagoIdKey[1], forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")
        let data = ["source": source, "target": target, "text": text] as [String: Any]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        request.httpBody = jsonData
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { data, response in
                print(data)
                print(response)
                return data
            }
            .decode(type: TranslationDTO.self, decoder: JSONDecoder())
            .tryMap { data in
                print(data)
                return data.message.result.translatedText
            }
            .mapError({ error in
                print(error)
                return NetworkError.decodingError
            })
            .eraseToAnyPublisher()
    }

}

