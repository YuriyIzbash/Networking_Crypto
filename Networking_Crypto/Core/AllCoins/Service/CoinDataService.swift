//
//  CoinDataService.swift
//  Networking_Crypto
//
//  Created by YURIY IZBASH on 10. 1. 25.
//

import Foundation

class CoinDataService {
    
    private let baseURL = "https://api.coingecko.com/api/v3/coins/markets"
    private var page = 1
    private let perPage = 20
    
    func fetchCoins(page: Int) async throws -> [Coin] {
        
        let urlString = "\(baseURL)?vs_currency=usd&order=market_cap_desc&per_page=\(perPage)&page=\(page)"
        
        guard let url = URL(string: urlString) else {
            throw CoinAPIError.requestFailed(description: "Invalid URL")
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw CoinAPIError.requestFailed(description: "Invalid response")
        }
        
        guard httpResponse.statusCode == 200 else {
            throw CoinAPIError.invalidStatusCode(statusCode: httpResponse.statusCode)
        }
        
        do {
            let coins = try JSONDecoder().decode([Coin].self, from: data)
            return coins
        } catch {
            throw CoinAPIError.jsonParsingFailure
        }
    }
}


// MARK: - Completion Handler
/*
 extension CoinDataService {
 func fetchCoinsWithResult(completion: @escaping(Result<[Coin], CoinAPIError>) -> Void) {
 guard let url = URL(string: urlString) else { return }
 
 URLSession.shared.dataTask(with: url) { data, response, error in
 if let error = error {
 completion(.failure(.unknownError(error: error)))
 return
 }
 
 guard let httpResponse = response as? HTTPURLResponse else {
 completion(.failure(.requestFailed(description: "Request failed")))
 return
 }
 guard httpResponse.statusCode == 200 else {
 completion(.failure(.invalidStatusCode(statusCode: httpResponse.statusCode)))
 return
 }
 
 guard let data = data else {
 completion(.failure(.invalidData))
 return
 }
 do {
 let coins = try JSONDecoder().decode([Coin].self, from: data)
 completion(.success(coins))
 } catch {
 print("DEBUG: Failed to decode coins - \(error)")
 completion(.failure(.jsonParsingFailure))
 }
 }.resume()
 }
 
 /*
  func fetchCoins(completion: @escaping([Coin]?, Error?) -> Void) {
  guard let url = URL(string: urlString) else { return }
  
  URLSession.shared.dataTask(with: url) { data, response, error in
  if let error = error {
  completion(nil, error)
  return
  }
  
  guard let data = data else { return }
  
  guard let coins = try? JSONDecoder().decode([Coin].self, from: data) else {
  print("DEBUG: Failed to decode coins")
  return
  }
  
  completion(coins, nil)
  
  }.resume()
  }
  */
 
 func fetchPrice(coin: String, completion: @escaping(Double) -> Void) {
 let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(coin)&vs_currencies=usd"
 guard let url = URL(string: urlString) else { return }
 
 URLSession.shared.dataTask(with: url) { data, response, error in
 if let error = error {
 print("DEBUG: Failed with error: \(error.localizedDescription)")
 //                    self.errorMessage = error.localizedDescription
 return
 }
 
 guard let httpResponse = response as? HTTPURLResponse else {
 //                    self.errorMessage = "Bad HTTP response"
 return
 }
 guard httpResponse.statusCode == 200 else {
 //                    self.errorMessage = "Failed with status code: \(httpResponse.statusCode)"
 return
 }
 
 guard let data = data else { return }
 guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
 guard let value = jsonObject[coin] as? [String: Double] else { return }
 guard let price = value["usd"] else { return }
 
 //                self.coin = coin.capitalized
 //                self.price = "$ \(price)"
 print("DEBUG: \(coin) price \(price)")
 completion(price)
 }.resume()
 }
 }
 */
