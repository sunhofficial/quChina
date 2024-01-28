//
//  String+\.swift
//  quChina
//
//  Created by 235 on 1/1/24.
//

import Foundation

extension String {
    static func extractChinese(from input: String) -> String {
        do {
            let regex = try NSRegularExpression(pattern: "[\\p{Script=Han}]+", options: .caseInsensitive)
            let matches = regex.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))

            let chineseCharacters = matches.map {
                (input as NSString).substring(with: $0.range)
            }

            return chineseCharacters.joined(separator: "")
        } catch {
            print("Error creating regex: \(error)")
            return ""
        }
    }
}
