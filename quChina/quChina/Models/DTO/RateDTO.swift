//
//  RateDTO.swift
//  quChina
//
//  Created by 235 on 12/30/23.
//

import Foundation
// 1옌당 현재 이가격이다를 알려주는것 같음.
struct RateDTO: Decodable {
    var result: Int
    var curUnit: String
    var dealBasRate: String

    enum CodingKeys: String, CodingKey {
        case result
        case curUnit = "cur_unit"
        case dealBasRate = "deal_bas_r"
    }
}
