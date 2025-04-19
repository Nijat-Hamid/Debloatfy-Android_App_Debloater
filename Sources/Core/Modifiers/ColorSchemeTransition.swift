//
//  ColorSchemeTransition.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/24/25.
//

import SwiftUI

struct ColorSchemeTransition:ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    @AppStorage("userTheme") private var userTheme:Theme = .dark
    @State private var isInitialLoad = true
  
    func body(content: Content) -> some View {
        content
            .preferredColorScheme(userTheme.colorScheme)
            .animation(isInitialLoad ? nil : .snappy, value: colorScheme)
            .onAppear {
                Task { @MainActor in
                    try? await Task.sleep(for: .seconds(0.5))
                    isInitialLoad = false
                }
            }
    }
    
}
