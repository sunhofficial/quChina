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
                        focusField = nil
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
                        focusField = nil
                    }
                } listeningAction: {
                    viewModel.startTTS(lang: .chinese)
                }
                Spacer()
                    .frame(width: 100, height: 60)
                if !viewModel.isSpeaking {
                    saveButton
                }
                Spacer()

                VoiceAnimationView(isSpeaking: $viewModel.isSpeaking) {
                    Task {
                        await viewModel.resetSTT(lang: viewModel.currentLang)
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
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundStyle(Color.black)
                        })
                    }
                    ToolbarItem(placement: .principal) {
                        Text("번역기능").font(.system(size: 16,weight: .bold))
                    }
                }.background(Color.yellowlight)
                .alert("저장소에 보관완료", isPresented: $viewModel.succcessSave) {
                    Button("OK") {
                        viewModel.succcessSave.toggle()
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
                    .foregroundStyle(.redBrand)
                Text("Save")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.redBrand)
            }
                .frame(width: 160, height: 52)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.redBrand, lineWidth: 2)
                        .shadow(radius: 10)
                }
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
                Text(langtype.langFlag)
                    .font(.system(size: 14, weight: .medium))
                    .padding(.all, 8)
                ZStack {
                    if text.isEmpty {
                        TextEditor(text: .constant(langtype.placeholderString))
                            .clipShape(.rect(cornerRadius: 10))
                            .focused($isFocused, equals: langtype)
                            .font(.body)
                            .foregroundStyle(.gray).background(Color.yellowlight)
                            .disabled(true)

                    }
                    TextEditor(text: $text)
                        .clipShape(.rect(cornerRadius: 10))
                        .font(.body)
                        .focused($isFocused, equals: langtype).background(Color.yellowlight)
                        .opacity(text.isEmpty ? 0.25 : 1)
                }
            }.frame(height: 160)
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

