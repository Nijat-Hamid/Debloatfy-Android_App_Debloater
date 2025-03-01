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
            LayoutView()
                .modifier(AppMod())
                .modifier(AppEnviromentMod())
                .modifier(ColorSchemeTransition())
                .frame(minWidth:900,maxWidth: 900,minHeight: 500,maxHeight: 500)
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 900, height: 500)
        .windowResizability(.contentSize)
    }
}
