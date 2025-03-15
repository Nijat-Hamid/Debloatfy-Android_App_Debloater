//
//  PageMod.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/19/25.
//

import SwiftUI

struct PageMod:ViewModifier {

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 12)
            .padding(.bottom, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
