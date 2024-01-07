//
//  Date+.swift
//  quChina
//
//  Created by 235 on 1/1/24.
//

import Foundation

extension Date {
    static func dateToString(date: Date) -> String {

        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyyMMdd"
        return dateformatter.string(from: date)
    }
}
