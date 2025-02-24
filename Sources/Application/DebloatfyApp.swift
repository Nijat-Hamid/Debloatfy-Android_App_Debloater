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
        }
        .windowStyle(.hiddenTitleBar)
    }
}
