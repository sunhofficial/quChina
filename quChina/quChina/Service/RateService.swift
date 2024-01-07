//
//  RateService.swift
//  quChina
//
//  Created by 235 on 12/31/23.
//

import Foundation
import Combine

protocol RateServiceType {
    func getCurrentRate(date: Date) -> AnyPublisher<Decimal, NetworkError>
//    func convertWonToYuan() -> Double
}
final class RateService: RateServiceType {
    var urlComponents = URLComponents(string:  "https://www.koreaexim.go.kr/site/program/financial/exchangeJSON")
    func getCurrentRate(date: Date = Date()) -> AnyPublisher<Decimal, NetworkError> {
        urlComponents?.queryItems = [URLQueryItem(name: "authkey", value: Bundle.main.openRateApiKey),
                                     URLQueryItem(name: "searchdate", value: Date.dateToString(date: date)),
                                     URLQueryItem(name: "data", value: "AP01")]
        let url = urlComponents?.url
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: [RateDTO].self, decoder: JSONDecoder())
            .tryMap { rateInfos in
                guard let dealBasRate = rateInfos.first(where: { $0.curUnit == "CNH" })?.dealBasRate else {
                    throw NetworkError.noData
                }
                guard let decimalval = Decimal(string: dealBasRate) else {
                    throw NetworkError.noData
                }
                return decimalval
            }
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                } else {
                    return NetworkError.noData
                }
            }
            .catch({ error -> AnyPublisher<Decimal, NetworkError> in
                if case NetworkError.noData = error {
                    guard let previousDay = Calendar.current.date(byAdding: .day, value: -1, to: date) else {
                        return Fail(error: NetworkError.requestFail).eraseToAnyPublisher()
                    }
                    return self.getCurrentRate(date: previousDay)
                }
                return Fail(error: error).eraseToAnyPublisher()
            })
            .eraseToAnyPublisher()
    }
}
