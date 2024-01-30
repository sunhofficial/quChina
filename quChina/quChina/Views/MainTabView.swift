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
    case stoarge
    var title: String {
        switch self {
        case .wonchange:
            "환율"
        case .voice:
            "음성인식"
        case .stoarge:
            "저장소"
        }
    }

    var labelImage: String {
        switch self {
        case .wonchange:
            "wonsign.arrow.circlepath"
        case .voice:
            "waveform"
        case .stoarge:
            "star"
        }
    }
}
struct MainTabView: View {
    @State private var tabState: MainTabType = .voice
    @StateObject private var container: DIContainer = .init(services: Services())
    private var papagoservice = PapagoSevice()
    var body: some View {
        TabView(selection: $tabState) {
            ForEach(MainTabType.allCases, id: \.self) { tab in
                Group {
                    switch tab {
                    case .wonchange:
                        NavigationStack {
                            RateView(viewModel: .init(rateService: RateService()))
                                .navigationBarTitleDisplayMode(.inline)
                                .toolbar {
                                    ToolbarItem(placement: .principal) {
                                        Text("중국환율계산").font(.system(size: 16,weight: .bold))
                                    }
                                }
                        }
                    case .voice:
                        TranslateView(viewModel: .init(container: container))
                            .environmentObject(container)
                    case .stoarge:
                            SaveStoargeView(viewModel: .init(container: container))
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
