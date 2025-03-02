//
//  AppMod.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/20/25.
//

import SwiftUI

struct AppMod:ViewModifier {
    @State private var router = Router()
    
    func body(content: Content) -> some View {
        content
            .environment(\.font, .appBody)
            .environment(\.router, router)
            .background(Color.backgroundPrimary.ignoresSafeArea())
            .foregroundStyle(Color.primary)
            .frame(width: 900,height: 500)
    }
}
