//
//  CoinsViewModel.swift
//  Networking_Crypto
//
//  Created by YURIY IZBASH on 10. 1. 25.
//

import Foundation

class CoinsViewModel: ObservableObject {
    
    @Published var coins = [Coin]()
    @Published var errorMessage: String?
    
    private let service = CoinDataService()
    
    init() {
        Task {
            do {
                try await fetchCoins()
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func fetchCoins() async throws {
        do {
            let fetchedCoins = try await service.fetchCoins()
            DispatchQueue.main.async {
                self.coins = fetchedCoins
            }
        } catch let error as CoinAPIError {
            DispatchQueue.main.async {
                self.errorMessage = error.customDescription
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
            }
        }
    }
    
    /*
     func fetchCoinsWithCompletionHandler() {
     /*
      service.fetchCoins { coins, error  in
      DispatchQueue.main.async {
      if let error = error {
      self.errorMessage = error.localizedDescription
      return
      }
      
      self.coins = coins ?? []
      }
      }
      */
     service.fetchCoinsWithResult { [weak self] result in
     DispatchQueue.main.async {
     switch result {
     case .success(let coins):
     self?.coins = coins
     case .failure(let error):
     self?.errorMessage = error.localizedDescription
     }
     }
     }
     }
     */
}
