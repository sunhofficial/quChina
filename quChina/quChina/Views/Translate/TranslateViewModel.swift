//
//  TranslateViewModel.swift
//  quChina
//
//  Created by 235 on 1/7/24.
//

import SwiftUI

class TranslateViewModel: ObservableObject {
    @Published var koreanText: String = ""
    @Published var chineseText: String = ""
}
