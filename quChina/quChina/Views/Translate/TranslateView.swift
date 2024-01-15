//
//  TranslateView.swift
//  quChina
//
//  Created by 235 on 1/1/24.
//

import SwiftUI

enum LanguagesType: String {
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
    @FocusState private var focusField: LanguagesType?
    @FocusState private var chinesefocused: Bool
    var body: some View {
        VStack(spacing: 0) {
            lanaguageBoxView(langtype: .korean, text: $viewModel.koreanText, isFocused: _focusField) {
                Task {
                    await viewModel.startSTT(lang:.korean)
                }
            }
            Image(systemName: "arrow.up.arrow.down")
                .resizable()
                .frame(width: 32, height: 32)
                .padding()
            lanaguageBoxView(langtype: .chinese, text: $viewModel.chineseText, isFocused: _focusField) {
                Task {
                    await viewModel.startSTT(lang:.korean)
                }
            }
            VoiceAnimationView(isSpeaking: $viewModel.isSpeaking)
        }.padding(.horizontal, 30)
            .onChange(of: focusField) { oldValue, newValue in
                if oldValue == .korean {
                    viewModel.translateKorean()
                } else if oldValue == .chinese{
                    viewModel.translateChinese()
                }
            }
    }
}

extension TranslateView {
    enum FocusedField: Hashable {
        case korean
        case chinese
    }
    struct VoiceAnimationView: View {
        @State private var firstcircleScale: CGFloat = 1.0
        @Binding var isSpeaking: Bool
        var body: some View {
            if isSpeaking {
                Button(action: {
                    isSpeaking.toggle()
                }, label: {
                    ZStack {
                        Circle()
                            .frame(width: 60, height: 60)
                            .scaleEffect(firstcircleScale)
                            .foregroundStyle(Color.brandred)
                            .blur(radius: 8.0)
                            .opacity(0.8)
                            .animation(.easeInOut(duration: 1).repeatForever(), value: firstcircleScale)
                            .overlay {
                                Circle()
                                    .frame(width: 40, height: 40)
                                    .scaleEffect(firstcircleScale)
                                    .foregroundStyle(Color.brandred)
                                    .blur(radius: 4.0)
                                    .animation(.easeInOut(duration: 1).repeatForever(), value: firstcircleScale)
                            }
                            .onAppear {
                                firstcircleScale = 1.5
                            }
                        Image(systemName: "pause.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(Color.brandred, Color.white)
                    }
                })
            }


        }
    }
    struct lanaguageBoxView: View {
        var langtype: LanguagesType
        @Binding var text: String
        @FocusState var isFocused: LanguagesType?
        var onsubmit: () -> Void
        var body: some View {
            VStack(alignment: .leading) {
                Text(langtype.rawValue)
                    .font(.system(size: 14, weight: .medium))
                    .padding(.all, 8)
                ZStack {
                    if text.isEmpty {
                        TextEditor(text: .constant(langtype.placeholderString))
                            .focused($isFocused, equals: langtype)
                            .font(.body)
                            .foregroundStyle(.gray)
                            .disabled(true)
                    }
                    TextEditor(text: $text)
                        .font(.body)
                        .focused($isFocused, equals: langtype)
                        .opacity(text.isEmpty ? 0.25 : 1)
                }
            }.frame(height: 200)
            .overlay(Divider(), alignment: .top)
            .overlay(Divider(), alignment: .bottom)
            .overlay {
                    Button {
                        onsubmit()
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
    TranslateView(viewModel: .init(papagoSevice: .init()))
}
