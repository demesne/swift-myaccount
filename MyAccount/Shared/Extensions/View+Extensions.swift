//
//  View+Extensions.swift
//  MyAccount
//
//  Created by Kumar Abhinav on 2025-07-07.
//

import SwiftUI

extension View {
    /// Apply a rounded background with shadow
    func cardStyle() -> some View {
        self        
            .cornerRadius(Constants.UI.cornerRadius)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    /// Apply standard padding
    func standardPadding() -> some View {
        self.padding(Constants.UI.padding)
    }
    
    /// Conditionally apply a modifier
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    /// Apply a loading overlay
    func loadingOverlay(_ isLoading: Bool) -> some View {
        ZStack {
            self
                .disabled(isLoading)
                .opacity(isLoading ? 0.6 : 1.0)
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            }
        }
    }
    
    /// Apply error overlay
    func errorOverlay(_ errorMessage: String?, onRetry: (() -> Void)? = nil) -> some View {
        ZStack {
            self
            
            if let errorMessage = errorMessage {
                ErrorView(message: errorMessage, onRetry: onRetry)
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
    }
}

// MARK: - UIColor Extensions for SwiftUI
#if canImport(UIKit)
extension Color {
    static let systemBackground = Color(UIColor.systemBackground)
    static let secondarySystemBackground = Color(UIColor.secondarySystemBackground)
    static let tertiarySystemBackground = Color(UIColor.tertiarySystemBackground)
    static let label = Color(UIColor.label)
    static let secondaryLabel = Color(UIColor.secondaryLabel)
    static let tertiaryLabel = Color(UIColor.tertiaryLabel)
}
#endif
