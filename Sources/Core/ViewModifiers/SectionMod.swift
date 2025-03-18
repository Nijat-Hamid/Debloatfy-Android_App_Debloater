//
//  SectionMod.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/1/25.
//

import SwiftUI

enum SectionType {
    case automatic
    case fullWidth
}

struct SectionMod:ViewModifier {

    private let sectionType:SectionType
    private let alignment:Alignment
    
    init(sectionType: SectionType = .fullWidth,alignment:Alignment = .center) {
        self.sectionType = sectionType
        self.alignment = alignment
    }
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: sectionType == .automatic ? nil : .infinity,alignment:alignment)
            .padding()
            .background(VisualEffect(.card))
            .clipShape(.rect(cornerRadius: 8))
            .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 0)
            .shadow(color: Color.black.opacity(0.2), radius: 12.5, x: 0, y: 0)
            .modifier(ColorSchemeTransition())
    }
    
}
