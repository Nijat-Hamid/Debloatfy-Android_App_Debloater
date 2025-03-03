//
//  SectionMod.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/1/25.
//

import SwiftUI

struct SectionMod:ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth:.infinity)
            .padding()
            .background(Color.backgroundCard)
            .clipShape(.rect(cornerRadius: 8))
            .shadow(color: Color.black.opacity(0.15), radius: 7, x: 0, y: 2)
            .modifier(ColorSchemeTransition())
    }
    
}
