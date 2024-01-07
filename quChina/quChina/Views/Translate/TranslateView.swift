//
//  TranslateView.swift
//  quChina
//
//  Created by 235 on 1/1/24.
//

import SwiftUI

enum LanaguagesType: String {
    case korean = "Korean"
    case chinese = "Chinese"

    var placeholderString: String {
        switch self {
        case .korean:
            "번역하고 싶은 글자를 입력해주세요"
        case .chinese:
            "중국어를 입력해주세요"
        }
    }
}

struct TranslateView: View {
    @StateObject var viewModel : TranslateViewModel
    var body: some View {
        VStack(spacing: 0) {
            lanaguageBoxView(langtype: .korean, text: $viewModel.koreanText)
            Image(systemName: "arrow.up.arrow.down")
                .resizable()
                .frame(width: 32, height: 32)
                .padding()
            lanaguageBoxView(langtype: .chinese, text: $viewModel.chineseText)
        }.padding(.horizontal, 30)
    }
}

extension TranslateView {
    struct lanaguageBoxView: View {
        var langtype: LanaguagesType
        @Binding var text: String
        var body: some View {
            VStack(alignment: .leading) {
                Text(langtype.rawValue)
                    .font(.system(size: 14, weight: .medium))
                    .padding(.all, 8)
                ZStack {
                    if text.isEmpty {
                        TextEditor(text: .constant(langtype.placeholderString))
                            .font(.body)
                            .foregroundStyle(.gray)
                            .disabled(true)
                    }
                    TextEditor(text: $text)
                        .font(.body)
                        .opacity(text.isEmpty ? 0.25 : 1)

                }
            }.frame(height: 200)
            .overlay(Divider(), alignment: .top)
            .overlay(Divider(), alignment: .bottom)
            .overlay {
                    Button {

                    } label: {
                        Image(systemName: "mic")
                            .resizable()
                            .frame(width: 24, height: 24,  alignment: .trailing)
                            .foregroundStyle(Color.gray)
                            .padding(.all, 24)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                }
            }
        }
    }


#Preview {
    TranslateView(viewModel: .init())
}
