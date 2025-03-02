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
            .background(Color.backgroundCard)
            .clipShape(.rect(cornerRadius: 8))
            .modifier(ColorSchemeTransition())
    }
    
}
