//
//  SaveStoargeView.swift
//  quChina
//
//  Created by 235 on 1/28/24.
//

import SwiftUI

struct SaveStoargeView: View {
    @ObservedObject var viewModel: SaveStoargeViewModel
    var colums = [GridItem(.adaptive(minimum: 160),spacing: 20)]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: colums , spacing: 20) {
                ForEach(viewModel.savedCard) {card in
                    CardView(chinaText: card.chineseText, koreanText: card.koreanText) {
                        viewModel.readChinese(card)
                    }.padding(.vertical,8).onTapGesture {
                        withAnimation {
                            viewModel.selectedCard = card
                        }
                    }
                }
            }
        }
        .sheet(item: $viewModel.selectedCard) { card in
            CardEditView(cardModel: card).presentationBackground(.clear)
        }
    }
}
#Preview {
    SaveStoargeView(viewModel: .init(container: .init(services: Services())))
}
