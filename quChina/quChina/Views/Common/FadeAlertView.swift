//
//  FadeAlertView.swift
//  quChina
//
//  Created by 235 on 1/31/24.
//

import SwiftUI
struct FadeAlertView: View {

    @Binding var showAlert: Bool

    var body: some View {
        if showAlert {
            ZStack{
                Color.black.opacity(0.3).ignoresSafeArea()
                Text("저장되었습니다.")
                    .foregroundColor(.white)
                    .font(.system(size: 16))
                    .padding(.all, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.darkPurple)
                    )
            }
            .ignoresSafeArea()
            .onAppear(){
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        self.showAlert = false
                    }
                }
            }
        }
    }
}

#Preview {
    FadeAlertView(showAlert: .constant(true))
}
