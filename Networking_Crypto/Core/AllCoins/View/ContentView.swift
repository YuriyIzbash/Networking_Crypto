//
//  ContentView.swift
//  Networking_Crypto
//
//  Created by YURIY IZBASH on 10. 1. 25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = CoinsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.coins) { coin in
                HStack(spacing: 12) {
                    Text("\(coin.marketCapRank)")
                        .foregroundStyle(.gray)
                    
                    AsyncImage (url: coin.image) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.orange)
                    } placeholder: {
                        Circle ()
                            .frame(width: 32, height: 32)
                            .background (Color (.systemGray5))
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(coin.name)
                        Text(coin.symbol.uppercased())
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 6) {
                        Text("$\(coin.currentPrice, specifier: "%.2f")")
                            .bold()
                        Text("\(coin.priceChangePercentage, specifier: "%.2f")%")
                            .foregroundColor(coin.priceChangePercentage >= 0 ? .green : .red)
                    }
                }
                .padding(.vertical, 8)
            }
            
            // Loading Indicator
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                Color.clear
                    .onAppear {
                        Task {
                            do {
                                try await viewModel.fetchCoins()
                            } catch {
                                print("Failed to fetch coins: \(error.localizedDescription)")
                            }
                        }
                    }
            }
        }
        .overlay {
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .listStyle(.insetGrouped)
    }
}

#Preview {
    ContentView()
}
