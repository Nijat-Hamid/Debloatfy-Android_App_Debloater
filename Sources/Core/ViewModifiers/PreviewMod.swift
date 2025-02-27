//
//  PreviewMod.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/27/25.
//

import SwiftUI

struct PreviewMod: ViewModifier {
    
    private var width: CGFloat = 150
    private var height: CGFloat?
    private var padding: CGFloat = 10
    
    init(width: CGFloat = 150, height: CGFloat? = nil, padding: CGFloat = 10) {
        self.width = width
        self.height = height
        self.padding = padding
    }
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .frame(width: width, height: height)
    }
}
