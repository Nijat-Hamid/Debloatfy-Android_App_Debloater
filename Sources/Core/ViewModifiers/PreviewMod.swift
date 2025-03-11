//
//  PreviewMod.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/27/25.
//

import SwiftUI

enum PreviewType {
    case background,card,none
}

struct PreviewMod: ViewModifier {
    
    private let width: CGFloat?
    private let height: CGFloat?
    private let padding: CGFloat?
    private let previewType:PreviewType
    
    init(type:PreviewType = .background, width: CGFloat? = 150, height: CGFloat? = nil, padding: CGFloat? = 10) {
        self.width = width
        self.height = height
        self.padding = padding
        self.previewType = type
    }
    
    private var background: AnyView {
        switch previewType {
        case .background:
            return AnyView(VisualEffect(.background))
        case .card:
            return AnyView(VisualEffect(.card))
        case .none:
            return AnyView(Color.clear)
        }
    }
    
    func body(content: Content) -> some View {
        content
            .padding(.all, padding)
            .frame(width: width, height: height)
            .background(background)
        
    }
}
