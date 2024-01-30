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
        NavigationStack{
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("내가 저장해놓은 단어들").font(.system(size: 16,weight: .bold))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {

                    }, label: {
                        Image(systemName: "plus")
                            .foregroundStyle(Color.darkPurple)
                    })
                }
            }
            .sheet(item: $viewModel.selectedCard) { card in
                CardEditView(cardModel: card, eraseBtnTap: {
                    viewModel.eraseCard(card.id)
                }, speakBtnTap: {
                    viewModel.readChinese(card)
                }, checkBtnTap:  {chineseText, koreanText in
                    let changeCard = WordCard(id: card.id, chineseText: chineseText, koreanText: koreanText)
                    viewModel.saveCard(card: changeCard)
                })
                    .presentationBackground(.clear)
            }.background(Color.yellowlight)
        }
    }
}
#Preview {
    SaveStoargeView(viewModel: .init(container: .init(services: Services())))
}
