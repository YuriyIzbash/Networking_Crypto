//
//  CoinsViewModel.swift
//  Networking_Crypto
//
//  Created by YURIY IZBASH on 10. 1. 25.
//

import Foundation

class CoinsViewModel: ObservableObject {
    @Published var coin = ""
    @Published var price = ""
    @Published var errorMessage: String?
    
    init() {
        fetchPrice(coin: "litecoin")
    }
    
    func fetchPrice(coin: String) {
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(coin)&vs_currencies=usd"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("DEBUG: Failed with error: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.errorMessage = "Bad HTTP response"
                    return
                }
                guard httpResponse.statusCode == 200 else {
                    print("DEBUG: Failed with status code: \(httpResponse.statusCode)")
                    self.errorMessage = "Failed with status code: \(httpResponse.statusCode)"
                    return
                }
                guard let data = data else { return }
                guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
                guard let value = jsonObject[coin] as? [String: Double] else { return }
                guard let price = value["usd"] else { return }
                
                self.coin = coin.capitalized
                self.price = "$ \(price)"
            }
        }.resume()
    }
}
