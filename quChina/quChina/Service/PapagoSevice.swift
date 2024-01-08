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
    var urlComponents =  URLComponents(string: "https://naveropenapi.apigw.ntruss.com/nmt/v1/translation")
    func postTranslation(source: String, target: String, text: String) -> AnyPublisher<String, NetworkError> {
        <#code#>
    }
    
    
}

