//
//  CardEditView.swift
//  quChina
//
//  Created by 235 on 1/29/24.
//

import SwiftUI

struct CardEditView: View {
    var cardModel: WordCard
    @State var chineseText: String
    @State var koreanText: String
    init(cardModel: WordCard) {
            self.cardModel = cardModel
            _chineseText = State(initialValue: cardModel.chineseText)
        _koreanText = State(initialValue: cardModel.koreanText)
        }
    var body: some View {
        VStack(alignment: .leading){
            TextField("", text: $chineseText)
                    .foregroundStyle(Color.white)
                    .font(.system(size: 32, weight: .semibold))
                   .padding(.vertical, 32)
                    .padding(.leading, 8)
                    .background(Color.brandred)
                    .overlay {
                        HStack{
                            Spacer()
                            VStack {
                                Button(action: {

                                }, label: {
                                    Image(systemName: "xmark.bin")
                                        .resizable()
                                        .foregroundStyle(Color.white)
                                        .frame(width: 16,height: 16)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                })

                                Button(action: {

                                }, label: {
                                    Image(systemName: "speaker.wave.1")
                                        .resizable()
                                        .foregroundStyle(Color.white)
                                        .frame(width: 16,height: 16)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                })
                            }}
                    }

            TextEditor(text: $koreanText)
                .font(.system(size: 16))
                .padding(.horizontal, 8)
            HStack {
                Spacer()
                Button(action: {}, label: {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                })
                Spacer()
            }
        }
        .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 16)
            .padding(.horizontal, 32)
            .padding(.vertical, 248)
    }
}

#Preview {
    CardEditView(cardModel: .init(id: .init(), chineseText: "NIhao", koreanText: "fdaioj"))
}
