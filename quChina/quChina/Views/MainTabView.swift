//
//  MainTabView.swift
//  quChina
//
//  Created by 235 on 12/30/23.
//

import SwiftUI

enum MainTabType: CaseIterable{
    case wonchange
    case voice

    var title: String {
        switch self {
        case .wonchange:
            "환율"
        case .voice:
            "음성인식"
        }
    }

    var labelImage: String {
        switch self {
        case .wonchange:
            "wonsign.arrow.circlepath"
        case .voice:
            "waveform"
        }
    }
}
struct MainTabView: View {
    @State private var tabState: MainTabType = .wonchange
    @StateObject private var container: DIContainer = .init(services: Services())
    private var papagoservice = PapagoSevice()
    var body: some View {
        TabView(selection: $tabState) {
            ForEach(MainTabType.allCases, id: \.self) { tab in
                Group {
                    switch tab {
                    case .wonchange:
                        RateView(viewModel: .init(rateService: RateService()))
                    case .voice:
                        TranslateView(viewModel: .init(container: container))
                            .environmentObject(container)
                    }
                }.tabItem { Label(tab.title, systemImage: tab.labelImage) }
                    .tag(tab)
            }
        }
    }

}

#Preview {
    MainTabView()
}
