//
//  CardView.swift
//  quChina
//
//  Created by 235 on 1/28/24.
//

import SwiftUI
struct CardView: View {
    var chinaText: String
    var koreanText: String
    @Binding var isSavedComplete: Bool
    var touchSpeaker: () -> Void

    private let pasteboard = UIPasteboard.general
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                    Text(chinaText)
                        .foregroundStyle(Color.white)
                        .font(.system(size: 24, weight: .semibold))
                        .frame(width: 180, height: 72)
                        .background(Color.brandred)
                        .overlay {
                            HStack{
                                Spacer()
                                VStack {
                                    Button(action: {

                                        pasteboard.string = chinaText
                                        isSavedComplete = true
                                    
                                    }, label: {
                                        Image(systemName: "doc.on.clipboard")
                                            .resizable()
                                            .foregroundStyle(Color.white)
                                            .frame(width: 16,height: 16)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                    })
                                    
                                    Button(action: {
                                        touchSpeaker()
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
                    

                Text(koreanText)
                    .font(.system(size: 16))
                    .padding(.all, 8)
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 8)
        
    }
}

//#Preview {
//    CardView(chinaText: "酸", koreanText: "음식을 처먹다") {
//        print("hi")
//    }
//}
