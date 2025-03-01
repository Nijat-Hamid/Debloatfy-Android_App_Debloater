//
//  AppMod.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/20/25.
//

import SwiftUI

struct AppMod:ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background(Color.backgroundPrimary.ignoresSafeArea())
            .foregroundStyle(Color.primary)
            .frame(minWidth:900,maxWidth: 900,minHeight: 500,maxHeight: 500)
    }
    
}
