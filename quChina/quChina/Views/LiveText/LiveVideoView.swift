//
//  LiveVideoView.swift
//  quChina
//
//  Created by 235 on 1/28/24.
//

import SwiftUI

struct LiveVideoView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: LiveViewViewModel
    @State private var voiceOn: Bool = true
    private var alertMessage: String {
        switch vm.datascannerAccessStatus {
        case .notDetermined:
            return "권한이 없습니다."
        case .cameraAccessNotGranted:
            return "카메라 권한이 없습니다."
        case .cameraNotAvailable:
            return "카메라가 사용 불가합니다."
        case .scannerNotAvailable:
            return "iOS 버전으로 인해 스캐너 사용이 불가합니다."
        case .scannerAvailable:
            return ""
        }
    }
    var body: some View {
        switch vm.datascannerAccessStatus {
        case .scannerAvailable:
            mainView
        default:
            EmptyView()
                .alert("", isPresented: .constant(true), actions: {
                    Button(alertMessage) {
                        dismiss()
                    }})
            }
        }

    private var mainView: some View {
        LiveTextView(isVoiceOn: $voiceOn)
            .background {
                Color.gray.opacity(0.2)
            }
            .overlay {
                VStack {
                    Spacer()
                        .frame(width: 40,height: 40)
                    Toggle("", isOn: $voiceOn)
                        .toggleStyle(CustomToggleStyle(imageString: "voice"))
                    Spacer()
                }
            }
            .ignoresSafeArea()
    }
    
}
