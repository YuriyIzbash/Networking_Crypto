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
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(width: 200)
                    .foregroundColor(Color(.label))
                    .background(Color(.lightGray))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                   
                    
            } else {
                Text("\(viewModel.coin): \(viewModel.price)")
            }
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
