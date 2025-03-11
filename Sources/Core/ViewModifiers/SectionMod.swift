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
            .background(VisualEffect(material: .titlebar ,alpha: 0.5))
            .clipShape(.rect(cornerRadius: 8))
            .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 0)
            .shadow(color: Color.black.opacity(0.2), radius: 12.5, x: 0, y: 0)
            .modifier(ColorSchemeTransition())
    }
    
}
