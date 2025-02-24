//
//  ColorSchemeTransition.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/24/25.
//

import SwiftUI

struct ColorSchemeTransition:ViewModifier {
    @Environment(\.colorScheme) private var scheme
    func body(content: Content) -> some View {
        content
            .animation(.smooth, value: scheme)
    }
    
}
