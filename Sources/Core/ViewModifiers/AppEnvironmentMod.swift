//
//  AppEnviromentMod.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/23/25.
//

import SwiftUI

struct AppEnviromentMod:ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .environment(\.font, .appBody)
            .environment(\.router, Router())
    }
}
