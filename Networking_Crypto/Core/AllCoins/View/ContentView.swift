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
        VStack {
            
            Text("\(viewModel.coin): $ \(viewModel.price)")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
