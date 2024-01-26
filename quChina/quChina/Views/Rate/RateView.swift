//
//  RateView.swift
//  quChina
//
//  Created by 235 on 12/30/23.
//

import SwiftUI

struct RateView: View {
    @StateObject var viewModel: RateViewModel
    @FocusState var textfieldState: Bool
    var body: some View {
        VStack(spacing: 0) {
            searchField
                .padding()
            Divider()
            resultView
                .padding(.bottom, 130)
            priceInfoView
        }.onTapGesture {
            endTextEditing()
        }
    }
}

extension RateView {
    var searchField: some View {
        TextField("Input 元", value: $viewModel.searchPrice, format: .currency(code: "CNY"))
            .keyboardType(.decimalPad)
            .textFieldStyle(.roundedBorder)
    }

    var resultView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 30) {
                Text(viewModel.searchPrice ?? 1, format: .currency(code: "CNY"))
                Group {
                    Text(viewModel.changetoWon ?? 180 ,format: .currency(code: "KRW")) + Text("원")
                }.font(.system(size: 48, weight: .semibold))
            }
            Spacer()
        }
    }

    var priceTitleView: some View {
        HStack(spacing: 0) {
            ZStack {
                Color.redBrand
                    .opacity(0.3)
                Text("元")
            }
            ZStack {
                Color.purpleBackground
                    .opacity(0.3)
                Text("₩")
            }
        }
        .foregroundStyle(Color.white)
        .font(.system(size: 40))
        .frame(height: 56)
        .overlay {
            Triangle()
                .frame(width: 20, height: 28)
                .offset(x: 10)
                .foregroundStyle(Color.brandred)
                .opacity(0.5)
        }
    }
    var priceInfoView: some View {
        VStack {
            priceTitleView
            List {
                ForEach(viewModel.yuanWonDict.sorted(by: <), id: \.key) { key, value in
                    HStack {
                        Text(key, format: .number) + Text("元")
                        Spacer()
                        Text(value, format: .number) + Text("원")
                    }
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(Color.white)
                    .opacity(0.9)
                    .listStyle(.plain)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
        }
        .background {
            LinearGradient(colors: [Color.brandred, Color.purpleDark], startPoint: .leading, endPoint: .trailing)
        }
    }
}

#Preview {
    RateView(viewModel: .init(rateService: .init()))
}
