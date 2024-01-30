//
//  CardEditView.swift
//  quChina
//
//  Created by 235 on 1/29/24.
//

import SwiftUI

struct CardEditView: View {
    @Environment(\.dismiss) private var dismiss
    var cardModel: WordCard
    @State private var keyboardHeight: CGFloat = 0
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
        ZStack{
            Color.black.opacity(0.5)
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
                            .frame(width: 48, height: 48)
                            .padding(.bottom, 4)
                    })
                    Spacer()
                }

            }
            .frame(maxHeight: 320)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 16)
            .padding(.horizontal, 32)
            .offset(y: -keyboardHeight) // Offset based on keyboard height
        }.ignoresSafeArea()
            .onAppear {
                     NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                         if let keyboardRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                             keyboardHeight = keyboardRect.height / 2
                         }
                     }
                     NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                         keyboardHeight = 0
                     }
                 }
            .onDisappear {
                      NotificationCenter.default.removeObserver(self)
                  }
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
