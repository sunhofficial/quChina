//
//  Bundle+.swift
//  quChina
//
//  Created by 235 on 12/30/23.
//

import Foundation

extension Bundle {
    var openRateApiKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "SecretKey", ofType: "plist") else {
                fatalError("plist못찾겠어용")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "moenyRate_Key") as? String else {
                fatalError("key가있는거 맞아?")
            }
            return value
        }
    }
}
