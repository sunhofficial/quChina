//
//  NetworkError.swift
//  quChina
//
//  Created by 235 on 12/31/23.
//

import Foundation

enum NetworkError : Error {
    case invalidURL
    case noData
    case decodingError
    case requestFail
}
