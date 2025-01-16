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
    private var currentPage = 1
    var isLoading = false
    
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
        guard !isLoading else { return }
                isLoading = true
                
                do {
                    let newCoins = try await service.fetchCoins(page: currentPage)
                    DispatchQueue.main.async {
                        self.coins.append(contentsOf: newCoins)
                        self.currentPage += 1
                        self.isLoading = false
                    }
                } catch let error as CoinAPIError {
                    DispatchQueue.main.async {
                        self.errorMessage = error.customDescription
                        self.isLoading = false
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
                        self.isLoading = false
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
