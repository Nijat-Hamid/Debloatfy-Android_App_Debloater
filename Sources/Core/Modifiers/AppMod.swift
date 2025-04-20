//
//  AppMod.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/20/25.
//

import SwiftUI

struct AppMod:ViewModifier {
    @State private var router = Router()
    @State private var auth = Auth.shared
    
    func body(content: Content) -> some View {
        content
            .environment(\.font, .appBody)
            .environment(router)
            .environment(auth)
            .background(VisualEffect(.background).ignoresSafeArea())
            .foregroundStyle(Color.primary)
            .frame(width: 1000,height: 500)
            .task(id:router.currentPage ,priority: .high) {
                await auth.startServer()
            }
    }
}
