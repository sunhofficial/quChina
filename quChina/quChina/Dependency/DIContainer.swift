//
//  Container.swift
//  quChina
//
//  Created by 235 on 1/25/24.
//

import Foundation

class DIContainer: ObservableObject {
    var services: ServicesType
    init(services: ServicesType) {
        self.services = services
    }
}
