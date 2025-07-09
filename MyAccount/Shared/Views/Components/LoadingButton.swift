//
//  LoadingButton.swift
//  MyAccount
//
//  Created by Kumar Abhinav on 2025-07-07.
//

import SwiftUI

struct LoadingButton: View {
    let title: String
    let isLoading: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(0.8)
                } else {
                    Text(title)
                        .font(.system(size: 20))
                        
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 32)
        }
        .disabled(isLoading)
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    VStack {
        LoadingButton(title: "Login", isLoading: false) {
            print("Login tapped")
        }
        
        LoadingButton(title: "Login", isLoading: true) {
            print("Login tapped")
        }
    }
    .padding()
}
