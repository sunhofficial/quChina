//
//  Bundle+.swift
//  quChina
//
//  Created by 235 on 12/30/23.
//

import Foundation

extension Bundle {
    private func loadfilePath() -> NSDictionary {
        guard let filePath = Bundle.main.path(forResource: "SecretKey", ofType: "plist") else {
            fatalError("plist못찾겠어용")
        }
        guard let plist = NSDictionary(contentsOfFile: filePath) else {
               fatalError("plist를 읽을 수 없습니다.")
           }
        return plist
    }
    var openRateApiKey: String {
        get {
            guard let value = loadfilePath().object(forKey: "moenyRate_Key") as? String else {
                fatalError("key가있는거 맞아?")
            }
            return value
        }
    }
    var papagoIdKey: [String] {
        get {
            guard let id = loadfilePath().object(forKey: "papago_ID") as? String, let key = loadfilePath().object(forKey: "papago_Key") as? String else {
                fatalError("id, key가있는거 맞아?")
            }
            return [id,key]
        }
    }
    var aiKey: String {
        get {
            guard let key = loadfilePath().object(forKey: "openAI_Key") as? String else {
                fatalError("key값이 제대로 있나요")
            }
            return key
        }
    }
}
