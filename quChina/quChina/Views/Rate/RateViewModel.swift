//
//  RateViewModel.swift
//  quChina
//
//  Created by 235 on 12/30/23.
//

import SwiftUI
import Combine

@MainActor
class RateViewModel: ObservableObject {
    @Published var searchPrice: Decimal? {
        didSet {
            self.changetoWon = (searchPrice ?? 1) * (rateWon ?? 180)
        }
    }
    @Published var changetoWon: Decimal?
    @Published var yuanWonDict: [Decimal: Decimal] = [:]
    private var yuanLists: [Decimal] = [10, 20 ,50, 250, 299, 399, 499, 699, 1250,3500, 7777,10000]
    private var rateService: RateService
    private var subscriptions = Set<AnyCancellable>()
    private var rateWon: Decimal? {
        didSet {
            calculateYuantoWon()
        }
    }
    init(rateService: RateService) {
        self.rateService = rateService
        getWon()
    }

    func getWon() {
        rateService.getCurrentRate()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] won in
                print(won)
                self?.rateWon = won
                self?.changetoWon = (self?.searchPrice ?? 1) * (self?.rateWon!)!
            }.store(in: &subscriptions)
    }

    private func calculateYuantoWon() {
        guard let rate = rateWon else { return }
        for yuan in yuanLists {
            let convertedValue = yuan * rate
            yuanWonDict[yuan] = convertedValue
        }
    }
}
