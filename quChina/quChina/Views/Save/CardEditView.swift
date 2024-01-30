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
    var eraseBtnTap: (() -> Void)
    var speakBtnTap: (() -> Void)
    var checkBtnTap: ((_ chinese: String, _ korean: String) -> Void)
    init(cardModel: WordCard, eraseBtnTap: @escaping () -> Void, speakBtnTap: @escaping () -> Void, checkBtnTap: @escaping (_: String, _: String) -> Void) {
        self.cardModel = cardModel

            _chineseText = State(initialValue: cardModel.chineseText)
            _koreanText = State(initialValue: cardModel.koreanText)
        self.eraseBtnTap = eraseBtnTap
        self.speakBtnTap = speakBtnTap
        self.checkBtnTap = checkBtnTap
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
                                eraseBtnTap()
                            }, label: {
                                Image(systemName: "xmark.bin")
                                    .resizable()
                                    .foregroundStyle(Color.white)
                                    .frame(width: 16,height: 16)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                            })
                            Button(action: {
//                                cardModel.updateCard(chineseText: chineseText, koreantext: koreanText)
                                speakBtnTap()
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
                Button(action: {
                    checkBtnTap(chineseText, koreanText)
                }, label: {
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
//extension CardEditView {
//    mutating func update() {
//        cardModel.updateCard(chineseText: chineseText, koreantext: koreanText)
//    }
//}
//extension CardEditView {
//    func onEraseTap(action: @escaping (()-> Void)) -> CardEditView {
//        CardEditView(cardModel: cardModel, eraseBtnTap: action,speakBtnTap: speakBtnTap, checkBtnTap: checkBtnTap)
//    }
//}
//#Preview {
//    CardEditView(cardModel: .init(id: .init(), chineseText: "NIhao", koreanText: "fdaioj"))
//}
