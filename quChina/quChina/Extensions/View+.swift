//
//  View+.swift
//  quChina
//
//  Created by 235 on 1/18/24.
//

import SwiftUI
extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
