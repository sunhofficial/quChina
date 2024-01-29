//
//  TranslateView.swift
//  quChina
//
//  Created by 235 on 1/1/24.
//

import SwiftUI



struct TranslateView: View {

    @StateObject var viewModel : TranslateViewModel
    @FocusState private var focusField: LanguagesType?
    @FocusState private var chinesefocused: Bool
    @State private var aiMode = false
    @State private var goToCamera = false
    @EnvironmentObject var container: DIContainer
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Spacer()
                    if aiMode == true {
                        TextField("", text: $viewModel.aimessage, prompt: Text("ex) 상하이 현지인들의 맛집을 알고싶어").font(.system(size: 12)))
                            .textFieldStyle(.roundedBorder)
                    }
                    Toggle("", isOn: $aiMode)
                        .toggleStyle(CustomToggleStyle(imageString: "robot"))
                }
                noticeTextView
                lanaguageBoxView(langtype: .korean, text: $viewModel.koreanText, isFocused: _focusField, isSpeaking: $viewModel.isSpeaking) {
                    Task {
                        try await viewModel.startSTT(lang:.korean, aimode: aiMode)
                    }
                } listeningAction: {
                    viewModel.startTTS(lang: .korean)
                }
                Image(systemName: "arrow.up.arrow.down")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .padding()
                lanaguageBoxView(langtype: .chinese, text: $viewModel.chineseText, isFocused: _focusField, isSpeaking: $viewModel.isSpeaking) {
                    Task {
                        try await viewModel.startSTT(lang:.chinese, aimode: aiMode)
                    }
                } listeningAction: {
                    viewModel.startTTS(lang: .chinese)
                }
                Spacer()
                VoiceAnimationView(isSpeaking: $viewModel.isSpeaking) {
                    Task {
                        await viewModel.resetSTT()
                    }
                }
            }
            .onTapGesture {
                endTextEditing()
            }.padding(.horizontal, 30)
                .onChange(of: focusField) { oldValue, newValue in
                    if oldValue == .korean {
                        viewModel.translateKorean()
                    } else if oldValue == .chinese{
                        viewModel.translateChinese()
                    }
                }.navigationDestination(isPresented: $goToCamera) {
                    LiveVideoView(vm: .init())
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {goToCamera.toggle()}, label: {
                            Image(systemName: "camera.viewfinder")
                        })
                    }
                }
        }

    }
}

extension TranslateView {
    enum FocusedField: Hashable {
        case korean
        case chinese
    }
    var saveButton: some View {
        Button(action: {
            viewModel.save()
        }, label: {
            HStack {
                Image(systemName: "star")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(.white)
                Text("Save")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
            }.background(Color.redBrand)
        })
    }
    struct VoiceAnimationView: View {
        @State private var firstcircleScale: CGFloat = 1.0
        @Binding var isSpeaking: Bool
        var ontapButton: () -> Void
        var body: some View {
            if isSpeaking {
                Button(action: {
                    isSpeaking.toggle()
                    ontapButton()
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

    @ViewBuilder
    var noticeTextView: some View {
        if aiMode == true {
            HStack {
                Text("중국어를 입력하면 자동으로 다음 대화를 추천해줍니다.")
                    .font(.system(size: 12))
                Spacer()
            }.padding(10)
        }
    }
    struct lanaguageBoxView: View {
        var langtype: LanguagesType
        @Binding var text: String
        @FocusState var isFocused: LanguagesType?
        @Binding var isSpeaking: Bool
        var speakingAction: () -> Void
        var listeningAction: () -> Void
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
            }.frame(height: 160)
            .overlay(Divider(), alignment: .top)
            .overlay(Divider(), alignment: .bottom)
            .onChange(of: text) { old, new in
                       if !text.filter({ $0.isNewline }).isEmpty {
                           isFocused = nil
                       }
                   }
            .overlay {
                VStack {
                    Spacer()
                    HStack(spacing: 0) {
                        Spacer()
                        Button {
                            listeningAction()
                            isFocused = nil
                        } label: {
                            Image(systemName: "speaker.wave.3")
                                .resizable()
                                .frame(width: 24, height: 24,  alignment: .trailing)
                                .foregroundStyle(Color.gray)
                                .padding(.all, 8)
                        }
                        Button {
                            speakingAction()
                            isFocused = nil
                        } label: {
                            Image(systemName: "mic")
                                .resizable()
                                .frame(width: 24, height: 24,  alignment: .trailing)
                                .foregroundStyle(Color.gray)
                                .padding(.all, 8)
                        }
                        .disabled(isSpeaking)
                    }
                }}
            }
        }
    }

