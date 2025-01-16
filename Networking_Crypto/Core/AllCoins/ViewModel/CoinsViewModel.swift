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
        loadData()
    }
    
    @MainActor
    func fetchCoins() async throws {
        guard !isLoading else { return }
        isLoading = true
        
        do {
            let newCoins = try await service.fetchCoins(page: currentPage)
            
            self.coins.append(contentsOf: newCoins)
            self.currentPage += 1
            self.isLoading = false
            
        } catch let error as CoinAPIError {
            
            self.errorMessage = error.customDescription
            self.isLoading = false
            
        } catch {
            
            self.errorMessage = "\(error.localizedDescription)"
            self.isLoading = false
        }
    }
    
    func loadData() {
        Task(priority: .medium) {
            try await fetchCoins()
        }
    }
    
    func handleRefresh() {
        coins.removeAll()
        currentPage = 1
        loadData()
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
