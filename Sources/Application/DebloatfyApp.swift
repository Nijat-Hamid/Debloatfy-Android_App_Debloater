//
//  DebloatfyApp.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/12/25.
//

import SwiftUI

@main
struct DebloatfyApp: App {
    var body: some Scene {
        WindowGroup {
//            DebuggingView()
//                .modifier(AppMod())
//                .modifier(ColorSchemeTransition())
            
            LayoutView()
                .modifier(AppMod())
                .modifier(ColorSchemeTransition())
                .modifier(RemoveFocusOnTapModifier())
        }
        .windowToolbarStyle(.unifiedCompact)
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 900, height: 500)
        .windowResizability(.contentSize)
    }
}
