//
//  ErrorView.swift
//  MyAccount
//
//  Created by Kumar Abhinav on 2025-07-07.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let onRetry: (() -> Void)?
    
    init(message: String, onRetry: (() -> Void)? = nil) {
        self.message = message
        self.onRetry = onRetry
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.red)
            
            Text("Error")
                .font(.headline)
                .foregroundColor(.red)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            if let onRetry = onRetry {
                Button("Retry", action: onRetry)
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(Constants.UI.cornerRadius)
    }
}

#Preview {
    VStack {
        ErrorView(message: "Failed to load data") {
            print("Retry tapped")
        }
        
        ErrorView(message: "Network connection failed")
    }
    .padding()
}
